import 'package:flutter/material.dart';
import 'package:markets/src/controllers/product_controller.dart';
import 'package:markets/src/elements/AddToCartAlertDialog.dart';
import 'package:markets/src/elements/ProductGridItemWidget.dart';
import 'package:markets/src/repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../controllers/market_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/ProductItemWidget.dart';
import '../elements/ProductsCarouselWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/route_argument.dart';

class MenuWidget extends StatefulWidget {
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
  RouteArgument routeArgument;

  MenuWidget({Key key, this.routeArgument}) : super(key: key);
}

class _MenuWidgetState extends StateMVC<MenuWidget> {
  MarketController _con;

  _MenuWidgetState() : super(MarketController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForProducts(widget.routeArgument.id);
    // _con.listenForTrendingProducts(widget.routeArgument.id);
    _con.listenForCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _con.products.isNotEmpty ? _con.products[0].market.name : '',
          overflow: TextOverflow.fade,
          softWrap: false,
          style: Theme.of(context)
              .textTheme
              .title
              .merge(TextStyle(letterSpacing: 0)),
        ),
        actions: <Widget>[
          _con.loadCart
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22.5, vertical: 15),
                  child: SizedBox(
                    width: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                    ),
                  ),
                )
              : ShoppingCartButtonWidget(
                  iconColor: Theme.of(context).hintColor,
                  labelColor: Theme.of(context).accentColor),
          // new ShoppingCartButtonWidget(
          //     iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBarWidget(),
            ),
            // ListTile(
            //   dense: true,
            //   contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   leading: Icon(
            //     Icons.trending_up,
            //     color: Theme.of(context).hintColor,
            //   ),
            //   title: Text(
            //     S.of(context).trending_this_week,
            //     style: Theme.of(context).textTheme.display1,
            //   ),
            // subtitle: Text(
            //   S.of(context).double_click_on_the_product_to_add_it_to_the,
            //   style: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 11)),
            // ),
            // ),
            // ProductsCarouselWidget(heroTag: 'menu_trending_product', productsList: _con.trendingProducts,controller:_con),
            ListTile(
              dense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(
                Icons.list,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                S.of(context).all_product,
                style: Theme.of(context).textTheme.display1,
              ),
              // subtitle: Text(
              //   S.of(context).longpress_on_the_product_to_add_suplements,
              //   style: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 11)),
              // ),
            ),
            _con.products.isEmpty
                ? CircularLoadingWidget(height: 250)
                : Offstage(
                    offstage: false,
                    child: GridView.count(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 2
                          : 4,
                      // Generate 100 widgets that display their index in the List.
                      children: List.generate(_con.products.length, (index) {
                        return ProductGridItemWidget(
                            heroTag: 'favorites_grid',
                            product: _con.products.elementAt(index),
                            onPressed: () {
                              if (currentUser.value.apiToken == null) {
                                Navigator.of(context).pushNamed('/Login');
                              } else if (_con.isAllUnique(
                                      _con.products.elementAt(index)) ||
                                  _con.carts.length == 0) {
                                _con.addToCart(_con.products.elementAt(index));
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return AddToCartAlertDialogWidget(
                                        oldProduct:
                                            _con.carts.elementAt(0)?.product,
                                        newProduct:
                                            _con.products.elementAt(index),
                                        onPressed: (product, {reset: true}) {
                                          return _con.addToCart(
                                              _con.products.elementAt(index),
                                              reset: true);
                                        });
                                  },
                                );
                              }
                            });
                      }),
                    ),
                  )
            // : ListView.separated(
            //     scrollDirection: Axis.vertical,
            //     shrinkWrap: true,
            //     primary: false,
            //     itemCount: _con.products.length,
            //     separatorBuilder: (context, index) {
            //       return SizedBox(height: 10);
            //     },
            //     itemBuilder: (context, index) {
            //       return InkWell(
            //         onLongPress: (){
            //           if (currentUser.value.apiToken == null) {
            //             Navigator.of(context).pushNamed("/Login");
            //           } else {
            //             if (_con.isSameMarkets(_con.products[index])) {
            //               _con.addToCart(_con.products[index]);
            //             } else {
            //               showDialog(
            //                 context: context,
            //                 builder: (BuildContext context) {
            //                   // return object of type Dialog
            //                   return AddToCartAlertDialogWidget(
            //                       oldProduct: _con.carts.elementAt(0)?.product,
            //                       newProduct: _con.products[index],
            //                       onPressed: (product, {reset: true}) {
            //                         return _con.addToCart(_con.product, reset: true);
            //                       });
            //                 },
            //               );
            //             }
            //           }
            //         },
            //         child: ProductItemWidget(
            //           heroTag: 'menu_list',
            //           product: _con.products.elementAt(index),
            //         ),
            //       );
            //     },
            //   ),
          ],
        ),
      ),
    );
  }
}
