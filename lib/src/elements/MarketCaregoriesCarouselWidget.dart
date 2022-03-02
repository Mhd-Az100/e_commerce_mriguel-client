import 'package:flutter/material.dart';

import 'MarketCategoriesCarouselItemWidget.dart';
import 'CircularLoadingWidget.dart';
import '../models/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class MarketCategoriesCarouselWidget extends StatelessWidget {
  List<Category> categories;
  final String marketId;

  MarketCategoriesCarouselWidget({Key key, this.categories, this.marketId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.categories.isEmpty
        ? CircularLoadingWidget(height: 150)
        : GridView.count(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            primary: false,
            crossAxisSpacing: 1,
            mainAxisSpacing: 10,
            childAspectRatio: MediaQuery.of(context).size.height.h / 1000.h,
            padding: EdgeInsets.symmetric(vertical: 5),
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 3
                    : 5,
            children: List.generate(categories.length, (index) {
              // double _marginLeft = 0;
              //         (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
              return new MarketCategoriesCarouselItemWidget(
                marginLeft: 10,
                category: this.categories.elementAt(index),
                marketId: this.marketId,
              );
            }),
          );
  }
}
