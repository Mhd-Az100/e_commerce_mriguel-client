import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:markets/src/helpers/helper.dart';
import '../../generated/i18n.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../repository/market_repository.dart' as marketRepo;
import '../repository/order_repository.dart';
import '../repository/product_repository.dart' as productRepo;
import '../helpers/global.dart';

class ReviewsController extends ControllerMVC {
  Review marketReview;
  List<Review> productsReviews = [];
  Order order;
  List<Product> productsOfOrder = [];
  List<OrderStatus> orderStatus = <OrderStatus>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  ReviewsController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    this.marketReview = new Review.init("0");
  }

  void listenForOrder({String orderId, String message}) async {
    final Stream<Order> stream = await getOrder(orderId);
    stream.listen((Order _order) {
      setState(() {
        order = _order;
        productsReviews = List.generate(
            order.productOrders.length, (_) => new Review.init("0"));
      });
    }, onError: (a) {
      Helper.printToConsole(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      getProductsOfOrder();
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void addProductReview(Review _review, Product _product) async {
    productRepo.addProductReview(_review, _product).then((value) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.the_product_has_been_rated_successfully),
      ));
    }).whenComplete(() => setState(() => glbReview = true));
  }

  void addMarketReview(Review _review, orderid, {app: false}) async {
    marketRepo
        .addMarketReview(_review,
            app ? null : this.order.productOrders[0].product.market, orderid)
        .then((value) {
      refreshOrder();
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.the_market_has_been_rated_successfully),
      ));
    }).whenComplete(() {
      marketReview.rate = '0';
      marketReview.review = '';
      marketReview.rate2 = '0';
      marketReview.review2 = '';
      setState(() => glbReview = true);
      //  Navigator.of(scaffoldKey.currentContext).pop();
    });
  }

  Future<void> refreshOrder() async {
    listenForOrder(
        orderId: order.id, message: S.current.reviews_refreshed_successfully);
  }

  void getProductsOfOrder() {
    this.order.productOrders.forEach((_productOrder) {
      if (!productsOfOrder.contains(_productOrder.product)) {
        productsOfOrder.add(_productOrder.product);
      }
    });
  }
}
