import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:markets/generated/i18n.dart';
import 'package:markets/src/models/cart.dart';
import 'package:markets/src/repository/cart_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:markets/src/helpers/helper.dart';
import '../models/address.dart';
import '../models/market.dart';
import '../models/product.dart';
import '../repository/market_repository.dart';
import '../repository/product_repository.dart';
import '../repository/search_repository.dart';
import '../repository/settings_repository.dart';
import '../helpers/global.dart';

class SearchController extends ControllerMVC {
  List<Market> markets = <Market>[];
  List<Product> products = <Product>[];
  List<Product> _products = <Product>[];
  List<Cart> carts = [];
  bool loadCart = false;
  bool stop = false;
  double quantity = 1;
  GlobalKey<ScaffoldState> scaffoldKey;

  SearchController() {
    listenForMarkets();
    listenForProducts();
    listenForCart();
  }

  //   void listenForCart() async {
  //   carts = [];
  //   final Stream<Cart> stream = await getCart();
  //   stream.listen((Cart _cart) {
  //     carts.add(_cart);

  //   }).onDone(() {setState((){this.stop = false;this.loadCart = false;});});
  // }

  void listenForMarkets({String search}) async {
    if (search == null) {
      search = await getRecentSearch();
    }
    Address _address = deliveryAddress.value;
    final Stream<Market> stream = await searchMarkets(search, _address);
    stream.listen((Market _market) {
      setState(() => markets.add(_market));
    }, onError: (a) {
      Helper.printToConsole(a);
    }, onDone: () {});
  }

  void listenForProducts({String search}) async {
    if (search == null) {
      search = await getRecentSearch();
    }
    if (stopClick == false) {
      setState(() {
        stopClick = true;
      });

      Address _address = deliveryAddress.value;
      final Stream<Product> stream = await searchProducts(search, _address);
      // products = <Product>[];
      stream.listen((Product _product) {
        if (_product.inStock)
          setState(() {
            _products.add(_product);
          });
      }, onError: (a) {
        Helper.printToConsole(a);
      }, onDone: () {
        setState(() {
          stopClick = false;
          products = _products.toSet().toList();
        });
      });
    }
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

  void addToCart(Product product, {bool reset = false, context}) async {
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
          // ));
          Flushbar(
            // title:  "Ooops !!",
            message: S.current.this_product_was_added_to_cart,
            duration: Duration(seconds: 1),
            flushbarPosition: FlushbarPosition.BOTTOM,
          )..show(context);
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
          // scaffoldKey?.currentState?.showSnackBar(SnackBar(
          //   content: Text(S.current.this_product_was_added_to_cart),
          // ));
        });
      }
    }
  }

  bool isSameMarkets(Product product) {
    if (carts.isNotEmpty) {
      return carts[0].product?.market?.id == product.market?.id;
    }
    return true;
  }

  bool isAllUnique(Product product) {
    if (carts.isNotEmpty) {
      if (carts[0].product?.market?.id == product.market.id &&
          product.unique == carts[0].product?.unique) return true;
      return carts[0].product?.unique == product.unique;
    }
    return true;
  }

  Cart isExistInCart(Cart _cart) {
    return carts.firstWhere((Cart oldCart) => _cart.isSame(oldCart),
        orElse: () => null);
  }

  Future<void> refreshSearch(search) async {
    setState(() {
      markets = <Market>[];
      products = <Product>[];
      _products = <Product>[];
    });
    listenForMarkets(search: search);
    listenForProducts(search: search);
  }

  void saveSearch(String search) {
    setRecentSearch(search);
  }
}
