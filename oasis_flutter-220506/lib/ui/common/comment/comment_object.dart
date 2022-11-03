import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oasis/model/my_story/comment.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/common/write_option_pop_menu.dart';

import '../../theme.dart';

class CommentObject extends StatefulWidget {
  final UserProfile user;
  final Function(String) onComment;
  final List<Comment> comments;

  final Function(int commentId) onEdit;
  final Function(int commentId) onDelete;
  final Function(int commentId, String conent) onReport;
  final Function(int customerId) onBlock;

  CommentObject(
    Key key, {
    required this.user,
    required this.onComment,
    this.comments = const [],
    required this.onEdit,
    required this.onDelete,
    required this.onReport,
    required this.onBlock,
  }) : super(key: key);

  @override
  _CommentObjectState createState() => _CommentObjectState();
}

class _CommentObjectState extends State<CommentObject> {
  String text = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '댓글',
            style: header02.copyWith(color: gray900),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: cardShadow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: DefaultField(
                    hintText: "댓글을 입력해주세요.",
                    onChange: (text) {
                      setState(() {
                        this.text = text;
                      });
                    },
                  ),
                ),
                SizedBox(width: 12),
                DefaultSmallButton(
                  title: "댓글입력",
                  onTap: text.isNotEmpty
                      ? () {
                          widget.onComment(text);
                        }
                      : null,
                ),
              ],
            ),
          ),
          if (widget.comments.isEmpty)
            Container(
              height: 100,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                '댓글이 없습니다.',
                style: header02.copyWith(color: gray300),
              ),
            ),
          ...widget.comments.reversed.map((e) => _tile(e)).toList(),
        ],
      ),
    );
  }

  _tile(Comment comment) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: cardShadow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  comment.nickName ?? "---",
                  style: header03.copyWith(color: gray500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      comment.createdAt != null
                          ? DateFormat("yyyy.MM.dd HH:mm:ss")
                              .format(comment.createdAt!)
                          : "---",
                      style: body01.copyWith(color: gray300),
                    ),
                    SizedBox(width: 10),
                    WriteOptionPopMenuList(
                      iconSize: 20,
                      userId: widget.user.customer?.id ?? 0,
                      writtenById: comment.customerId ?? 0,
                      onEdit: null,
                      // onEdit:  () {
                      //   widget.onEdit(comment.id ?? 0);
                      // },
                      onDelete: () {
                        widget.onDelete(comment.id ?? 0);
                      },
                      onReport: (content) {
                        widget.onReport(comment.id ?? 0, content);
                      },
                      onBlock: () {
                        widget.onBlock(comment.customerId ?? 0);
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              comment.comment ?? "---",
              style: body02.copyWith(color: gray500),
            ),
          ],
        ),
      ),
    );
  }
}
