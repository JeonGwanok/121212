import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oasis/enum/profile/job_type.dart';
import 'package:oasis/enum/profile/marriage_type.dart';
import 'package:oasis/model/matching/matchings.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/info_field.dart';
import 'package:oasis/ui/theme.dart';

import '../../../purchase/purchase_screen.dart';

class MatchingCard extends StatefulWidget {
  final Function onGoldTap;
  final Matching? matching;
  final Function onTap;
  final bool isLocked;
  MatchingCard({
    required this.onGoldTap,
    required this.onTap,
    this.matching,
    this.isLocked = false,
  });
  @override
  _MatchingCardState createState() => _MatchingCardState();
}

class _MatchingCardState extends State<MatchingCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Tween<double> _ratioTween;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..addListener(() {
        {
          setState(() {
            ratio = _ratioTween.transform(_controller.value);
          });
        }
      });
  }

  var oldRatio = 0.0; // drag 시작할때 기존 ratio 저장.
  var ratio = 0.4;
  var dragDelta = 0.0; // drag 의 변화량

  var contextHeight = 0.0; // 바텀바를 제외한 화면의 높이
  var bottomSheetLimit = 0.0;

  @override
  Widget build(BuildContext context) {
    String? cardTitle;

    if (widget.matching?.autoReject ?? false) {
      cardTitle = "자동 거절";
    } else if (widget.matching?.proposeStatus != null &&
        !(widget.matching?.proposeStatus)!) {
      cardTitle = "PASS";
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: cardShadow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.isLocked ? yellow : Colors.transparent,
        ),
      ),
      height: 220,
      child: widget.isLocked
          ? GestureDetector(
              onTap: () {
                widget.onGoldTap();
              },
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: CustomIcon(
                        path: "icons/gold_price",
                        type: ".png",
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '골드 회원 이상만 카드를\n오픈하실 수 있습니다.',
                      textAlign: TextAlign.center,
                      style: caption02.copyWith(
                        color: gray600,
                      ),
                    )
                  ],
                ),
              ),
            )
          : Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InfoField(
                          title: "MBTI",
                          titleWidth: 60,
                          valuePadding: 8,
                          value:
                              widget.matching?.fromCustomer?.customer?.mbti ??
                                  "--"),
                      InfoField(
                          title: "사랑의삼각형",
                          titleWidth: 60,
                          valuePadding: 8,
                          value: widget
                                  .matching?.fromCustomer?.customer?.loveType ??
                              "--"),
                      InfoField(
                          title: "직업",
                          titleWidth: 60,
                          valuePadding: 8,
                          value: widget
                                      .matching?.fromCustomer?.profile?.myJob !=
                                  null
                              ? (widget.matching?.fromCustomer?.profile?.myJob
                                      as JobType)
                                  .title
                              : "--"),
                      InfoField(
                          title: "혼인",
                          titleWidth: 60,
                          valuePadding: 8,
                          value:
                              widget.matching?.fromCustomer?.profile?.myJob !=
                                      null
                                  ? (widget.matching?.fromCustomer?.profile
                                          ?.myMarriage as MarriageType)
                                      .title
                                  : "--"),
                    ],
                  ),
                ),
                Positioned(
                  top: ratio,
                  child: GestureDetector(
                    onVerticalDragStart: (detail) {
                      dragDelta = 0;
                      oldRatio = ratio * 1.0;
                    },
                    onVerticalDragUpdate: (detail) {
                      dragDelta = dragDelta + detail.delta.dy;
                      setState(() {
                        ratio = max(
                          0,
                          min(
                            150,
                            oldRatio + dragDelta,
                          ),
                        );
                      });
                    },
                    onVerticalDragEnd: (detail) {
                      var animationStartRatio = ratio * 1.0;
                      if (ratio > 120) {
                        ratio = 220;
                        Future.delayed(Duration(milliseconds: 200), () {
                          widget.onTap();
                          _ratioTween =
                              Tween<double>(begin: animationStartRatio, end: 0);
                          _controller.value = 0.0;
                          _controller.animateTo(
                            1.0,
                            curve: Curves.fastOutSlowIn,
                            duration: const Duration(milliseconds: 200),
                          );
                        });
                      } else {
                        ratio = 0;
                      }

                      _ratioTween =
                          Tween<double>(begin: animationStartRatio, end: ratio);
                      _controller.value = 0.0;
                      _controller.animateTo(
                        1.0,
                        curve: Curves.fastOutSlowIn,
                        duration: const Duration(milliseconds: 200),
                      );
                    },
                    child: Container(
                      height: 220,
                      width:
                          ((MediaQuery.of(context).size.width - 32) - 20) / 2,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: gray200,
                              borderRadius: BorderRadius.circular(8),
                              image: (widget.matching?.fromCustomer?.image
                                          ?.representative1 ==
                                      null)
                                  ? null
                                  : DecorationImage(
                                      image: Image.network(
                                        widget.matching?.fromCustomer?.image
                                                ?.representative1 ??
                                            "",
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (_, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            alignment: Alignment.center,
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                backgroundColor: gray300,
                                                strokeWidth: 3,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder: (_, __, ___) {
                                          return Container();
                                        },
                                      ).image,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                color: Colors.white.withOpacity(0.05),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding:
                                                  EdgeInsets.only(left: 12),
                                              child: Text(
                                                widget.matching?.createdAt !=
                                                        null
                                                    ? DateFormat(
                                                            "yyyy년 MM월 dd일")
                                                        .format(widget.matching!
                                                            .createdAt!)
                                                    : "",
                                                style: header03.copyWith(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.topRight,
                                              child: CustomIcon(
                                                path: "icons/double_arrow",
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        cardTitle == null
                                            ? Container()
                                            : Expanded(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 3,
                                                            horizontal: 16),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      cardTitle,
                                                      style: header06.copyWith(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                _matchingRate(
                                    widget.matching?.matchingRate ?? 0)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  _matchingRate(int matchingRate) {
    return Container(
      margin: EdgeInsets.only(left: 11, right: 11, bottom: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '매칭률',
            style: header05.copyWith(color: Colors.white),
          ),
          Container(
            height: 2,
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: gray100,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                Expanded(
                    flex: matchingRate,
                    child: Container(
                      color: Colors.white,
                    )),
                Expanded(
                  flex: 100 - matchingRate,
                  child: Container(),
                ),
              ],
            ),
          ),
          Text(
            "$matchingRate%",
            style: header06.copyWith(color: Colors.white),
          )
        ],
      ),
    );
  }
}
