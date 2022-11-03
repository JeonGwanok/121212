import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class DefaultSmallButton extends StatefulWidget {
  final bool reverse;
  final String title;
  final Color? color;
  final double? fontSize;
  final Function? onTap;
  final bool showShadow;
  final bool hideBorder;
  final bool isGrayScale;
  final double? horizontalPadding;

  DefaultSmallButton({
    required this.title,
    this.reverse = false,
    this.fontSize,
    this.onTap,
    this.color,
    this.hideBorder = false,
    this.showShadow = false,
    this.isGrayScale = false,
    this.horizontalPadding,
  });

  @override
  State<StatefulWidget> createState() => DefaultSmallButtonState();
}

class DefaultSmallButtonState extends State<DefaultSmallButton> {
  @override
  Widget build(BuildContext context) {
    var activateColor = widget.color ?? mainMint;
    var deactivateColor = gray300;
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: widget.horizontalPadding ?? 14),
        decoration: BoxDecoration(
            boxShadow: widget.showShadow ? cardShadow : null,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: widget.reverse
                    ? (!widget.hideBorder
                        ? (widget.onTap == null
                            ? gray300
                            : (widget.isGrayScale ? gray300 : mainMint))
                        : Colors.transparent)
                    : gray300.withOpacity(0)),
            color: widget.reverse
                ? Colors.white
                : (widget.onTap != null ? activateColor : deactivateColor)),
        height: 52,
        alignment: Alignment.topCenter,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          height: 52,
          alignment: Alignment.center,
          child: AutoSizeText(
            widget.title,
            minFontSize: 1,
            maxLines: 1,
            style: header02.copyWith(
              fontFamily: "Godo",
              fontSize: widget.fontSize,
              color: widget.reverse
                  ? (widget.onTap == null
                      ? gray300
                      : (widget.isGrayScale ? gray600 : mainMint))
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
