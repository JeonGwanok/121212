import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/write/tags_object.dart';
import 'package:oasis/ui/theme.dart';

class CommunityTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final List<String> tags;

  final Function onTap;

  CommunityTile({
    required this.onTap,
    required this.iconPath,
    required this.title,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: 138,
        margin: EdgeInsets.only(right: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            border: Border.all(color: gray200),
            borderRadius: BorderRadius.circular(8),
            boxShadow: cardShadow,
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: lightMint,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIcon(
                path: iconPath,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 12, bottom: 24),
              child: Text(
                title,
                style: header05.copyWith(
                  fontFamily: "Godo",
                ),
              ),
            ),
            TagsObject(tags: tags)
          ],
        ),
      ),
    );
  }
}
