import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:markets/src/helpers/global.dart';
import 'package:markets/src/repository/settings_repository.dart';
import 'package:markets/src/repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../controllers/cart_controller.dart';
import '../elements/CartItemWidget.dart';
import '../elements/EmptyCartWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';

class CartWidget extends StatefulWidget {
  RouteArgument routeArgument;
  CartWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends StateMVC<CartWidget> {
  CartController _con;
  TextEditingController myController = TextEditingController();
  _CartWidgetState() : super(CartController()) {
    _con = controller;
    couponDiscount = 0.0;
    startValue = 0.0;
    couponDiscountValue = 0.0;
    couponDiscountForDelivery = 0.0;
  }

  @override
  void initState() {
    _con.listenForCarts();
    // _con.isUniqueMarketOrNot();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            if (widget.routeArgument.param == '/Product') {
              Navigator.of(context).pushReplacementNamed('/Product',
                  arguments: RouteArgument(id: widget.routeArgument.id));
            } else {
              Navigator.of(context)
                  .pushReplacementNamed('/Pages', arguments: 1);
            }
          },
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).hintColor,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '${S.of(context).cart}',
          style: Theme.of(context)
              .textTheme
              .title
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshCarts,
        child: _con.carts.isEmpty
            ? EmptyCartWidget()
            : Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 180),
                    padding: EdgeInsets.only(bottom: 15),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 10),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              leading: Icon(
                                Icons.shopping_cart,
                                color: Theme.of(context).hintColor,
                              ),
                              title: Text(
                                S.of(context).shopping_cart,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.display1,
                              ),
                              subtitle: Text(
                                S
                                    .of(context)
                                    .verify_your_quantity_and_click_checkout,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 10),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              leading: Icon(
                                Icons.delete,
                                color: Theme.of(context).hintColor,
                              ),
                              title: Text(
                                S.of(context).for_delete,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .display1
                                    .merge(TextStyle(fontSize: 13)),
                              ),
                              // subtitle: Text(
                              //   S.of(context).verify_your_quantity_and_click_checkout,
                              //   maxLines: 1,
                              //   overflow: TextOverflow.ellipsis,
                              //   style: Theme.of(context).textTheme.caption,
                              // ),
                            ),
                          ),
                          !(['null', null, ''])
                                  .contains(deliveryAddress.value?.id)
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 10),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed('/DeliveryPickup')
                                          .then((value) {
                                        if (![
                                          null,
                                          'null',
                                          ''
                                        ].contains(deliveryAddress.value?.id)) {
                                          _con.navigate = true;
                                          _con.calculateSubtotal();
                                        }
                                      });
                                    },
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 0),
                                    leading: Icon(
                                      Icons.location_on,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    title: Text(
                                      S.of(context).delivery_address,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .display1
                                          .merge(TextStyle(fontSize: 13)),
                                    ),
                                    subtitle: Text(
                                      deliveryAddress.value.address ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .merge(
                                            TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                          setting.value.minimum > 0
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 10),
                                  child: ListTile(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 0),
                                    leading: Icon(
                                      Icons.info,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    title: Text(
                                      '${S.of(context).the_minimum_price} ${_con.minimum.toStringAsFixed(0)}${setting.value.defaultCurrency}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .display1
                                          .merge(
                                            TextStyle(fontSize: 13),
                                          ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                          ListView.separated(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: _con.carts.length,
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 15);
                            },
                            itemBuilder: (context, index) {
                              Helper.printToConsole(
                                  _con.carts.elementAt(index).product.unique);
                              return CartItemWidget(
                                cart: _con.carts.elementAt(index),
                                heroTag: 'cart',
                                increment: () {
                                  _con.incrementQuantity(
                                      _con.carts.elementAt(index));
                                },
                                decrement: () {
                                  _con.decrementQuantity(
                                      _con.carts.elementAt(index));
                                },
                                onDismissed: () {
                                  _con.removeFromCart(
                                      _con.carts.elementAt(index));
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 230,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                                    S.of(context).subtotal,
                                    style: Theme.of(context).textTheme.body2,
                                  ),
                                ),
                                Helper.getPrice(_con.subTotal, context,
                                    style: Theme.of(context).textTheme.subhead,
                                    currency: true)
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '${S.of(context).coupon_discount} ($couponDiscount%)',
                                    style: Theme.of(context).textTheme.body2,
                                  ),
                                ),
                                Helper.getPrice(-couponDiscountValue, context,
                                    style: Theme.of(context).textTheme.subhead,
                                    currency: true)
                              ],
                            ),

                            // SizedBox(height: 5),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    S.of(context).delivery_fee,
                                    style: Theme.of(context).textTheme.body2,
                                  ),
                                ),
                                couponDiscountForDelivery > 0
                                    ? Text(
                                        '(-${couponDiscountForDelivery.toStringAsFixed(2)})',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.red),
                                      )
                                    : SizedBox(
                                        height: 0,
                                      ),
                                Helper.getPrice(
                                    // _con.carts[0].product.market.deliveryFee
                                    _con.deliveryFee -
                                        couponDiscountForDelivery,
                                    context,
                                    style: Theme.of(context).textTheme.subhead,
                                    currency: true),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '${S.of(context).tax} (${_con.carts[0].product.market.defaultTax}%)',
                                    style: Theme.of(context).textTheme.body2,
                                  ),
                                ),
                                Helper.getPrice(_con.taxAmount, context,
                                    style: Theme.of(context).textTheme.subhead,
                                    currency: true)
                              ],
                            ),
                            // Row(
                            //   children: <Widget>[
                            //     Expanded(
                            //       child: Text(
                            //         '${S.of(context).delivery_address}',
                            //         style: Theme.of(context).textTheme.body2,
                            //       ),
                            //     ),
                            //     Helper.getPrice(_con.taxAmount, context,
                            //         style: Theme.of(context).textTheme.subhead,
                            //         currency: true)
                            //   ],
                            // ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Stack(
                                    fit: StackFit.loose,
                                    alignment: AlignmentDirectional.centerEnd,
                                    children: <Widget>[
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        child: FlatButton(
                                          onPressed: !_con.carts[0].product
                                                  .market.closed
                                              ? _con.longDistance
                                                  ? () {
                                                      _con.scaffoldKey
                                                          ?.currentState
                                                          ?.showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                          S
                                                              .of(context)
                                                              .delivery_cannot_be_more_than(
                                                                setting.value
                                                                    .maxRadius
                                                                    .toStringAsFixed(
                                                                  0,
                                                                ),
                                                              ),
                                                        ),
                                                      ));
                                                    }
                                                  : () {
                                                      if (currentUser.value
                                                                  .apiToken !=
                                                              null &&
                                                          ['null', null, '']
                                                              .contains(
                                                            currentUser
                                                                .value.phone,
                                                          )) {
                                                        cart = true;
                                                        Navigator.of(context)
                                                            .pushReplacementNamed(
                                                          '/Settings',
                                                          arguments: true,
                                                        );
                                                      } else if (_con
                                                          .isOutOfStock()) {
                                                        Flushbar(
                                                          // title:  "Ooops !!",
                                                          message: S
                                                              .of(context)
                                                              .please_delete_any_product_that_is_out_of_stock_in_your_cart,
                                                          duration: Duration(
                                                              seconds: 3),
                                                          flushbarPosition:
                                                              FlushbarPosition
                                                                  .TOP,
                                                        )..show(context);
                                                      } else if (_con.subTotal <
                                                          _con.minimum) {
                                                        Flushbar(
                                                          // title:  "Ooops !!",
                                                          message:
                                                              '${S.of(context).the_minimum_price} ${_con.minimum.toStringAsFixed(0)}${setting.value.defaultCurrency}',
                                                          duration: Duration(
                                                              seconds: 3),
                                                          flushbarPosition:
                                                              FlushbarPosition
                                                                  .TOP,
                                                        )..show(context);
                                                      } else {
                                                        if (!_con.navigate) {
                                                          Navigator.of(context)
                                                              .pushNamed(
                                                                  '/DeliveryPickup')
                                                              .then((value) {
                                                            if (![
                                                              null,
                                                              'null',
                                                              ''
                                                            ].contains(
                                                                deliveryAddress
                                                                    .value
                                                                    ?.id)) {
                                                              _con.navigate =
                                                                  true;
                                                              _con.calculateSubtotal();
                                                            }
                                                          });
                                                        } else {
                                                          Helper.printToConsole(
                                                              deliveryAddress
                                                                  .value
                                                                  .toMap());
                                                          Navigator.of(context)
                                                              .pushNamed(
                                                                  '/PaymentMethod');
                                                        }
                                                      }
                                                    }
                                              : () {
                                                  _con.scaffoldKey?.currentState
                                                      ?.showSnackBar(SnackBar(
                                                    content: Text(S
                                                        .of(context)
                                                        .this_market_is_closed_),
                                                  ));
                                                },
                                          disabledColor: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.5),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 14),
                                          color: !_con.carts[0].product.market
                                                  .closed
                                              ? Theme.of(context).accentColor
                                              : Theme.of(context)
                                                  .focusColor
                                                  .withOpacity(0.5),
                                          shape: StadiumBorder(),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Text(
                                                  S.of(context).checkout,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Helper.getPrice(
                                                  _con.total,
                                                  context,
                                                  currency: true,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .display1
                                                      .merge(TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontSize: 16)),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return SimpleDialog(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                titlePadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 20),
                                                title: Row(
                                                  children: <Widget>[
                                                    Icon(Icons.save),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      S.of(context).coupon_code,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .body2,
                                                    )
                                                  ],
                                                ),
                                                children: <Widget>[
                                                  Form(
                                                    // key: _coupponsSettingsFormKey,
                                                    child: Column(
                                                      children: <Widget>[
                                                        new TextFormField(
                                                          textDirection:
                                                              Directionality.of(
                                                                          context) ==
                                                                      TextDirection
                                                                          .rtl
                                                                  ? TextDirection
                                                                      .rtl
                                                                  : TextDirection
                                                                      .ltr,
                                                          controller:
                                                              myController,
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor),
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          decoration: getInputDecoration(
                                                              hintText: S
                                                                  .of(context)
                                                                  .coupon_code,
                                                              labelText: S
                                                                  .of(context)
                                                                  .coupon_code),
                                                          // initialValue: 'widget.user.name',
                                                          //validator: (input) => input.trim().length < 3 ? S.of(context).not_a_valid_full_name : null,
                                                          onSaved: (input) {
                                                            // setState(() { couponCode = input; });
                                                            // Helper.printToConsole(myController.value);
                                                            // _con.couponCalc(code: 'testcp');
                                                          },
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 20),
                                                  Row(
                                                    children: <Widget>[
                                                      MaterialButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(S
                                                            .of(context)
                                                            .cancel),
                                                      ),
                                                      MaterialButton(
                                                        onPressed: _submit,
                                                        child: Text(
                                                          S.of(context).save,
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .accentColor),
                                                        ),
                                                      ),
                                                    ],
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                  ),
                                                  SizedBox(height: 10),
                                                ],
                                              );
                                            });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          S.of(context).add_coupon,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    )),
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

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.body1.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      hasFloatingPlaceholder: true,
      labelStyle: Theme.of(context).textTheme.body1.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void _submit() {
    _con.couponCalc(code: myController.value.text);
    // Helper.printToConsole(myController.value.text);
    Navigator.pop(context);
  }
}
