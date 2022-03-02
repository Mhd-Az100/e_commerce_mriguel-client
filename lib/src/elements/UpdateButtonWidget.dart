import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/cart_controller.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';
import 'SearchWidget.dart';

class UpdateButtonWidget extends StatefulWidget {
  const UpdateButtonWidget({
    this.iconColor,
    this.labelColor,
    Key key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;

  @override
  _UpdateButtonWidgetState createState() => _UpdateButtonWidgetState();
}

class _UpdateButtonWidgetState extends StateMVC<UpdateButtonWidget> {
  CartController _con;
  

  _UpdateButtonWidgetState() : super(CartController()) {
    _con = controller;
  }

  @override
  void initState() {
    // _con.listenForCartsCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        const url = 'https://play.google.com/store/apps/details?id=com.mriguel.markets';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 0,
          right: 0,
          top: 15,
          bottom: 15
        ),
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: <Widget>[
            Icon(
              Icons.system_update,
              color: Colors.red[600],
              size: 28,
            ),
            // Container(
            //   child: Text(
            //     _con.cartCount.toString(),
            //     textAlign: TextAlign.center,
            //     style: Theme.of(context).textTheme.caption.merge(
            //           TextStyle(color: Theme.of(context).primaryColor, fontSize: 10),
            //         ),
            //   ),
            //   padding: EdgeInsets.all(0),
            //   decoration:
            //       BoxDecoration(color: this.widget.labelColor, borderRadius: BorderRadius.all(Radius.circular(10))),
            //   constraints: BoxConstraints(minWidth: 15, maxWidth: 15, minHeight: 15, maxHeight: 15),
            // ),
          ],
        ),
      ),
      // color: Colors.red,
    );
  }
}
