import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:oasis/ui/theme.dart';

class DefaultDialog extends StatelessWidget {
  final String title;
  final String? description;
  final String defaultButtonTitle;
  final Function? onTap;
  final Widget? child;
  final int? yesRatio;

  DefaultDialog({
    this.title = "Title",
    this.description,
    this.defaultButtonTitle = "아니요",
    this.onTap,
    this.child,
    this.yesRatio,
  });

  static Future<bool> show(
    BuildContext context, {
    required String title,
    String? description,
    String? defaultButtonTitle,
    Function? onTap,
    Widget? child,
    int? yesRatio,
  }) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return DefaultDialog(
            title: title,
            defaultButtonTitle: defaultButtonTitle ?? "아니요",
            description: description,
            onTap: onTap,
            child: child,
            yesRatio: yesRatio,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 49, horizontal: 16),
              child: Column(
                children: [
                  AutoSizeText(
                    title,
                    minFontSize: 1,
                    textAlign: TextAlign.center,
                    style: header02.copyWith(height: 1.5),
                  ),
                  if (description != null)
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Text(
                        description!,
                        textAlign: TextAlign.center,
                        style: body01.copyWith(color: gray600),
                      ),
                    ),
                  if (child != null) child ?? Container()
                ],
              ),
            ),
            Container(
              height: 52,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: gray100),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context, false);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.white.withOpacity(0),
                        child: Text(
                          defaultButtonTitle,
                          style: header02.copyWith(color: mainMint),
                        ),
                      ),
                    ),
                  ),
                  if (onTap != null)
                    Expanded(
                      flex: yesRatio ?? 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context, true);
                          onTap!();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: yesRatio != null ? BorderRadius.only(
                                bottomRight: Radius.circular(12)) : null,
                            color: yesRatio == null
                                ? Colors.white.withOpacity(0)
                                : mainMint,
                            border: yesRatio == null ? Border(
                              left: BorderSide(color: gray100) ,
                            ) : null,
                          ),
                          child: Text(
                            '네',
                            style: header02.copyWith(
                                color:
                                    yesRatio != null ? Colors.white : darkBlue),
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
