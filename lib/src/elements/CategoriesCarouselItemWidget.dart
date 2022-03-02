import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/category.dart';
import '../models/route_argument.dart';

// ignore: must_be_immutable
class CategoriesCarouselItemWidget extends StatelessWidget {
  double marginLeft;
  Category category;
  CategoriesCarouselItemWidget({Key key, this.marginLeft, this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).pushNamed('/Category',
            arguments: RouteArgument(id: category.id, category: category));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Hero(
            tag: category.id,
            child: Container(
              margin:
                  EdgeInsetsDirectional.only(start: this.marginLeft, end: 5.w),
              width: 110.w,
              height: 95.w,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(5.w)),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).focusColor.withOpacity(0.2),
                        offset: Offset(0, 2.w),
                        blurRadius: 7.0)
                  ]),
              child: Padding(
                  padding: EdgeInsets.all(15.w),
                  child: CachedNetworkImage(
                    imageUrl: category.image.url,
                  )
                  // category.image.url.toString().split(".").contains("svg")
                  // ? SvgPicture.network(
                  //     category.image.url,
                  //     color: Theme.of(context).accentColor,
                  //   )
                  // : Image.network(category.image.url),
                  ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            child: Flexible(
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.body1.merge(
                    TextStyle(fontSize: 11.w, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          // SizedBox(height: 5),
        ],
      ),
    );
  }
}
