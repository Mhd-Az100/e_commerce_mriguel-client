import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markets/generated/i18n.dart';

import '../helpers/helper.dart';
import '../models/cart.dart';
import '../models/route_argument.dart';

class CartItemWidget extends StatefulWidget {
  String heroTag;
  Cart cart;
  VoidCallback increment;
  VoidCallback decrement;
  VoidCallback onDismissed;

  CartItemWidget({Key key, this.cart, this.heroTag, this.increment, this.decrement, this.onDismissed})
      : super(key: key);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.cart.id),
      onDismissed: (direction) {
        setState(() {
          widget.onDismissed();
        });
      },
      child: Stack(
        children: [
          InkWell(
            splashColor: Theme.of(context).accentColor,
            focusColor: Theme.of(context).accentColor,
            highlightColor: Theme.of(context).primaryColor,
            onTap: () {
              if(widget.cart.product.inStock)
                Navigator.of(context)
                  .pushNamed('/Product', arguments: RouteArgument(id: widget.cart.product.id, heroTag: widget.heroTag,marketID:this.widget.cart.product.market.id));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.9),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: CachedNetworkImage(
                      height: 90,
                      width: 90,
                      fit: BoxFit.cover,
                      imageUrl: widget.cart.product.image.thumb,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                        height: 90,
                        width: 90,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.cart.product.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.subhead,
                              ),
                              Wrap(
                                children: List.generate(widget.cart.options.length, (index) {
                                  return Text(
                                    widget.cart.options.elementAt(index).name + ', ',
                                    style: Theme.of(context).textTheme.caption,
                                  );
                                }),
                              ),
                              Helper.getPrice(widget.cart.product.price, context,
                                  style: Theme.of(context).textTheme.display1)
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.increment();
                                });
                              },
                              iconSize: 30,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              icon: Icon(Icons.add_circle_outline),
                              color: Theme.of(context).hintColor,
                            ),
                            Text(widget.cart.quantity.toString(), style: Theme.of(context).textTheme.subhead),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.decrement();
                                });
                              },
                              iconSize: 30,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              icon: Icon(Icons.remove_circle_outline),
                              color: Theme.of(context).hintColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          !widget.cart.product.inStock ?
          Positioned(
            // top: 0,
            child: Container(
              margin: EdgeInsets.all(2),
              // width: 60,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                // borderRadius: BorderRadius.all(Radius.circular(20)),
                // image: DecorationImage(image: AssetImage('assets/img/sold-out.png'), fit: BoxFit.fill,)
              ),
              child: Center(
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red)
                    ),
                    child: Text(S.of(context).out_of_stock,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 20),))
              )
            ),
          ):SizedBox(height: 0,),
        ],
      ),
    );
  }
}
