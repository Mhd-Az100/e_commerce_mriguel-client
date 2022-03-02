import 'package:flutter/material.dart';
import '../helpers/helper.dart';
import '../../generated/i18n.dart';
import 'package:markets/src/helpers/global.dart';
import '../models/order.dart';

class BottomPriceWidget extends StatefulWidget {
  final Order order;
  BottomPriceWidget(this.order,{Key key}) : super(key: key);
  

  @override
  _BottomPriceWidgetState createState() => _BottomPriceWidgetState();
}

class _BottomPriceWidgetState extends State<BottomPriceWidget> {
    double taxAmount = 0.0;
    double deliveryFee = 0.0;
    int cartCount = 0;
    double subTotal = 0.0;
    double total = 0.0;
    double discount = 0.0;

    void calculateSubtotal() async {
      subTotal = 0;
      widget.order.productOrders.forEach((cart) {
        subTotal += cart.quantity * cart.product.price;
      });

      if(widget.order.cpDiscount>0){
        discount = subTotal * (widget.order.cpDiscount / 100);
        // subTotal -= subTotal * (couponDiscount / 100);
      } 

      deliveryFee = widget.order.deliveryFee;
      taxAmount = (subTotal + deliveryFee) * widget.order.tax / 100;
      total = subTotal + taxAmount + deliveryFee - discount;
      setState(() {});
    }

    @override
  void initState() {
    super.initState();
    calculateSubtotal();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                                Helper.getPrice(subTotal, context, style: Theme.of(context).textTheme.subhead,currency:true) 
                              ],
                            ),
                            // SizedBox(height: 5),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '${S.of(context).coupon_discount} (${widget.order.cpDiscount}%)',
                                    style: Theme.of(context).textTheme.body2,
                                  ),
                                ), 
                                Helper.getPrice(-discount,context, style: Theme.of(context).textTheme.subhead,currency:true)
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
                                Helper.getPrice(widget.order.deliveryFee, context,
                                    style: Theme.of(context).textTheme.subhead,currency:true)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '${S.of(context).tax} (${widget.order.tax}%)',
                                    style: Theme.of(context).textTheme.body2,
                                  ),
                                ),
                                Helper.getPrice(taxAmount, context, style: Theme.of(context).textTheme.subhead,currency:true)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    S.of(context).total,
                                    style: Theme.of(context).textTheme.body2,
                                  ),
                                ),
                                Helper.getPrice(total, context, style: Theme.of(context).textTheme.subhead,currency:true)
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      );
  }
}