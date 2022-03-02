import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../generated/i18n.dart';
import '../helpers/helper.dart';
import '../models/market.dart';
import '../models/route_argument.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardWidget extends StatelessWidget {
  Market market;
  String heroTag;

  CardWidget({Key key, this.market, this.heroTag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 292.w,
      margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 5.w, bottom: 5.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).focusColor.withOpacity(0.1),
              blurRadius: 15.w,
              offset: Offset(0, 5.w)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Image of the card
          Stack(
            fit: StackFit.loose,
            alignment: AlignmentDirectional.bottomStart,
            children: <Widget>[
              Hero(
                tag: this.heroTag + market.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.w),
                      topRight: Radius.circular(10.w)),
                  child: CachedNetworkImage(
                    height: 180.h,
                    width: double.infinity,
                    fit: BoxFit.fill,
                    imageUrl: market.image.url,
                    placeholder: (context, url) => Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150.h,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.w),
                    decoration: BoxDecoration(
                        color: market.closed ? Colors.grey : Colors.green,
                        borderRadius: BorderRadius.circular(24.w)),
                    child: market.closed
                        ? Text(
                            S.of(context).closed,
                            style: Theme.of(context).textTheme.caption.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          )
                        : Text(
                            S.of(context).open,
                            style: Theme.of(context).textTheme.caption.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ),
                  ),
                  this.market.availableForDelivery
                      ? Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 0, vertical: 8.w),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 3.w),
                          decoration: BoxDecoration(
                              color: this.market.availableForDelivery
                                  ? Colors.green
                                  : Colors.orange,
                              borderRadius: BorderRadius.circular(24.w)),
                          child: this.market.availableForDelivery
                              ? Text(
                                  S.of(context).delivery,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .merge(TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                )
                              : Text(''))
                      : Text(''),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        market.name,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: Theme.of(context).textTheme.subhead,
                      ),
                      SizedBox(height: 5.w),
                      Row(
                        children:
                            Helper.getStarsList(double.parse(market.rate)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
