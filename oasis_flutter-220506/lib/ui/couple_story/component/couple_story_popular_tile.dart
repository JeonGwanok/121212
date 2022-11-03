import 'package:flutter/material.dart';
import 'package:oasis/model/my_story/my_story_response.dart';
import 'package:oasis/ui/common/write/tags_object.dart';

import '../../theme.dart';

class CoupleStoryPopularTile extends StatefulWidget {
  final int idx;
  final MyStoryPopular item;
  final Function onTap;
  CoupleStoryPopularTile({
    required this.idx,
    required this.item,
    required this.onTap,
  });
  @override
  _CoupleStoryPopularTileState createState() => _CoupleStoryPopularTileState();
}

class _CoupleStoryPopularTileState extends State<CoupleStoryPopularTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        constraints: BoxConstraints(minHeight: 92),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 8),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
            boxShadow: cardShadow,
            color: Colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Container(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 36,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.item.content ?? "--",
                          overflow: TextOverflow.ellipsis,
                          style: body01.copyWith(color: gray600),
                        ),
                      ),
                      Text(
                        "(${widget.item.commentCount ?? 0})",
                        style: body01.copyWith(color: gray600),
                      )
                    ],
                  ),
                  TagsObject(tags: widget.item.hashTag, spacing: 2)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
