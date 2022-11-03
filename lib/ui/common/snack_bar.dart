import 'package:flutter/material.dart';
import 'package:oasis/ui/common/custom_icon.dart';

import '../theme.dart';

SnackBar snackBar(
  BuildContext context,
  String title,
) {
  var ratio = MediaQuery.of(context).size.height / 896;
  var contentHeight = 100.0 * ratio;
  return SnackBar(
    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    margin: EdgeInsets.only(
        left: 0,
        right: 0,
        bottom: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            contentHeight +
            20),
    content: Container(
      height: contentHeight,
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, left: 16, right: 16),
      alignment: Alignment.center,
      child: Row(
        children: [
          CustomIcon(path: "icons/alert"),
          SizedBox(width: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: body01.copyWith(color: Colors.white),
          ),
        ],
      ),
    ),
    elevation: 0,
    duration: Duration(seconds: 1),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
    ),
    backgroundColor: red500,
  );
}
