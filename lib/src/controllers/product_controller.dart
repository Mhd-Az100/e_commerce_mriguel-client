import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:markets/src/helpers/helper.dart';
import '../../generated/i18n.dart';
import '../models/cart.dart';
import '../models/favorite.dart';
import '../models/option.dart';
import '../models/product.dart';
import '../repository/cart_repository.dart';
import '../repository/product_repository.dart';

class ProductController extends ControllerMVC {
  Product product;
  double quantity = 1;
  double total = 0;
  List<Cart> carts = [];
  List<Product> trendingProducts = <Product>[];
  Favorite favorite;
  bool loadCart = false;
  bool stop = false;
  GlobalKey<ScaffoldState> scaffoldKey;

  ProductController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForProduct({String productId, String message}) async {
    final Stream<Product> stream = await getProduct(productId);
    stream.listen((Product _product) {
      setState(() => product = _product);
    }, onError: (a) {
      Helper.printToConsole(a);
      scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      calculateTotal();
      if (message != null) {
        scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForTrendingProducts(String idMarket) async {
    final Stream<Product> stream = await getTrendingProductsOfMarket(idMarket);
    stream.listen((Product _product) {
      setState(() => trendingProducts.add(_product));
    }, onError: (a) {
      Helper.printToConsole(a);
    }, onDone: () {});
  }

  void listenForFavorite({String productId}) async {
    final Stream<Favorite> stream = await isFavoriteProduct(productId);
    stream.listen((Favorite _favorite) {
      setState(() => favorite = _favorite);
    }, onError: (a) {
      Helper.printToConsole(a);
    });
  }

  void listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      carts.add(_cart);
    }).onDone(() {
      setState(() {
        this.stop = false;
        this.loadCart = false;
      });
    });
  }

  bool isSameMarkets(Product product) {
    if (carts.isNotEmpty) {
      return carts[0].product?.market?.id == product.market?.id;
    }
    return true;
  }

  // bool isAllUnique(Product product) {
  //   if (carts.isNotEmpty) {
  //     if (carts[0].product?.market?.id == product.market.id &&
  //         product.unique == carts[0].product?.unique &&
  //         isSameMarket(product.market.id)) return true;
  //   }
  //   return false;
  // }

  bool isAllUnique(Product product) {
    if (carts.isNotEmpty) {
      if (carts[0].product?.market?.id == product.market.id &&
          product.unique == carts[0].product?.unique) return true;
      return carts[0].product?.unique == product.unique;
    }
    return true;
  }

  bool isSameMarket(id) {
    bool same = true;
    for (var cart in carts) {
      if (cart.product.market.id != id) {
        same = false;
      }
    }
    return same;
  }

  void addToCart(Product product, {bool reset = false}) async {
    setState(() {
      this.loadCart = true;
    });
    if (stop == false) {
      var _newCart = new Cart();
      _newCart.product = product;
      _newCart.options =
          product.options.where((element) => element.checked).toList();
      _newCart.quantity = this.quantity;
      // if product exist in the cart then increment quantity
      var _oldCart = isExistInCart(_newCart);
      if (_oldCart != null) {
        this.stop = true;
        _oldCart.quantity += this.quantity;
        updateCart(_oldCart).then((value) {
          setState(() {
            this.loadCart = false;
          });
        }).whenComplete(() {
          setState(() {
            this.stop = false;
            this.loadCart = false;
          });
          // scaffoldKey?.currentState?.showSnackBar(SnackBar(
          //   content: Text(S.current.this_product_was_added_to_cart),
          //   behavior: SnackBarBehavior.floating,
          //   duration: Duration(milliseconds: 500),
          // ));
          Flushbar(
            // title:  "Ooops !!",
            message: S.current.this_product_was_added_to_cart,
            duration: Duration(seconds: 1),
            flushbarPosition: FlushbarPosition.TOP,
          )..show(scaffoldKey.currentState.context);
        });
      } else {
        // the product doesnt exist in the cart add new one
        this.stop = true;
        addCart(_newCart, reset).then((value) {
          setState(() {
            this.loadCart = false;
          });
        }).whenComplete(() {
          listenForCart();
          Flushbar(
            // title:  "Ooops !!",
            message: S.current.this_product_was_added_to_cart,
            duration: Duration(seconds: 1),
            flushbarPosition: FlushbarPosition.TOP,
          )..show(scaffoldKey.currentState.context);
        });
      }
    }
  }
  // void addToCart(Product product, {bool reset = false}) async {
  //   setState(() {
  //     this.loadCart = true;
  //   });
  //   var _newCart = new Cart();
  //   _newCart.product = product;
  //   _newCart.options = product.options.where((element) => element.checked).toList();
  //   _newCart.quantity = this.quantity;
  //   // if product exist in the cart then increment quantity
  //   var _oldCart = isExistInCart(_newCart);
  //   if (_oldCart != null) {
  //     _oldCart.quantity += this.quantity;
  //     updateCart(_oldCart).then((value) {
  //       setState(() {
  //         this.loadCart = false;
  //       });
  //     }).whenComplete(() {
  //       scaffoldKey?.currentState?.showSnackBar(SnackBar(
  //         content: Text(S.current.this_product_was_added_to_cart),
  //       ));
  //     });
  //   } else {
  //     // the product doesnt exist in the cart add new one
  //     addCart(_newCart, reset).then((value) {
  //       setState(() {
  //         this.loadCart = false;
  //       });
  //     }).whenComplete(() {
  //       scaffoldKey?.currentState?.showSnackBar(SnackBar(
  //         content: Text(S.current.this_product_was_added_to_cart),
  //       ));
  //     });
  //   }
  // }

  Cart isExistInCart(Cart _cart) {
    return carts.firstWhere((Cart oldCart) => _cart.isSame(oldCart),
        orElse: () => null);
  }

  void addToFavorite(Product product) async {
    var _favorite = new Favorite();
    _favorite.product = product;
    _favorite.options = product.options.where((Option _option) {
      return _option.checked;
    }).toList();
    addFavorite(_favorite).then((value) {
      setState(() {
        this.favorite = value;
      });
      Flushbar(
        // title:  "Ooops !!",
        message: S.current.this_product_was_added_to_favorite,
        duration: Duration(seconds: 1),
        flushbarPosition: FlushbarPosition.TOP,
      )..show(scaffoldKey.currentState.context);
    });
  }

  void removeFromFavorite(Favorite _favorite) async {
    removeFavorite(_favorite).then((value) {
      setState(() {
        this.favorite = new Favorite();
      });
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('This product was removed from favorites'),
      ));
    });
  }

  Future<void> refreshProduct() async {
    var _id = product.id;
    product = new Product();
    listenForFavorite(productId: _id);
    listenForProduct(productId: _id, message: 'Product refreshed successfuly');
  }

  void calculateTotal() {
    total = product?.price ?? 0;
    product.options.forEach((option) {
      total += option.checked ? option.price : 0;
    });
    total *= quantity;
    setState(() {});
  }

  incrementQuantity() {
    if (this.quantity <= 99) {
      ++this.quantity;
      calculateTotal();
    }
  }

  decrementQuantity() {
    if (this.quantity > 1) {
      --this.quantity;
      calculateTotal();
    }
  }
}
