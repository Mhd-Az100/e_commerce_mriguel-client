import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:markets/src/elements/CardsCarouselWidget.dart';
import 'package:markets/src/elements/MarketCaregoriesCarouselWidget.dart';
import 'package:markets/src/elements/ShoppingCartButtonWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/i18n.dart';
import '../controllers/market_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/GalleryCarouselWidget.dart';
import 'package:markets/src/repository/user_repository.dart';
import 'package:markets/src/elements/AddToCartAlertDialog.dart';
import '../elements/ProductItemWidget.dart';
import '../elements/ReviewsListWidget.dart';
import '../elements/ShoppingCartFloatButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';

class DetailsWidget extends StatefulWidget {
  RouteArgument routeArgument;

  DetailsWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _DetailsWidgetState createState() {
    return _DetailsWidgetState();
  }
}

class _DetailsWidgetState extends StateMVC<DetailsWidget> {
  MarketController _con;

  _DetailsWidgetState() : super(MarketController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForMarket(id: widget.routeArgument.id);
    // _con.listenForGalleries(widget.routeArgument.id);
    // _con.listenForMarketReviews(id: widget.routeArgument.id);
    _con.listenForFeaturedProducts(widget.routeArgument.id);
    _con.listenForCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushNamed('/Menu',
                arguments: new RouteArgument(id: widget.routeArgument.id));
          },
          isExtended: true,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          icon: Icon(
            Icons.shopping_basket,
            color: Theme.of(context).primaryColor,
          ),
          label: Text(
            S.of(context).all_product,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: RefreshIndicator(
          onRefresh: _con.refreshMarket,
          child: _con.market == null
              ? CircularLoadingWidget(height: 500)
              : Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CustomScrollView(
                      primary: true,
                      shrinkWrap: false,
                      slivers: <Widget>[
                        SliverAppBar(
                          backgroundColor:
                              Theme.of(context).accentColor.withOpacity(0.9),
                          expandedHeight: 300,
                          elevation: 0,
                          iconTheme: IconThemeData(
                              color: Theme.of(context).primaryColor),
                          flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.parallax,
                            background: Hero(
                              tag:
                                  widget.routeArgument.heroTag + _con.market.id,
                              child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl: _con.market.image.url,
                                placeholder: (context, url) => Image.asset(
                                  'assets/img/loading.gif',
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Wrap(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 20,
                                  left: 20,
                                  bottom: 10,
                                  top: 25,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        _con.market.name,
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        maxLines: 2,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display2,
                                      ),
                                    ),
                                    // SizedBox(
                                    //   height: 32,
                                    //   child: Chip(
                                    //     padding: EdgeInsets.all(0),
                                    //     label: Row(
                                    //       mainAxisAlignment:
                                    //           MainAxisAlignment.center,
                                    //       children: <Widget>[
                                    //         Text(_con.market.rate,
                                    //             style: Theme.of(context)
                                    //                 .textTheme
                                    //                 .body2
                                    //                 .merge(TextStyle(
                                    //                     color: Theme.of(context)
                                    //                         .primaryColor))),
                                    //         Icon(
                                    //           Icons.star_border,
                                    //           color: Theme.of(context)
                                    //               .primaryColor,
                                    //           size: 16,
                                    //         ),
                                    //       ],
                                    //     ),
                                    //     backgroundColor: Theme.of(context)
                                    //         .accentColor
                                    //         .withOpacity(0.9),
                                    //     shape: StadiumBorder(),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(width: 20),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 3),
                                    decoration: BoxDecoration(
                                        color: _con.market.closed
                                            ? Colors.grey
                                            : Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    child: _con.market.closed
                                        ? Text(
                                            S.of(context).closed,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .merge(TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                          )
                                        : Text(
                                            S.of(context).open,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .merge(TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                          ),
                                  ),
                                  SizedBox(width: 10),
                                  Helper.canDelivery(_con.market)
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 3),
                                          decoration: BoxDecoration(
                                              color: Helper.canDelivery(
                                                      _con.market)
                                                  ? Colors.green
                                                  : Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(24)),
                                          child:
                                              // Helper.canDelivery(_con.market)?
                                              Text(
                                            S.of(context).delivery,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .merge(TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                          )
                                          // : Text(
                                          //     S.of(context).pickup,
                                          //     style: Theme.of(context)
                                          //         .textTheme
                                          //         .caption
                                          //         .merge(TextStyle(color: Theme.of(context).primaryColor)),
                                          //   ),
                                          )
                                      : SizedBox(
                                          height: 0,
                                        ),
                                  Expanded(child: SizedBox(height: 0)),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 3),
                                    decoration: BoxDecoration(
                                        color: Helper.canDelivery(_con.market)
                                            ? Colors.green
                                            : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    child: Text(
                                      Helper.getDistance(_con.market.distance),
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .merge(TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                ],
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              //   child: Html(
                              //     data: _con.market.description,
                              //     defaultTextStyle: Theme.of(context).textTheme.body1.merge(TextStyle(fontSize: 14)),
                              //   ),
                              // ),
                              // ImageThumbCarouselWidget(galleriesList: _con.galleries),
                              // _con.market.information != null ? Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 20),
                              //   child: ListTile(
                              //     dense: true,
                              //     contentPadding: EdgeInsets.symmetric(vertical: 0),
                              //     leading: Icon(
                              //       Icons.stars,
                              //       color: Theme.of(context).hintColor,
                              //     ),
                              //     title: Text(
                              //       S.of(context).information,
                              //       style: Theme.of(context).textTheme.display1,
                              //     ),
                              //   ),
                              // ): Container(),
                              // _con.market.information != null ?
                              // Container(
                              //   width: MediaQuery.of(context).size.width,
                              //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              //   margin: const EdgeInsets.symmetric(vertical: 5),
                              //   color: Theme.of(context).primaryColor,
                              //   child: Helper.applyHtml(context, _con.market.information),
                              // ): Container(),
                              // Container(
                              //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              //   margin: const EdgeInsets.symmetric(vertical: 5),
                              //   color: Theme.of(context).primaryColor,
                              //   child: Row(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: <Widget>[
                              //       _con.market.address!=null ?
                              //       Expanded(
                              //         child: Text(
                              //           _con.market.address,
                              //           overflow: TextOverflow.ellipsis,
                              //           maxLines: 2,
                              //           style: Theme.of(context).textTheme.body2,
                              //         ),
                              //       ):SizedBox(width: 0),
                              //       SizedBox(width: 10),
                              //       _con.market.address!=null ?
                              //       SizedBox(
                              //         width: 42,
                              //         height: 42,
                              //         child: FlatButton(
                              //           padding: EdgeInsets.all(0),
                              //           onPressed: () {
                              //             Navigator.of(context).pushNamed('/Pages',
                              //                 arguments: new RouteArgument(id: '1', param: _con.market));
                              //           },
                              //           child: Icon(
                              //             Icons.directions,
                              //             color: Theme.of(context).primaryColor,
                              //             size: 24,
                              //           ),
                              //           color: Theme.of(context).accentColor.withOpacity(0.9),
                              //           shape: StadiumBorder(),
                              //         ),
                              //       ):SizedBox(width: 0),
                              //     ],
                              //   ),
                              // ),
                              // _con.market.phone != null ? Container(
                              //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              //   margin: const EdgeInsets.symmetric(vertical: 5),
                              //   color: Theme.of(context).primaryColor,
                              //   child: Row(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: <Widget>[
                              //       Expanded(
                              //         child: Text(
                              //           '${_con.market.phone != null ? _con.market.phone : ""} \n ${_con.market.mobile != null ? _con.market.mobile : ""}',
                              //           overflow: TextOverflow.ellipsis,
                              //           style: Theme.of(context).textTheme.body2,
                              //         ),
                              //       ),
                              //       SizedBox(width: 10),
                              //       SizedBox(
                              //         width: 42,
                              //         height: 42,
                              //         child: FlatButton(
                              //           padding: EdgeInsets.all(0),
                              //           onPressed: () {
                              //             launch("tel:${_con.market.mobile}");
                              //           },
                              //           child: Icon(
                              //             Icons.call,
                              //             color: Theme.of(context).primaryColor,
                              //             size: 24,
                              //           ),
                              //           color: Theme.of(context).accentColor.withOpacity(0.9),
                              //           shape: StadiumBorder(),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ):SizedBox(height: 0),
                              SizedBox(
                                height: 40,
                              ),
                              _con.market.categories.length > 0
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: ListTile(
                                        dense: true,
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 0),
                                        leading: Icon(
                                          Icons.category,
                                          color: Theme.of(context).hintColor,
                                        ),
                                        title: Text(
                                          S.of(context).product_categories,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display1,
                                        ),
                                      ),
                                    )
                                  : SizedBox(height: 0),
                              _con.market.categories.length > 0
                                  ? MarketCategoriesCarouselWidget(
                                      categories: _con.market.categories,
                                      marketId: _con.market.id,
                                    )
                                  : SizedBox(height: 0),
                              _con.featuredProducts.isEmpty
                                  ? SizedBox(height: 0)
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: ListTile(
                                        dense: true,
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 0),
                                        leading: Icon(
                                          Icons.shopping_basket,
                                          color: Theme.of(context).hintColor,
                                        ),
                                        title: Text(
                                          S.of(context).featured_products,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display1,
                                        ),
                                      ),
                                    ),
                              _con.featuredProducts.isEmpty
                                  ? SizedBox(height: 0)
                                  : ListView.separated(
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 80),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: _con.featuredProducts.length,
                                      separatorBuilder: (context, index) {
                                        return SizedBox(height: 10);
                                      },
                                      itemBuilder: (context, index) {
                                        return ProductItemWidget(
                                          heroTag: 'details_featured_product',
                                          product: _con.featuredProducts
                                              .elementAt(index),
                                          onPressed: () {
                                            if (currentUser.value.apiToken ==
                                                null) {
                                              Navigator.of(context)
                                                  .pushNamed("/Login");
                                            } else if (_con.isAllUnique(_con
                                                    .featuredProducts
                                                    .elementAt(index)) ||
                                                _con.carts.length == 0) {
                                              _con.addToCart(_con
                                                  .featuredProducts
                                                  .elementAt(index));
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  // return object of type Dialog
                                                  return AddToCartAlertDialogWidget(
                                                      oldProduct: _con?.carts
                                                          ?.first?.product,
                                                      newProduct: _con
                                                          .featuredProducts
                                                          .elementAt(index),
                                                      onPressed: (product,
                                                          {reset: true}) {
                                                        return _con.addToCart(
                                                            _con.featuredProducts
                                                                .elementAt(
                                                                    index),
                                                            reset: true);
                                                      });
                                                },
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),

                              //  _con.reviews.isEmpty ? SizedBox(height: 230) : SizedBox(height: 100),
                              //   _con.reviews.isEmpty
                              //       ? SizedBox(height: 5)
                              //       : Padding(
                              //           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              //           child: ListTile(
                              //             dense: true,
                              //             contentPadding: EdgeInsets.symmetric(vertical: 0),
                              //             leading: Icon(
                              //               Icons.recent_actors,
                              //               color: Theme.of(context).hintColor,
                              //             ),
                              //             title: Text(
                              //               S.of(context).what_they_say,
                              //               style: Theme.of(context).textTheme.display1,
                              //             ),
                              //           ),
                              //         ),
                              //   _con.reviews.isEmpty
                              //       ? SizedBox(height: 5)
                              //       : Padding(
                              //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              //           child: ReviewsListWidget(reviewsList: _con.reviews),
                              //         ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Positioned(
                      top: 32,
                      right: 20,
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: RaisedButton(
                          padding: EdgeInsets.all(0),
                          color: Theme.of(context).accentColor,
                          shape: StadiumBorder(),
                          onPressed: () {
                            if (currentUser.value.apiToken != null) {
                              Navigator.of(context).pushNamed('/Cart',
                                  arguments: RouteArgument(
                                    param: '/Product',
                                  ));
                            } else {
                              Navigator.of(context).pushNamed('/Login');
                            }
                          },
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: <Widget>[
                              _con.loadCart
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      child: SizedBox(
                                        width: 26,
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      ),
                                    )
                                  : ShoppingCartButtonWidget(
                                      iconColor: Colors.white,
                                      labelColor: Colors.black),
                              // new ShoppingCartButtonWidget(
                              //     iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ));
  }
}
