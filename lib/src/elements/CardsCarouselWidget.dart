import 'package:flutter/material.dart';
import 'package:markets/src/helpers/global.dart';

import '../elements/CircularLoadingWidget.dart';
import '../models/market.dart';
import '../models/route_argument.dart';
import 'CardWidget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardsCarouselWidget extends StatefulWidget {
  List<Market> marketsList;
  String heroTag;

  CardsCarouselWidget({Key key, this.marketsList, this.heroTag})
      : super(key: key);

  @override
  _CardsCarouselWidgetState createState() => _CardsCarouselWidgetState();
}

class _CardsCarouselWidgetState extends State<CardsCarouselWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.marketsList.isEmpty
        ? SizedBox(
            height: 0,
          )
        // ? CircularLoadingWidget(height: 288)
        : Container(
            height: 260.w,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.marketsList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // listUsers.add(widget.marketsList.elementAt(index).);
                    Navigator.of(context).pushNamed(
                      '/Details',
                      arguments: RouteArgument(
                        id: widget.marketsList.elementAt(index).id,
                        heroTag: widget.heroTag,
                      ),
                    );
                  },
                  child: CardWidget(
                    market: widget.marketsList.elementAt(index),
                    heroTag: widget.heroTag,
                  ),
                );
              },
            ),
          );
  }
}
