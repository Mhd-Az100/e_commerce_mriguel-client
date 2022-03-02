import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markets/generated/i18n.dart';

import '../helpers/helper.dart';
import '../models/product.dart';
import '../models/route_argument.dart';

class ProductsCarouselItemWidget extends StatelessWidget {
  double marginLeft;
  Product product;
  String heroTag;
  final VoidCallback onPressed;

  ProductsCarouselItemWidget({Key key, this.heroTag, this.marginLeft, this.product,this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).pushNamed('/Product', arguments: RouteArgument(id: product.id, heroTag: heroTag,marketID:this.product.market.id));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.topEnd,
            children: <Widget>[
              Hero(
                tag: heroTag + product.id,
                child: Container(
                  margin: EdgeInsetsDirectional.only(start: this.marginLeft, end: 20),
                  width: 100,
                  height: 130,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: product.image.url,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsetsDirectional.only(start: 0, top: 5),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)), color: Theme.of(context).accentColor),
                      alignment: AlignmentDirectional.topEnd,
                      child: Helper.getPrice(
                        product.price,
                        context,
                        style: Theme.of(context).textTheme.body2.merge(TextStyle(color: Theme.of(context).primaryColor,fontSize: 12)),
                      ),
                      
                    ),
                    product.discountPrice > 0 ? Helper.getPrice(product.discountPrice, context, style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(decoration: TextDecoration.lineThrough,fontSize: 11))) : SizedBox(height:0),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child:Container(
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
              )
            ],
          ),
          SizedBox(height: 5),
          Container(
              width: 100,
              margin: EdgeInsetsDirectional.only(start: this.marginLeft, end: 20),
              child: Column(
                children: <Widget>[
                  Text(
                    this.product.name,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: Theme.of(context).textTheme.body1,
                  ),
                  Text(
                          '${product.capacity} ${product.unit}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.caption.merge(TextStyle(fontWeight: FontWeight.bold,fontSize:13)),
                        ),
                        // Text(
                        //   '${product.capacity} ${S.current.items}',
                        //   overflow: TextOverflow.ellipsis,
                        //   maxLines: 2,
                        //   style: Theme.of(context).textTheme.caption.merge(TextStyle(fontWeight: FontWeight.bold,fontSize:13)),
                        // ),
                ],
              )),
        ],
      ),
    );
  }
}
