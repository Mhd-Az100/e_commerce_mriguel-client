import 'package:flutter/material.dart';

import '../elements/CategoriesCarouselItemWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesCarouselWidget extends StatelessWidget {
  List<Category> categories;

  CategoriesCarouselWidget({Key key, this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.categories.isEmpty
        ? CircularLoadingWidget(height: 150.w)
        :
        // Container(
        //     height: 180,
        //     padding: EdgeInsets.symmetric(vertical: 10),
        //     child: ListView.builder(
        //       itemCount: this.categories.length,
        //       scrollDirection: Axis.horizontal,
        //       itemBuilder: (context, index) {
        //         double _marginLeft = 0;
        //         (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
        //         return new CategoriesCarouselItemWidget(
        //           marginLeft: _marginLeft,
        //           category: this.categories.elementAt(index),
        //         );
        //       },
        //     ));
        GridView.count(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            primary: false,
            crossAxisSpacing: 1.w,
            mainAxisSpacing: 5.w,
            childAspectRatio: MediaQuery.of(context).size.height.h / 800.h,
            padding: EdgeInsets.symmetric(vertical: 5.w),
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 3
                    : 5,
            children: List.generate(categories.length, (index) {
              // double _marginLeft = 0;
              //         (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
              return new CategoriesCarouselItemWidget(
                marginLeft: 10.w,
                category: this.categories.elementAt(index),
              );
            }),
          );
  }
}
