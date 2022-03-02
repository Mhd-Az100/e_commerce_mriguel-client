import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../helpers/helper.dart';
import '../models/favorite.dart';
import '../models/route_argument.dart';

// ignore: must_be_immutable
class FavoriteListItemWidget extends StatelessWidget {
  String heroTag;
  Favorite favorite;
  VoidCallback onPress ;

  FavoriteListItemWidget({Key key, this.heroTag, this.favorite,this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.of(context)
            .pushNamed('/Product', arguments: new RouteArgument(heroTag: this.heroTag, id: this.favorite.product.id,marketID:this.favorite.product.market.id));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: heroTag + favorite.product.id,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  image: DecorationImage(image: CachedNetworkImageProvider(favorite.product.image.thumb), fit: BoxFit.cover),
                ),
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
                          favorite.product.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subhead,
                        ),
                        Text(
                          favorite.product.market.name,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Row(
                    children: [
                      Helper.getPrice(favorite.product.price, context, style: Theme.of(context).textTheme.display1),
                      Container(
                        margin: EdgeInsets.all(10),
                        width: 40,
                        height: 40,
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed:  onPress,
                          child: Icon( 
                            Icons.restore_from_trash,
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
