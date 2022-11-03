import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final String path;
  final Color? color;
  final BoxFit? boxFit;
  final Alignment? alignment;
  final String? type;
  CustomIcon({
    this.width = 40,
    this.height = 40,
    required this.path,
    this.color,
    this.boxFit,
    this.type = ".svg",
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return type == ".svg"
        ? SvgPicture.asset(
            "assets/$path.svg",
            width: width,
            height: height,
            color: color,
            fit: boxFit ?? BoxFit.contain,
          )
        : Container(
            width: width,
            height: height,
            alignment: alignment,
            child: Image.asset(
              "assets/$path.png",
              color: color,
              fit: boxFit ?? BoxFit.contain,
            ),
          );
  }
}
