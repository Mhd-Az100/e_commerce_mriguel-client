import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markets/src/controllers/favorite_controller.dart';

import '../models/favorite.dart';
import '../models/route_argument.dart';

class FavoriteGridItemWidget extends StatelessWidget {
  String heroTag;
  Favorite favorite;
  VoidCallback onPress ;

  FavoriteGridItemWidget({Key key, this.heroTag, this.favorite,this.onPress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        Navigator.of(context)
            .pushNamed('/Product', arguments: new RouteArgument(heroTag: this.heroTag, id: this.favorite.product.id,marketID:this.favorite.product.market.id));
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Hero(
                  tag: heroTag + favorite.product.id,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: CachedNetworkImageProvider(this.favorite.product.image.thumb), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                favorite.product.name,
                style: Theme.of(context).textTheme.body2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                favorite.product.market.name,
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
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
    );
  }
}
