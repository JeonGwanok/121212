import 'package:flutter/material.dart';
import 'package:oasis/model/my_story/my_story.dart';

import '../../theme.dart';

class CoupleStoryBaseTile extends StatefulWidget {
  final int idx;
  final MyStory item;
  final Function onTap;
  CoupleStoryBaseTile({
    required this.idx,
    required this.item,
    required this.onTap,
  });
  @override
  _CoupleStoryBaseTileState createState() => _CoupleStoryBaseTileState();
}

class _CoupleStoryBaseTileState extends State<CoupleStoryBaseTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        height: 68,
        padding: EdgeInsets.symmetric(horizontal: 16),
        margin: EdgeInsets.symmetric(vertical: 8),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
            boxShadow: cardShadow,
            color: Colors.white),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                "${widget.idx + 1}",
                style: body03.copyWith(color: gray600),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  widget.item.content ?? "--",
                  overflow: TextOverflow.ellipsis,
                  style: body01.copyWith(color: gray600),
                ),
              ),
            ),
            Text(
              "(${(widget.item.commentCount)})",
              style: body01.copyWith(color: gray600),
            ), // 수정필요
          ],
        ),
      ),
    );
  }
}
