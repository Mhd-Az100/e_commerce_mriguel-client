import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../generated/i18n.dart';
import '../helpers/helper.dart';
import '../models/product.dart';
import '../models/route_argument.dart';

class ProductItemWidget extends StatelessWidget {
  final String heroTag;
  final Product product;
  final VoidCallback onPressed;
  final bool disableImg;

  const ProductItemWidget(
      {Key key,
      this.product,
      this.heroTag,
      this.onPressed,
      this.disableImg = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.of(context).pushNamed('/Product',
            arguments: RouteArgument(
                id: product.id,
                heroTag: this.heroTag,
                marketID: product.market.id));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            this.disableImg == false
                ? Hero(
                    tag: heroTag + product.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: CachedNetworkImage(
                        height: 60,
                        width: 60,
                        fit: BoxFit.fill,
                        imageUrl: product.image.thumb,
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                          height: 60,
                          width: 60,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  )
                : SizedBox(width: 0),
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
                          product.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subhead,
                        ),
                        Text(
                          '${product.capacity} ${product.unit != "null" ? product.unit : ""}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.caption.merge(
                              TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                        // Text(
                        //   '${product.packageItemsCount} ${S.current.items}',
                        //   overflow: TextOverflow.ellipsis,
                        //   maxLines: 2,
                        //   style: Theme.of(context).textTheme.caption.merge(TextStyle(fontWeight: FontWeight.bold,fontSize:13)),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Row(
                    children: [
                      Column(
                        children: [
                          Center(
                              child: Helper.getPrice(product.price, context,
                                  style: Theme.of(context)
                                      .textTheme
                                      .display1
                                      .merge(TextStyle(fontSize: 15)))),
                          product.discountPrice > 0
                              ? Helper.getPrice(
                                  product.discountPrice,
                                  context,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .merge(
                                        TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                )
                              : SizedBox(height: 0),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        width: 40,
                        height: 40,
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            onPressed();
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
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
