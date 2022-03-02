import 'package:flutter/material.dart';

class PillsWidget extends StatelessWidget {
  final String title;
  final Color color;
  final Color textColor;
  final double height;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;
  final Color borderColor;
  final bool width;

  const PillsWidget(
      {Key key,
      this.title,
      this.color,
      this.textColor,
      this.height,
      this.padding,
      this.fontWeight,
      this.borderColor,
      this.width})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: this.width ? null : 90,
      height: height ?? 40,
      padding: this.padding,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: this.color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).accentColor),
      ),
      child: Center(
        child: Text(
          this.title,
          style: TextStyle(
            fontSize: 14.5,
            color: this.textColor,
            fontWeight: fontWeight ?? FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
