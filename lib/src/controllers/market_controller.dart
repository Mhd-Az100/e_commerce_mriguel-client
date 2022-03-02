import 'package:flutter/material.dart';
import 'package:markets/src/helpers/global.dart';
import 'package:markets/src/models/cart.dart';
import 'package:markets/src/models/favorite.dart';
import 'package:markets/src/repository/cart_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:markets/src/helpers/helper.dart';
import '../../generated/i18n.dart';
import '../models/gallery.dart';
import '../models/market.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../repository/gallery_repository.dart';
import '../repository/market_repository.dart';
import '../repository/product_repository.dart';
import '../repository/settings_repository.dart';

class MarketController extends ControllerMVC {
  Market market;
  List<Gallery> galleries = <Gallery>[];
  List<Product> products = <Product>[];
  List<Product> trendingProducts = <Product>[];
  List<Product> featuredProducts = <Product>[];
  List<Review> reviews = <Review>[];
  Product product;
  double quantity = 1;
  double total = 0;
  List<Cart> carts = [];
  Favorite favorite;
  bool loadCart = false;
  bool stop = false;
  GlobalKey<ScaffoldState> scaffoldKey;

  MarketController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForMarket({String id, String message}) async {
    final Stream<Market> stream = await getMarket(id, deliveryAddress.value);
    stream.listen((Market _market) {
      setState(() => market = _market);
      listUsers = _market.users;
    }, onError: (a) {
      Helper.printToConsole(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      // this.market.categories.addAll(this.market.marketCategories);
      setState(() {});
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForCart() async {
    carts = [];
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

  void addToCart(Product product, {bool reset = false}) async {
    try {
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
            scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text(S.current.this_product_was_added_to_cart),
            ));
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
            scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text(S.current.this_product_was_added_to_cart),
            ));
          });
        }
      }
    } catch (e) {
      Helper.printToConsole(e);
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
  //   Helper.printToConsole(_newCart.toMap());
  //   // Helper.printToConsole(_oldCart.toMap());
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
  //       listenForCart();
  //       scaffoldKey?.currentState?.showSnackBar(SnackBar(
  //         content: Text(S.current.this_product_was_added_to_cart),
  //       ));
  //     });
  //   }
  // }

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
  //     // return carts[0].product?.unique == product.unique;
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
    for (var cart in carts) {
      if (cart.product.market.id != id) {
        return false;
      }
    }
    return true;
  }

  Cart isExistInCart(Cart _cart) {
    return carts.firstWhere((Cart oldCart) => _cart.isSame(oldCart),
        orElse: () => null);
  }

  void listenForGalleries(String idMarket) async {
    final Stream<Gallery> stream = await getGalleries(idMarket);
    stream.listen((Gallery _gallery) {
      setState(() => galleries.add(_gallery));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForMarketReviews({String id, String message}) async {
    final Stream<Review> stream = await getMarketReviews(id);
    stream.listen((Review _review) {
      setState(() => reviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForProducts(String idMarket) async {
    final Stream<Product> stream = await getProductsOfMarket(idMarket);
    stream.listen((Product _product) {
      setState(() => products.add(_product));
    }, onError: (a) {
      Helper.printToConsole(a);
    }, onDone: () {});
  }

  void listenForTrendingProducts(String idMarket) async {
    final Stream<Product> stream = await getTrendingProductsOfMarket(idMarket);
    stream.listen((Product _product) {
      setState(() => trendingProducts.add(_product));
    }, onError: (a) {
      Helper.printToConsole(a);
    }, onDone: () {});
  }

  void listenForFeaturedProducts(String idMarket) async {
    final Stream<Product> stream = await getFeaturedProductsOfMarket(idMarket);
    stream.listen((Product _product) {
      if (_product.featured) setState(() => featuredProducts.add(_product));
    }, onError: (a) {
      Helper.printToConsole(a);
    }, onDone: () {});
  }

  Future<void> refreshMarket() async {
    var _id = market.id;
    market = new Market();
    galleries.clear();
    reviews.clear();
    featuredProducts.clear();
    listenForMarket(id: _id, message: S.current.market_refreshed_successfuly);
    listenForMarketReviews(id: _id);
    listenForGalleries(_id);
    listenForFeaturedProducts(_id);
  }
}
