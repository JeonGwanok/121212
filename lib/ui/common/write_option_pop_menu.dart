import 'package:flutter/material.dart';
import 'package:oasis/ui/common/report_dialog.dart';

import '../theme.dart';
import 'custom_icon.dart';
import 'default_dialog.dart';

class WriteOptionPopMenuList extends StatefulWidget {
  final int userId; // 내 id
  final int writtenById; // 글 쓴 사람 id
  final Function? onEdit;
  final Function onDelete;
  final Function(String) onReport;
  final Function onBlock;
  final double? iconSize;

  WriteOptionPopMenuList({
    required this.userId,
    required this.writtenById,
    required this.onEdit,
    required this.onDelete,
    required this.onReport,
    required this.onBlock,
    this.iconSize,
  });

  @override
  _WriteOptionPopMenuListState createState() => _WriteOptionPopMenuListState();
}

class _WriteOptionPopMenuListState extends State<WriteOptionPopMenuList> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      elevation: 1.5,
      offset: Offset(0, widget.iconSize ?? 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      itemBuilder: (context) {
        return [
          if ( widget.onEdit != null && widget.writtenById == widget.userId)
            PopupMenuItem(
              value: "edit",
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "수정",
                  style: body02.copyWith(
                    color: mainMint,
                  ),
                ),
              ),
            ),
          if (widget.writtenById == widget.userId)
            PopupMenuItem(
              value: 'delete',
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "삭제",
                  style: body02.copyWith(
                    color: mainMint,
                  ),
                ),
              ),
            ),
          if (widget.writtenById != widget.userId)
            PopupMenuItem(
              value: 'report',
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "신고",
                  style: body02.copyWith(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          if (widget.writtenById != widget.userId)
            PopupMenuItem(
              value: 'block',
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "차단",
                  style: body02.copyWith(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
        ];
      },
      child: Container(
        child: CustomIcon(
          height: widget.iconSize,
          path: "icons/more",
        ),
      ),
      onSelected: (val) async {
        if (val == "edit") {

          if (widget.onEdit != null) {
            widget.onEdit!();
          }
        }
        if (val == "delete") {
          DefaultDialog.show(context, title: "정말 삭제하시겠습니까?", onTap: () {
            widget.onDelete();
          });
        }
        if (val == "report") {
          DefaultDialog.show(context, title: "정말 신고하시겠습니까?", onTap: () {
            ReportDialog.show(context, onSuccess: (content) {
              widget.onReport(content);
            });
          });
        }
        if (val == "block") {
          DefaultDialog.show(context,
              title: "정말 차단하시겠습니까?",
              description: "작성자가 쓴 모든 글을 볼 수 없게됩니다.", onTap: () {
            widget.onBlock();
          });
        }
      },
    );
  }
}
