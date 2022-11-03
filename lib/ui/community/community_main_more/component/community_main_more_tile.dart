import 'package:flutter/material.dart';
import 'package:oasis/enum/community/community.dart';
import 'package:oasis/model/community/community.dart';
import 'package:oasis/ui/common/cache_image.dart';
import 'package:oasis/ui/common/community/like_object.dart';
import 'package:oasis/ui/common/write/tags_object.dart';
import 'package:oasis/ui/theme.dart';

class CommunityMainMoreTile extends StatefulWidget {
  final CommunityResponseItem item;
  final CommunityType type;
  final Function onTap;
  CommunityMainMoreTile({
    required this.type,
    required this.item,
    required this.onTap,
  });

  @override
  _CommunityMainMoreTileState createState() => _CommunityMainMoreTileState();
}

class _CommunityMainMoreTileState extends State<CommunityMainMoreTile> {
  @override
  Widget build(BuildContext context) {
    var ratio = MediaQuery.of(context).size.width / 414;
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: cardShadow,
          borderRadius: BorderRadius.circular(8),
        ),
        height: widget.type == CommunityType.date ||
                widget.type == CommunityType.stylist
            ? (259 + 39) * ratio
            : 385 * ratio,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.type != CommunityType.date &&
                widget.type != CommunityType.stylist)
              Container(
                padding: EdgeInsets.only(left: 12, right: 12, top: 12),
                child: Text(
                  widget.item.community?.title ?? "--",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: header09,
                ),
              ),
            Container(
              padding: (widget.type != CommunityType.date &&
                      widget.type != CommunityType.stylist)
                  ? EdgeInsets.symmetric(horizontal: 12)
                  : null,
              margin: EdgeInsets.only(
                top: (widget.type != CommunityType.date &&
                        widget.type != CommunityType.stylist)
                    ? 12
                    : 0,
                bottom: 16,
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: cardShadow,
                    border: Border.all(color: Colors.white),
                  ),
                  child: CacheImage(
                    url: widget.item.image ?? "",
                    boxFit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.type != CommunityType.date &&
                        widget.type != CommunityType.stylist)
                      Expanded(
                        child: Text(
                          widget.item.community?.content ?? "--",
                          style: body02.copyWith(color: gray600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (widget.type != CommunityType.date &&
                        widget.type != CommunityType.stylist)
                      SizedBox(height: 17),
                    Container(
                      height: 48,
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: TagsObject(
                          tags: widget.item.community?.hashTag ?? [],
                        ),
                      ),
                    ),
                    SizedBox(height: 3 * ratio),
                    IgnorePointer(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: LikeObject(
                          likePressed:
                              widget.item.community?.likeStatus ?? false,
                          dislikePressed:
                              widget.item.community?.dislikeStatus ?? false,
                          like: widget.item.community?.like ?? 0,
                          dislike: widget.item.community?.dislike ?? 0,
                          onLike: () {},
                          onDislike: () {},
                        ),
                      ),
                    ),
                    if (widget.type != CommunityType.date &&
                        widget.type != CommunityType.stylist)
                      SizedBox(height: 5 * ratio),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
