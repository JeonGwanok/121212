import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/theme.dart';

class LikeObject extends StatefulWidget {
  final int like;
  final int dislike;
  final bool likePressed;
  final bool dislikePressed;
  final Function onLike;
  final Function onDislike;

  LikeObject({
    this.like = 0,
    this.dislike = 0,
    this.likePressed = false,
    this.dislikePressed = false,
    required this.onLike,
    required this.onDislike,
  });

  @override
  _LikeObjectState createState() => _LikeObjectState();
}

class _LikeObjectState extends State<LikeObject> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            widget.onLike();
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  child: CustomIcon(
                    path: widget.likePressed ?"icons/like_pressed" : "icons/like",
                  ),
                ),
                Text(
                  "${widget.like}",
                  style: header03.copyWith(color: gray600),
                )
              ],
            ),
          ),
        ),
        SizedBox(width: 4),
        GestureDetector(
          onTap: () {
            widget.onDislike();
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 40,
                  child: CustomIcon(
                    path: widget.dislikePressed ?"icons/dislike_pressed" : "icons/dislike",
                  ),
                ),
                Text(
                  "${widget.dislike}",
                  style: header03.copyWith(color: gray600),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
