import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oasis/model/my_story/my_story.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import '../../theme.dart';

class CoupleStoryTile extends StatefulWidget {
  final int idx;
  final MyStory item;
  final Function onTap;
  CoupleStoryTile({
    required this.idx,
    required this.item,
    required this.onTap,
  });
  @override
  _CoupleStoryTileState createState() => _CoupleStoryTileState();
}

class _CoupleStoryTileState extends State<CoupleStoryTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        height: 72,
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 8),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
            boxShadow: cardShadow,
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  widget.item.content ?? "--",
                  overflow: TextOverflow.ellipsis,
                  style: body01.copyWith(color: gray600),
                )),
                Transform.rotate(
                  angle: -pi / 2,
                  child: CustomIcon(
                    path: "icons/downArrow",
                    width: 12,
                    height: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "작성일시: ${widget.item.createdAt != null ? DateFormat("yyyy.MM.dd").format(widget.item.createdAt!) : "--"}     조회수: --",
              style: body02.copyWith(color: gray300),
            ),
          ],
        ),
      ),
    );
  }
}
