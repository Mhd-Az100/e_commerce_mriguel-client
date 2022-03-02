import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../models/cart.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../helpers/global.dart';
import '../repository/cart_repository.dart';
import '../repository/category_repository.dart';
import '../repository/product_repository.dart';

class CategoryController extends ControllerMVC {
  List<Product> products = <Product>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  Category category;
  Category subCategories;
  bool loadCart = false;
  double quantity = 1;
  List<Cart> carts = [];
  bool stop = false;
  bool isLoadingMore = false;
  String selectedCat = '-1';
  ScrollController scrollController;

  CategoryController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    // this.category
    // scrollController = ScrollController();
  }

  void listenForProductsByCategory(
      {String id, String message, String marketId}) async {
    this.products.clear();
    setState(() => selectedCat = '-1');
    final Stream<Product> stream = await getProductsByCategory(id);
    stream.listen((Product _product) {
      setState(() {
        products.add(_product);
      });
    }, onError: (a) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForProductsByMarketCategory(
      {String id, String message, String marketId}) async {
    setState(() {
      selectedCat = '-1';
      this.products.clear();
    });
    final Stream<Product> stream = await getProductsByMarketCategory(
      id,
      marketId,
      category: this.category,
    );
    stream.listen((Product _product) {
      setState(() {
        products.add(_product);
      });
    }, onError: (a) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForProductsByMarketSubCategory(
      {String id, String message, String marketId}) async {
    setState(() {
      this.products.clear();
      this.selectedCat = id;
    });
    final Stream<Product> stream = await getProductsByMarketSubCategory(
      subcategoryId: id,
      marketId: marketId,
      category: this.category,
    );
    stream.listen((Product _product) {
      setState(() {
        products.add(_product);
      });
    }, onError: (a) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForProductsByMarketSubCategoryForMarket(
      {String id, String message, String marketId}) async {
    setState(() {
      this.products.clear();
      this.selectedCat = id;
    });
    final Stream<Product> stream =
        await getProductsByMarketSubCategoryForMarket(
      subcategoryId: id,
      marketId: marketId,
      category: this.category,
    );
    stream.listen((Product _product) {
      setState(() {
        products.add(_product);
      });
    }, onError: (a) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForPaginateSubCatMarketProducts(
      {String id, String message, String marketId}) async {
    if (isLoadingMore == false &&
        productsPaginate.currentPage < productsPaginate.lastPage) {
      setState(() {
        isLoadingMore = true;
      });
      productsPaginate.currentPage++;
      final Stream<Product> stream = await getSubCatProductsByMarketPaginate(
          productsPaginate.currentPage, id, marketId,
          category: this.category);
      stream.listen((Product _product) {
        setState(() {
          products.add(_product);
        });
      }, onError: (a) {
        setState(() {
          isLoadingMore = false;
        });
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(S.current.verify_your_internet_connection),
        ));
      }, onDone: () {
        setState(() {
          isLoadingMore = false;
        });
        // if (message != null) {
        //   scaffoldKey.currentState.showSnackBar(SnackBar(
        //     content: Text(message),
        //   ));
        // }
      });
    }
  }

  void listenForPaginateMarketProducts(
      {String id, String message, String marketId}) async {
    if (isLoadingMore == false &&
        productsPaginate.currentPage < productsPaginate.lastPage) {
      setState(() {
        isLoadingMore = true;
      });
      productsPaginate.currentPage++;
      final Stream<Product> stream = await getProductsByMarketPaginate(
          productsPaginate.currentPage, id, marketId,
          category: this.category);
      stream.listen((Product _product) {
        setState(() {
          products.add(_product);
        });
      }, onError: (a) {
        setState(() {
          isLoadingMore = false;
        });
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(S.current.verify_your_internet_connection),
        ));
      }, onDone: () {
        setState(() {
          isLoadingMore = false;
        });
        // if (message != null) {
        //   scaffoldKey.currentState.showSnackBar(SnackBar(
        //     content: Text(message),
        //   ));
        // }
      });
    }
  }

  void listenForPaginateProducts(
      {String id, String message, String marketId}) async {
    if (isLoadingMore == false &&
        productsPaginate.currentPage < productsPaginate.lastPage) {
      setState(() {
        isLoadingMore = true;
      });
      productsPaginate.currentPage++;
      final Stream<Product> stream =
          await getProductsByPaginate(productsPaginate.currentPage, id);
      stream.listen((Product _product) {
        setState(() {
          products.add(_product);
        });
      }, onError: (a) {
        setState(() {
          isLoadingMore = false;
        });
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(S.current.verify_your_internet_connection),
        ));
      }, onDone: () {
        setState(() {
          isLoadingMore = false;
        });
      });
    }
  }

  void listenForPaginateProductsByMarketCategory(
      {String id, String message, String marketId}) async {
    if (isLoadingMore == false &&
        productsPaginate.currentPage < productsPaginate.lastPage) {
      setState(() {
        isLoadingMore = true;
      });
      productsPaginate.currentPage++;
      final Stream<Product> stream =
          await getProductsMarketSubCategoriesByPaginate(
              productsPaginate.currentPage, id, marketId);
      stream.listen((Product _product) {
        setState(() {
          products.add(_product);
        });
      }, onError: (a) {
        setState(() {
          isLoadingMore = false;
        });
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(S.current.verify_your_internet_connection),
        ));
      }, onDone: () {
        setState(() {
          isLoadingMore = false;
        });
      });
    }
  }

  void listenForPaginateProductsByMarketSubCategory(
      {String id, String message, String marketId, String subcat}) async {
    if (isLoadingMore == false &&
        productsPaginate.currentPage < productsPaginate.lastPage) {
      setState(() {
        isLoadingMore = true;
      });
      productsPaginate.currentPage++;
      final Stream<Product> stream =
          await getProductsMarketSubCategoriesByPaginateSubCat(
              productsPaginate.currentPage, id, marketId, subcat);
      stream.listen((Product _product) {
        setState(() {
          products.add(_product);
        });
      }, onError: (a) {
        setState(() {
          isLoadingMore = false;
        });
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(S.current.verify_your_internet_connection),
        ));
      }, onDone: () {
        setState(() {
          isLoadingMore = false;
        });
      });
    }
  }

  void listenForPaginateProductsBySub(
      {String id, String message, String marketId}) async {
    if (isLoadingMore == false &&
        productsPaginate.currentPage < productsPaginate.lastPage) {
      setState(() {
        isLoadingMore = true;
      });
      productsPaginate.currentPage++;
      final Stream<Product> stream =
          await getProductsByMarketSubCategoryPaginate(
              page: productsPaginate.currentPage, subcategoryId: id);
      stream.listen((Product _product) {
        setState(() {
          products.add(_product);
        });
      }, onError: (a) {
        setState(() {
          isLoadingMore = false;
        });
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(S.current.verify_your_internet_connection),
        ));
      }, onDone: () {
        setState(() {
          isLoadingMore = false;
        });
      });
    }
  }

  void listenForCategory({String id, String message, Category cat}) async {
    category = cat;
    if (this.category.subCategories.length > 0) {
      if (this.category.subCategories.elementAt(0).id != '-1')
        this
            .category
            .subCategories
            .insert(0, Category(id: '-1', name: S.current.all));
    }
    setState(() {});
    // final Stream<Category> stream = await getCategory(id);
    // stream.listen((Category _category) {
    //   setState(() => category = _category);
    // }, onError: (a) {
    //   // Helper.printToConsole(a);
    //   scaffoldKey.currentState.showSnackBar(SnackBar(
    //     content: Text(S.current.verify_your_internet_connection),
    //   ));
    // }, onDone: () {
    //   if (message != null) {
    //     scaffoldKey.currentState.showSnackBar(SnackBar(
    //       content: Text(message),
    //     ));
    //   }
    // });
  }

  // Future<void> listenForSubCategories(Category cat) async {
  //   final Stream<Category> stream = await getSubCategories(cat.id);
  //   stream.listen((Category _category) {
  //     setState(() => subCategories = _category);
  //   }, onError: (a) {
  //     Helper.printToConsole(a);
  //   }, onDone: () {
  //     Helper.printToConsole(
  //         'sub categories ---------------------------------- ${subCategories.subCategories.length}');
  //   });
  // }

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

  /*void addToCart(Product product, {bool reset = false}) async {
    setState(() {
      this.loadCart = true;
    });
    var _cart = new Cart();
    _cart.product = product;
    _cart.options = [];
    _cart.quantity = 1;
    addCart(_cart, reset).then((value) {
      setState(() {
        this.loadCart = false;
      });
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.this_product_was_added_to_cart),
      ));
    });
  }*/

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
  }

  Cart isExistInCart(Cart _cart) {
    return carts.firstWhere((Cart oldCart) => _cart.isSame(oldCart),
        orElse: () => null);
    // for (var item in carts) {
    //   if(item.product.id == _cart.product.id) return _cart;
    // }

    // return null;
  }

  Future<void> refreshCategory() async {
    products.clear();
    // category = new Category();
    listenForProductsByCategory(
        message: S.current.category_refreshed_successfuly);
    // listenForCategory(message: S.current.category_refreshed_successfuly);
  }
}
