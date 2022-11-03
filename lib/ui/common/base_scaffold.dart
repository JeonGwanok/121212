import 'package:flutter/material.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_button.dart';

import '../theme.dart';

enum HeartAnimationType { none, pink, white, green }

extension HeartAnimationTypeExtension on HeartAnimationType {
  String get imagePath {
    switch (this) {
      case HeartAnimationType.none:
        return "";
      case HeartAnimationType.pink:
        return "pink_heart";
      case HeartAnimationType.white:
        return "white_heart";
      case HeartAnimationType.green:
        return "green_heart";
    }
  }
}

class BaseScaffoldDefaultButtonScheme {
  final String title;
  final String? description;
  final String? icon;
  final Color color;
  final HeartAnimationType showGif;
  final Function? onTap;
  BaseScaffoldDefaultButtonScheme({
    required this.title,
    this.description,
    this.icon,
    this.color = darkBlue,
    this.showGif = HeartAnimationType.none,
    this.onTap,
  });
}

class BaseScaffold extends StatelessWidget {
  final String? title;
  final Function? onBack;
  final Widget? backItem;
  final Widget? body;
  final bool onLoading;
  final Widget? action;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final Color? appbarColor;
  final bool centerTitle;
  final bool? resizeToAvoidBottomInset;
  final bool showAppbarUnderline;
  final bool isFirstPage;
  final Function? onTitleTap;

  final List<BaseScaffoldDefaultButtonScheme>? buttons;

  BaseScaffold(
      {this.title,
      this.centerTitle = true,
      this.isFirstPage = false,
      this.appbarColor,
      this.resizeToAvoidBottomInset,
      this.bottomNavigationBar,
      this.backgroundColor,
      this.onBack,
      this.backItem,
      this.body,
      this.onLoading = false,
      this.action,
      this.showAppbarUnderline = true,
      this.onTitleTap,
      this.buttons});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // 안드로이드 백버튼 대용
      onWillPop: () async {
        if (onBack != null) {
          onBack!();
        }

        return isFirstPage;
      },
      child: Stack(
        children: [
          Scaffold(
            key: key,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? false,
            bottomNavigationBar: bottomNavigationBar,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (title != null ||
                          action != null ||
                          onBack != null ||
                          backItem != null)
                      ? Container(
                          color: appbarColor ?? backgroundColor ?? Colors.white,
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top),
                          child:
                              Stack(alignment: Alignment.centerLeft, children: [
                            (title == "" || title == "white")
                                ? Container(
                                    alignment: Alignment.center,
                                    height: 70,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (onTitleTap != null) {
                                          onTitleTap!();
                                        }
                                      },
                                      child: Container(
                                        width: 150,
                                        color: Colors.transparent,
                                        child: CustomIcon(
                                          path: title == "white"
                                              ? "photos/logo_white"
                                              : "photos/logo_green",
                                          type: ".png",
                                          height: 27,
                                          width: double.infinity,
                                          boxFit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: showAppbarUnderline
                                            ? Border(
                                                bottom:
                                                    BorderSide(color: gray300))
                                            : null),
                                    height: 70,
                                    child: Text(
                                      title ?? "",
                                      style: header02.copyWith(color: black),
                                    ),
                                  ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  (onBack != null || backItem != null)
                                      ? GestureDetector(
                                          onTap: onBack as void Function()?,
                                          child: (backItem == null)
                                              ? CustomIcon(
                                                  path: "icons/back",
                                                )
                                              : backItem,
                                        )
                                      : Container(
                                          width: 40,
                                          height: 40,
                                        ),
                                  action ??
                                      Container(
                                        width: 40,
                                        height: 40,
                                      )
                                ],
                              ),
                            )
                          ]),
                        )
                      : Container(),
                  Expanded(
                    child: Container(
                      color: backgroundColor ?? Colors.white,
                      child: body ?? Container(),
                    ),
                  ),
                  if (buttons != null)
                    Row(
                      children: [
                        ...buttons!
                            .map(
                              (e) => Expanded(
                                child: DefaultButton(
                                  title: e.title,
                                  showGif: e.showGif,
                                  onTap: e.onTap,
                                  color: e.color,
                                  description: e.description,
                                  icon: e.icon,
                                ),
                              ),
                            )
                            .toList()
                      ],
                    )
                ],
              ),
            ),
          ),
          if (onLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white.withOpacity(0),
                  valueColor: AlwaysStoppedAnimation<Color>(darkBlue),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class OverrapBaseScaffold extends StatelessWidget {
  final String? title;
  final Function? onBack;
  final Widget? backItem;
  final Widget? body;
  final bool onLoading;
  final Widget? action;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final Color? appbarColor;
  final bool centerTitle;
  final bool? resizeToAvoidBottomInset;
  final bool showAppbarUnderline;

  final List<BaseScaffoldDefaultButtonScheme>? buttons;

  OverrapBaseScaffold(
      {this.title,
      this.centerTitle = true,
      this.appbarColor,
      this.resizeToAvoidBottomInset,
      this.bottomNavigationBar,
      this.backgroundColor,
      this.onBack,
      this.backItem,
      this.body,
      this.onLoading = false,
      this.action,
      this.showAppbarUnderline = true,
      this.buttons});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // 안드로이드 백버튼 대용
      onWillPop: () async {
        if (onBack != null) {
          onBack!();
        }
        return false;
      },
      child: Stack(
        children: [
          Scaffold(
            key: key,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? false,
            bottomNavigationBar: bottomNavigationBar,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Stack(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        color: backgroundColor ?? Colors.white,
                        child: body ?? Container(),
                      ),
                    ),
                    if (buttons != null)
                      Row(
                        children: [
                          ...buttons!
                              .map(
                                (e) => Expanded(
                                  child: DefaultButton(
                                    title: e.title,
                                    onTap: e.onTap,
                                    color: e.color,
                                    description: e.description,
                                    icon: e.icon,
                                  ),
                                ),
                              )
                              .toList()
                        ],
                      )
                  ],
                ),
                (title != null ||
                        action != null ||
                        onBack != null ||
                        backItem != null)
                    ? Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top),
                        child:
                            Stack(alignment: Alignment.centerLeft, children: [
                          (title == "" || title == "white")
                              ? Container(
                                  alignment: Alignment.center,
                                  height: 70,
                                  child: Container(
                                    child: CustomIcon(
                                      path: title == "white"
                                          ? "photos/logo_white"
                                          : "photos/logo_green",
                                      type: ".png",
                                      height: 27,
                                      width: double.infinity,
                                      boxFit: BoxFit.fitHeight,
                                    ),
                                  ),
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: showAppbarUnderline
                                          ? Border(
                                              bottom:
                                                  BorderSide(color: gray300))
                                          : null),
                                  height: 70,
                                  child: Text(
                                    title ?? "",
                                    style: header02.copyWith(color: black),
                                  ),
                                ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (onBack != null || backItem != null)
                                    ? GestureDetector(
                                        onTap: onBack as void Function()?,
                                        child: (backItem == null)
                                            ? CustomIcon(
                                                path: "icons/back",
                                              )
                                            : backItem,
                                      )
                                    : Container(
                                        width: 40,
                                        height: 40,
                                      ),
                                action ??
                                    Container(
                                      width: 40,
                                      height: 40,
                                    )
                              ],
                            ),
                          )
                        ]),
                      )
                    : Container(),
              ]),
            ),
          ),
          if (onLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white.withOpacity(0),
                  valueColor: AlwaysStoppedAnimation<Color>(darkBlue),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
