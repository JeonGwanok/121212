import 'package:flutter/material.dart';
import 'package:oasis/ui/theme.dart';
import 'package:oasis/ui/util/bold_generator.dart';

class ImageDialog extends StatelessWidget {
  final String title;
  final String imagePath;
  final String imageType;
  final String description;
  final String defaultButtonTitle;
  final Function? onTap;

  ImageDialog({
    required this.title,
    required this.description,
    required this.imagePath,
    this.imageType = ".png",
    this.defaultButtonTitle = "아니요",
    this.onTap,
  });

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String imagePath,
    String imageType = ".png",
    required String description,
    String? defaultButtonTitle,
    Function? onTap,
  }) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ImageDialog(
            title: title,
            imagePath: imagePath,
            imageType: imageType,
            defaultButtonTitle: defaultButtonTitle ?? "아니요",
            description: description,
            onTap: onTap,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 370,
              child: Stack(alignment: Alignment.bottomLeft, children: [
                Container(
                  color: gray200,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset(
                      "assets/$imagePath.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(color: Colors.black.withOpacity(0.2)),
                Container(
                  padding: EdgeInsets.only(
                    left: 28,
                    right: 28,
                    bottom: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: header02.copyWith(color: Colors.white),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        child: BoldMsgGenerator.toRichText(
                          msg: description,
                          style: body01.copyWith(color: Colors.white),
                          boldWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            // 버튼들
            Container(
              height: 52,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context, false);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: mainMint,
                        child: Text(
                          defaultButtonTitle,
                          style: header02.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  if (onTap != null)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          onTap!();
                          Navigator.pop(context, true);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: darkBlue,
                          child: Text(
                            '네',
                            style: header02.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
