import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markets/generated/i18n.dart';
import '../helpers/helper.dart';
import '../models/product.dart';
import '../models/route_argument.dart';

class ProductGridItemWidget extends StatefulWidget {
  final String heroTag;
  final Product product;
  final VoidCallback onPressed;

  ProductGridItemWidget({Key key, this.heroTag, this.product, this.onPressed})
      : super(key: key);

  @override
  _ProductGridItemWidgetState createState() => _ProductGridItemWidgetState();
}

class _ProductGridItemWidgetState extends State<ProductGridItemWidget> {
  @override
  Widget build(BuildContext context) {
    final TextDirection currentDirection = Directionality.of(context);
    final bool isRTL = currentDirection == TextDirection.rtl;
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        if (widget.product.inStock)
          Navigator.of(context).pushNamed('/Product',
              arguments: new RouteArgument(
                  heroTag: this.widget.heroTag,
                  id: this.widget.product.id,
                  marketID: this.widget.product.market.id));
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Hero(
                  tag: widget.heroTag + widget.product.id,
                  child: Container(
                      // height: 150,
                      decoration: BoxDecoration(
                        // color: Theme.of(context).accentColor.withOpacity(0.3),
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                this.widget.product.image.url),
                            fit: BoxFit.fill,
                            colorFilter: !widget.product.inStock
                                ? new ColorFilter.mode(
                                    Colors.black.withOpacity(0.2),
                                    BlendMode.dstIn)
                                : ColorFilter.mode(null, null)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: !widget.product.inStock
                            ? Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.red)),
                                child: Text(
                                  S.of(context).out_of_stock,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ))
                            : SizedBox(
                                height: 0,
                              ),
                      )),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  widget.product.name,
                  style: Theme.of(context).textTheme.body2,
                  // overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 2),
              Container(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.product.capacity != "null" ? widget.product.capacity : ""} ${widget.product.unit != "null" ? widget.product.unit : ""}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.caption.merge(
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          widget.product.inStock
              ? Positioned(
                  left: isRTL ? null : 2,
                  right: isRTL ? 2 : null,
                  top: 2,
                  child: FittedBox(
                    child: Column(
                      children: [
                        Container(
                          // width: 80,
                          // height: 23,
                          margin: EdgeInsetsDirectional.only(start: 0, top: 0),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Theme.of(context).accentColor),
                          alignment: AlignmentDirectional.topEnd,
                          child: Center(
                            child: Helper.getPrice(
                              widget.product.price,
                              context,
                              style: Theme.of(context)
                                  .textTheme
                                  .body2
                                  .merge(TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12,
                                  )),
                            ),
                          ),
                        ),
                        widget.product.discountPrice > 0
                            ? Container(
                                // width: 80,
                                // height: 23,
                                margin: EdgeInsetsDirectional.only(
                                    start: 0, top: 4),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Theme.of(context).accentColor),
                                alignment: AlignmentDirectional.topEnd,
                                child: Center(
                                  child: Helper.getPrice(
                                    widget.product.discountPrice,
                                    context,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .merge(
                                          TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontSize: 11),
                                        ),
                                  ),
                                ),
                              )
                            : SizedBox(height: 0),
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  height: 0,
                ),
          widget.product.inStock
              ? Positioned(
                  bottom: 40,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    width: 40,
                    height: 40,
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        widget.onPressed();
                      },
                      child: Icon(
                        Icons.shopping_cart,
                        color: Theme.of(context).primaryColor,
                        size: 24,
                      ),
                      color: Theme.of(context).accentColor.withOpacity(0.9),
                      shape: StadiumBorder(),
                    ),
                  ),
                )
              : SizedBox(
                  height: 0,
                ),
          // Positioned(
          //   // top: 0,
          //   child: Container(
          //     margin: EdgeInsets.all(10),
          //     // width: 60,
          //     // height: 100,
          //     decoration: BoxDecoration(
          //       // color: Theme.of(context).accentColor.withOpacity(0.3),
          //       // borderRadius: BorderRadius.all(Radius.circular(20)),
          //       // image: DecorationImage(image: AssetImage('assets/img/sold-out.png'), fit: BoxFit.fill,)
          //     ),
          //     child: Center(
          //       child: Text('Solde Out'),
          //     )
          //   ),
          // ),
        ],
      ),
    );
  }
}
