import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class Illust extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;
  final Color? textColor;
  final BorderRadius? radius;
  final String title;
  Illust({this.title = "illust", this.width = 28, this.height = 28, this.color, this.textColor,this.radius,});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius:radius ?? BorderRadius.circular(5),
        color: color ?? Colors.black.withOpacity(0.1)
      ),
      child: Center(
        child: AutoSizeText(
          title,
          minFontSize: 1,
          maxLines: 1,
          style: body01.copyWith(color: textColor ?? Colors.white),
        ),
      ),
    );
  }
}
