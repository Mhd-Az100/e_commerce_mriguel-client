import 'package:flutter/material.dart';
import 'package:markets/src/controllers/controller.dart';
import 'package:markets/src/controllers/market_controller.dart';
import 'package:markets/src/controllers/product_controller.dart';
import 'package:markets/src/elements/AddToCartAlertDialog.dart';
import 'package:markets/src/repository/user_repository.dart';

import '../elements/CircularLoadingWidget.dart';
import '../elements/ProductsCarouselItemWidget.dart';
import '../models/product.dart';

class ProductsCarouselWidget extends StatefulWidget {
  List<Product> productsList;
  String heroTag;
  MarketController controller;
  ProductController pcontroller;

  ProductsCarouselWidget(
      {Key key,
      this.productsList,
      this.heroTag,
      this.controller,
      this.pcontroller})
      : super(key: key);

  @override
  _ProductsCarouselWidgetState createState() => _ProductsCarouselWidgetState();
}

class _ProductsCarouselWidgetState extends State<ProductsCarouselWidget> {
  @override
  void initState() {
    // TODO: implement initState
    widget.pcontroller.listenForCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.productsList.isEmpty
        ? CircularLoadingWidget(height: 210)
        : Container(
            margin: EdgeInsets.only(left: 0),
            height: 250,
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            child: ListView.builder(
              itemCount: widget.productsList.length,
              itemBuilder: (context, index) {
                double _marginLeft = 0;
                (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
                return InkWell(
                  onDoubleTap: () {},
                  child: ProductsCarouselItemWidget(
                      heroTag: widget.heroTag,
                      marginLeft: _marginLeft,
                      product: widget.productsList.elementAt(index),
                      onPressed: () {
                        if (currentUser.value.apiToken == null) {
                          Navigator.of(context).pushNamed("/Login");
                        }
                        // if (_con.isSameMarkets(_con.products.elementAt(index))) {
                        else if (widget.pcontroller.isAllUnique(
                                widget.productsList.elementAt(index)) ||
                            widget.controller.carts.length == 0) {
                          widget.pcontroller
                              .addToCart(widget.productsList.elementAt(index));
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AddToCartAlertDialogWidget(
                                  oldProduct: widget.pcontroller.carts
                                      .elementAt(0)
                                      ?.product,
                                  newProduct:
                                      widget.productsList.elementAt(index),
                                  onPressed: (product, {reset: true}) {
                                    return widget.pcontroller.addToCart(
                                        widget.productsList.elementAt(index),
                                        reset: true);
                                  });
                            },
                          );
                        }
                      }),
                );
              },
              scrollDirection: Axis.horizontal,
            ));
  }
}
