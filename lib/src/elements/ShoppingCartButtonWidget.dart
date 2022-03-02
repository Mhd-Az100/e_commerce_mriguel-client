import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markets/src/controllers/shopping_card_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/cart_controller.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShoppingCartButtonWidget extends StatefulWidget {
  const ShoppingCartButtonWidget({
    this.iconColor,
    this.labelColor,
    Key key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;

  @override
  _ShoppingCartButtonWidgetState createState() =>
      _ShoppingCartButtonWidgetState();
}

class _ShoppingCartButtonWidgetState
    extends StateMVC<ShoppingCartButtonWidget> {
  CartController _con;

  _ShoppingCartButtonWidgetState() : super(CartController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForCartsCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        if (currentUser.value.apiToken != null) {
          Navigator.of(context).pushNamed('/Cart',
              arguments: RouteArgument(param: '/Pages', id: '2'));
        } else {
          Navigator.of(context).pushNamed('/Login');
        }
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          Icon(
            Icons.shopping_cart,
            color: this.widget.iconColor,
            size: 28.w,
          ),
          Container(
            child: Obx(
              () => Text(
                Get.find<ShoppingCardController>().cartCount.value.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption.merge(
                      TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 10.w,
                      ),
                    ),
              ),
            ),
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
                color: this.widget.labelColor,
                borderRadius: BorderRadius.all(Radius.circular(10.w))),
            constraints: BoxConstraints(
                minWidth: 15.w,
                maxWidth: 15.w,
                minHeight: 15.w,
                maxHeight: 15.w),
          ),
        ],
      ),
      color: Colors.transparent,
    );
  }
}
