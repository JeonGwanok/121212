import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:oasis/ui/common/custom_icon.dart';

import '../theme.dart';
import 'base_scaffold.dart';

class DefaultButton extends StatefulWidget {
  final bool reverse;
  final String title;
  final String? description;
  final String? icon;
  final Color? color;
  final Function? onTap;
  final HeartAnimationType showGif;

  DefaultButton(
      {required this.title,
      this.description,
      this.icon,
      this.reverse = false,
      this.onTap,
      this.color,
      this.showGif = HeartAnimationType.none});

  @override
  State<StatefulWidget> createState() => DefaultButtonState();
}

class DefaultButtonState extends State<DefaultButton> {
  var bottomPadding = 0.0;
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        bottomPadding = MediaQuery.of(context).padding.bottom;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var buttonHeight = 74.0;
    var activateColor = widget.color ?? darkBlue;
    var deactivateColor = gray300;
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 14,
              right: 14,
            ),
            decoration: BoxDecoration(
                border: Border.all(
                    color: widget.reverse ? gray300 : gray300.withOpacity(0)),
                color: widget.reverse
                    ? Colors.white
                    : (widget.onTap != null ? activateColor : deactivateColor)),
            height: buttonHeight + bottomPadding,
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              height: buttonHeight,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutoSizeText(
                    widget.title,
                    minFontSize: 1,
                    maxLines: 1,
                    style: header02.copyWith(
                      fontFamily: "Godo",
                      color: widget.reverse ? black : Colors.white,
                    ),
                  ),
                  if ((widget.description ?? "").isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 2),
                      child: AutoSizeText(
                        widget.description!,
                        minFontSize: 1,
                        maxLines: 1,
                        style: caption01.copyWith(
                          color: widget.reverse ? black : Colors.white,
                        ),
                      ),
                    ),
                  if ((widget.icon ?? "").isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: CustomIcon(
                        path: widget.icon!,
                        width: 20,
                        height: 20,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (widget.showGif != HeartAnimationType.none)
            Positioned(
              bottom: 74 + MediaQuery.of(context).padding.bottom + 3,
              child: Image.asset(
                "assets/icons/${widget.showGif.imagePath}.gif",
                width: 130,
                height: 130,
              ),
            ),
        ],
      ),
    );
  }
}
