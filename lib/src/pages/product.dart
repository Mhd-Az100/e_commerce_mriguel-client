import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markets/src/elements/ProductsCarouselWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../controllers/product_controller.dart';
import '../elements/AddToCartAlertDialog.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/OptionItemWidget.dart';
import '../elements/ReviewsListWidget.dart';
import '../elements/ShoppingCartFloatButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';
import 'package:markets/src/helpers/helper.dart';

// ignore: must_be_immutable
class ProductWidget extends StatefulWidget {
  RouteArgument routeArgument;

  ProductWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _ProductWidgetState createState() {
    return _ProductWidgetState();
  }
}

class _ProductWidgetState extends StateMVC<ProductWidget> {
  ProductController _con;

  _ProductWidgetState() : super(ProductController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForProduct(productId: widget.routeArgument.id);
    _con.listenForFavorite(productId: widget.routeArgument.id);
    _con.listenForCart();
    _con.listenForTrendingProducts(widget.routeArgument.marketID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: _con.product == null
          ? CircularLoadingWidget(height: 500)
          : RefreshIndicator(
              onRefresh: _con.refreshProduct,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 120),
                    padding: EdgeInsets.only(bottom: 15),
                    child: CustomScrollView(
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
                              tag: widget.routeArgument.heroTag ??
                                  '' + _con.product.id,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: _con.product.image.url,
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Wrap(
                              runSpacing: 8,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            _con.product.name,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display2,
                                          ),
                                          // _con.product.description != null ?
                                          // Text(
                                          //   Helper.skipHtml(_con.product.description),
                                          //   overflow: TextOverflow.ellipsis,
                                          //   maxLines: 2,
                                          //   style: Theme.of(context).textTheme.body1,
                                          // ) : Text(''),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Helper.getPrice(
                                            _con.product.price,
                                            context,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display3,
                                          ),
                                          _con.product.discountPrice > 0
                                              ? Helper.getPrice(
                                                  _con.product.discountPrice,
                                                  context,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .body1
                                                      .merge(TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough)))
                                              : SizedBox(height: 0),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 3),
                                      decoration: BoxDecoration(
                                          color: _con.product.deliverable
                                              ? Colors.green
                                              : Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(24)),
                                      child: _con.product.deliverable
                                          ? Text(
                                              S.of(context).deliverable,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .merge(TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                            )
                                          : Text(
                                              S.of(context).not_deliverable,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .merge(TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                            ),
                                    ),
                                    Expanded(child: SizedBox(height: 0)),
                                    _con.product.capacity != 'null'
                                        ? Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 3),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .focusColor,
                                                borderRadius:
                                                    BorderRadius.circular(24)),
                                            child: Text(
                                              _con.product.capacity +
                                                  " " +
                                                  _con.product.unit,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .merge(TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                            ))
                                        : SizedBox(width: 0),
                                    SizedBox(width: 5),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 3),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).focusColor,
                                            borderRadius:
                                                BorderRadius.circular(24)),
                                        child: Text(
                                          _con.product.packageItemsCount +
                                              " " +
                                              S.of(context).items,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .merge(TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                        )),
                                  ],
                                ),
                                // Divider(height: 10),
                                _con.product.description != null
                                    ? Text(Helper.skipHtml(
                                        _con.product.description))
                                    : Text(""),

                                _con.product.options.length == 0
                                    ? SizedBox(
                                        height: 0,
                                      )
                                    : ListTile(
                                        dense: true,
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        leading: Icon(
                                          Icons.add_circle,
                                          color: Theme.of(context).hintColor,
                                        ),
                                        title: Text(
                                          S.of(context).options,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subhead,
                                        ),
                                        subtitle: Text(
                                          S
                                              .of(context)
                                              .select_options_to_add_them_on_the_product,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                      ),
                                ListView.separated(
                                  padding: EdgeInsets.all(0),
                                  itemBuilder: (context, optionIndex) {
                                    return OptionItemWidget(
                                      option: _con.product.options
                                          .elementAt(optionIndex),
                                      onChanged: _con.calculateTotal,
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 20);
                                  },
                                  itemCount: _con.product.options.length,
                                  primary: false,
                                  shrinkWrap: true,
                                ),
                                _con.product.optionGroups == null
                                    ? CircularLoadingWidget(height: 100)
                                    : ListView.separated(
                                        padding: EdgeInsets.all(0),
                                        itemBuilder:
                                            (context, optionGroupIndex) {
                                          var optionGroup = _con
                                              .product.optionGroups
                                              .elementAt(optionGroupIndex);
                                          return Wrap(
                                            children: <Widget>[
                                              ListTile(
                                                dense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 0),
                                                leading: Icon(
                                                  Icons.add_circle_outline,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                                title: Text(
                                                  optionGroup.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subhead,
                                                ),
                                              ),
                                              ListView.separated(
                                                padding: EdgeInsets.all(0),
                                                itemBuilder:
                                                    (context, optionIndex) {
                                                  return OptionItemWidget(
                                                    option: _con.product.options
                                                        .where((option) =>
                                                            option
                                                                .optionGroupId ==
                                                            optionGroup.id)
                                                        .elementAt(optionIndex),
                                                    onChanged:
                                                        _con.calculateTotal,
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return SizedBox(height: 20);
                                                },
                                                itemCount: _con.product.options
                                                    .where((option) =>
                                                        option.optionGroupId ==
                                                        optionGroup.id)
                                                    .length,
                                                primary: false,
                                                shrinkWrap: true,
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(height: 20);
                                        },
                                        itemCount:
                                            _con.product.optionGroups.length,
                                        primary: false,
                                        shrinkWrap: true,
                                      ),
                                _con.trendingProducts.length > 0
                                    ? ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        leading: Icon(
                                          Icons.trending_up,
                                          color: Theme.of(context).hintColor,
                                        ),
                                        title: Text(
                                          S.of(context).trending_this_week,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display1,
                                        ),
                                        // subtitle: Text(
                                        //   S.of(context).double_click_on_the_product_to_add_it_to_the,
                                        //   style: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 11)),
                                        // ),
                                      )
                                    : SizedBox(height: 0),
                                _con.trendingProducts.length > 0
                                    ? ProductsCarouselWidget(
                                        heroTag: 'menu_trending_product',
                                        productsList: _con.trendingProducts,
                                        pcontroller: _con)
                                    : SizedBox(height: 0)
                                // _con.product.productReviews.length == 0 ?
                                // SizedBox(height: 0,)
                                // :ListTile(
                                //   dense: true,
                                //   contentPadding: EdgeInsets.symmetric(vertical: 10),
                                //   leading: Icon(
                                //     Icons.recent_actors,
                                //     color: Theme.of(context).hintColor,
                                //   ),
                                //   title: Text(
                                //     S.of(context).reviews,
                                //     style: Theme.of(context).textTheme.subhead,
                                //   ),
                                // ),
                                // ReviewsListWidget(
                                //   reviewsList: _con.product.productReviews,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 32,
                    right: 20,
                    child: _con.loadCart
                        ? SizedBox(
                            width: 60,
                            height: 60,
                            child: RefreshProgressIndicator(),
                          )
                        : ShoppingCartFloatButtonWidget(
                            iconColor: Theme.of(context).primaryColor,
                            labelColor: Theme.of(context).hintColor,
                            product: _con.product,
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 140,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.15),
                                offset: Offset(0, -2),
                                blurRadius: 5.0)
                          ]),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    S.of(context).quantity,
                                    style: Theme.of(context).textTheme.subhead,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {
                                        _con.decrementQuantity();
                                      },
                                      iconSize: 30,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      icon: Icon(Icons.remove_circle_outline),
                                      color: Theme.of(context).hintColor,
                                    ),
                                    Text(_con.quantity.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subhead),
                                    IconButton(
                                      onPressed: () {
                                        _con.incrementQuantity();
                                      },
                                      iconSize: 30,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      icon: Icon(Icons.add_circle_outline),
                                      color: Theme.of(context).hintColor,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: _con.favorite?.id != null
                                      ? OutlineButton(
                                          onPressed: () {
                                            _con.removeFromFavorite(
                                                _con.favorite);
                                          },
                                          padding: EdgeInsets.symmetric(
                                              vertical: 14),
                                          color: Theme.of(context).primaryColor,
                                          shape: StadiumBorder(),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .accentColor),
                                          child: Icon(
                                            Icons.favorite,
                                            color:
                                                Theme.of(context).accentColor,
                                          ))
                                      : FlatButton(
                                          onPressed: () {
                                            if (currentUser.value.apiToken ==
                                                null) {
                                              Navigator.of(context)
                                                  .pushNamed("/Login");
                                            } else {
                                              _con.addToFavorite(_con.product);
                                            }
                                          },
                                          padding: EdgeInsets.symmetric(
                                              vertical: 14),
                                          color: Theme.of(context).accentColor,
                                          shape: StadiumBorder(),
                                          child: Icon(
                                            Icons.favorite,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )),
                                ),
                                SizedBox(width: 10),
                                Stack(
                                  fit: StackFit.loose,
                                  alignment: AlignmentDirectional.centerEnd,
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          110,
                                      child: FlatButton(
                                        onPressed: () {
                                          if (currentUser.value.apiToken ==
                                              null) {
                                            Navigator.of(context)
                                                .pushNamed("/Login");
                                          } else if (_con
                                                  .isAllUnique(_con.product) ||
                                              _con.carts.length == 0) {
                                            _con.addToCart(_con.product);
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                // return object of type Dialog
                                                return AddToCartAlertDialogWidget(
                                                    oldProduct: _con.carts
                                                        .elementAt(0)
                                                        ?.product,
                                                    newProduct: _con.product,
                                                    onPressed: (product,
                                                        {reset: true}) {
                                                      return _con.addToCart(
                                                          _con.product,
                                                          reset: true);
                                                    });
                                              },
                                            );
                                          }
                                        },
                                        padding:
                                            EdgeInsets.symmetric(vertical: 14),
                                        color: Theme.of(context).accentColor,
                                        shape: StadiumBorder(),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            S.of(context).add_to_cart,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Helper.getPrice(
                                        _con.total,
                                        context,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display1
                                            .merge(TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
