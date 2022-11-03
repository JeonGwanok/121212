import 'dart:math';
import 'package:flutter/material.dart';
import 'package:oasis/ui/common/custom_icon.dart';

import '../../theme.dart';

class HomeButtonFrame extends StatefulWidget {
  final String title;
  final Widget body;
  final String moreTitle;
  final Function? onMore;
  final bool isMoreIcon; // more 이 아이콘인지 아닌지
  final double titleBottomPadding;
  HomeButtonFrame(
      {required this.title,
      this.isMoreIcon = false,
      this.titleBottomPadding = 25,
      required this.body,
      this.moreTitle = "더보기",
      this.onMore});
  @override
  _HomeButtonFrameState createState() => _HomeButtonFrameState();
}

class _HomeButtonFrameState extends State<HomeButtonFrame> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onMore != null && widget.isMoreIcon) {
          widget.onMore!();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: cardShadow,
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style:
                        header02.copyWith(fontFamily: "Godo", color: mainNavy),
                  ),
                  if (widget.onMore != null)
                    widget.isMoreIcon
                        ? Transform.rotate(
                            angle: -pi / 2,
                            child: CustomIcon(
                              width: 20,
                              height: 20,
                              color: mainMint,
                              path: "icons/downArrow",
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              if (widget.onMore != null) {
                                widget.onMore!();
                              }
                            },
                            child: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(vertical: 4),
                              width: 50,
                              color: Colors.transparent,
                              child: Text(
                                widget.moreTitle,
                                style: body02.copyWith(color: mainMint),
                              ),
                            ),
                          )
                ],
              ),
            ),
            SizedBox(height: widget.titleBottomPadding),
            widget.body
          ],
        ),
      ),
    );
  }
}
