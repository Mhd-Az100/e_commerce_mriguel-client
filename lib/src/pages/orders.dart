import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:markets/src/helpers/helper.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../controllers/order_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/OrderItemWidget.dart';
import '../elements/PermissionDeniedWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../repository/user_repository.dart';

class OrdersWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  OrdersWidget({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends StateMVC<OrdersWidget> {
  OrderController _con; 
  

  _OrdersWidgetState() : super(OrderController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).my_orders,
          style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: currentUser.value.apiToken == null
          ? PermissionDeniedWidget()
          : RefreshIndicator(
              onRefresh: _con.refreshOrders,
              child: SingleChildScrollView(
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
                    
                    Padding(
                      padding: const EdgeInsets.only(top: 20,left: 16,right: 16),
                      child: Text(
                          S.of(context).longpress_on_the_product_for_more_information, 
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 14)),
                        ),
                    ),
                    // SizedBox(height: 2),
                    _con.orders.isEmpty
                        ? CircularLoadingWidget(height: 500)
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: _con.orders.length,
                            itemBuilder: (context, index) {
                              return Theme(
                                data: theme,
                                child: ExpansionTile(
                                  initiallyExpanded: true,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    
                                    children: <Widget>[
                                      Expanded(
                                          child:
                                              Text('${S.of(context).order_id}: #${_con.orders.elementAt(index).id}')
                                      ),
                                      Text(
                                        DateFormat('yyyy-MM-dd').format(_con.orders.elementAt(index).dateTime),
                                        style: Theme.of(context).textTheme.caption,
                                      ),
                                      SizedBox(width: 4,),
                                      Text(
                                        DateFormat('HH:mm').format(_con.orders.elementAt(index).dateTime),
                                        style: Theme.of(context).textTheme.caption,
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${_con.orders.elementAt(index).orderStatus.status}',
                                          textAlign: TextAlign.end,
                                          style: Theme.of(context).textTheme.caption,
                                        ),
                                      ),
                                    ],
                                  ),
                                  children:
                                      List.generate(_con.orders.elementAt(index).productOrders.length, (indexProduct) {
                                      return OrderItemWidget(
                                          heroTag: 'my_orders',
                                          order: _con.orders.elementAt(index),
                                          productOrder:
                                              _con.orders.elementAt(index).productOrders.elementAt(indexProduct));
                                    }),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
