import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oasis/model/my_story/my_story.dart';
import 'package:oasis/ui/common/cache_image.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/write/tags_object.dart';

import '../../../theme.dart';

class MyStoryTile extends StatefulWidget {
  final MyStory item;
  final Function onTap;
  MyStoryTile({
    required this.item,
    required this.onTap,
  });
  @override
  _MyStoryTileState createState() => _MyStoryTileState();
}

class _MyStoryTileState extends State<MyStoryTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        height: 148,
        margin: EdgeInsets.symmetric(vertical: 8),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
            boxShadow: cardShadow,
            color: Colors.white),
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                child: CacheImage(
                  boxFit: BoxFit.cover,
                  url: widget.item.imageUrlList.isNotEmpty
                      ? widget.item.imageUrlList.first
                      : "",
                ),
                color: gray200,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.item.content ?? "---",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: body01.copyWith(color: gray600),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              "작성일시: ${widget.item.createdAt != null ? DateFormat("yyyy.MM.dd hh:mm:ss").format(widget.item.createdAt!) : "--"}",
                              maxLines: 1,
                              minFontSize: 1,
                              style: body02.copyWith(color: gray300),
                            ),
                            SizedBox(height: 12),
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child:
                                        TagsObject(tags: widget.item.hashTag),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "${widget.item.like ?? 0}",
                                        style: body03,
                                      ),
                                      SizedBox(width: 6),
                                      CustomIcon(
                                        path: "icons/heart",
                                        width: 20,
                                        height: 20,
                                        color: heartRed,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
