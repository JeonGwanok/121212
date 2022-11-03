import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oasis/ui/theme.dart';

class InfoField extends StatefulWidget {
  final String title;
  final String value;
  final bool isHorizontal;
  final bool enabled;
  final Function? onTap;
  final double? titleWidth;
  final double? valuePadding;
  final int? maxLines;
  InfoField({
    required this.title,
    required this.value,
    this.isHorizontal = true,
    this.enabled = true,
    this.onTap,
    this.titleWidth,
    this.valuePadding,
    this.maxLines,
  });

  @override
  _InfoFieldState createState() => _InfoFieldState();
}

class _InfoFieldState extends State<InfoField> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: widget.isHorizontal
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: gray100),
                color: widget.enabled ? Colors.white : gray100.withOpacity(0.5),
              ),
              child: Row(
                children: [
                  Container(
                    height:
                        36.0 * (widget.maxLines ?? getTextLine(widget.value)),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: gray100,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    width: widget.titleWidth ?? 68,
                    child: Text(
                      widget.title,
                      style: header03.copyWith(
                          fontSize: 11.5,
                          color: widget.enabled
                              ? widget.onTap != null
                                  ? black
                                  : gray600
                              : gray500),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: widget.valuePadding ?? 7),
                      child: Text(
                        widget.value,
                        maxLines: widget.maxLines ?? getTextLine(widget.value),
                        overflow: TextOverflow.ellipsis,
                        // minFontSize: 1,
                        style: body01.copyWith(
                            height:
                                (widget.maxLines ?? getTextLine(widget.value)) >
                                        1
                                    ? 1.8
                                    : null,
                            fontSize: 11.5,
                            color: widget.enabled ? gray900 : gray400),
                      ),
                    ),
                  )
                ],
              ),
            )
          : Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: gray100),
                color: widget.enabled ? Colors.white : gray100.withOpacity(0.5),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    height: 36,
                    decoration: BoxDecoration(
                      color: gray100,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      widget.title,
                      style: header03.copyWith(
                          color: widget.enabled
                              ? widget.onTap != null
                                  ? black
                                  : gray600
                              : gray500),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(
                      widget.value,
                      style: body01.copyWith(color: gray600),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  int getTextLine(String text) {
    if (text.contains("\n")) {
      return text.split("\n").length;
    } else {
      return 1;
    }
  }
}
