import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oasis/model/matching/ai_matching.dart';
import 'package:oasis/ui/common/info_field.dart';
import 'package:oasis/ui/theme.dart';

class AiMatchingCard extends StatefulWidget {
  final AiMatching? aiMatching;
  AiMatchingCard({
    this.aiMatching,
  });
  @override
  _AiMatchingCardState createState() => _AiMatchingCardState();
}

class _AiMatchingCardState extends State<AiMatchingCard> {
  @override
  Widget build(BuildContext context) {
    return widget.aiMatching == AiMatching.empty
        ? DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(8),
            dashPattern: [3, 5],
            color: gray300,
            strokeWidth: 2,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 310,
                  padding: EdgeInsets.only(bottom: 30),
                  child: Center(
                    child: Text(
                      "Searching",
                      style: body05.copyWith(color: gray300),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 45),
                  child: Column(
                    children: [
                      ...List.generate(
                          3,
                          (index) => Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: gray300
                                      .withOpacity(1 - ((index + 1) / 4)),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                margin: EdgeInsets.symmetric(vertical: 4),
                              )).toList(),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            height: 310,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: cardShadow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '이분과의 성향은',
                    style: header05.copyWith(color: gray600),
                  ),
                  SizedBox(height: 29),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InfoField(
                            title: "MBTI",
                            value: widget.aiMatching?.mbti ?? "--"),
                        InfoField(
                            title: "사랑의함각형",
                            value: widget.aiMatching?.temper ?? "--"),
                        InfoField(
                            title: "혼인",
                            value: widget.aiMatching?.myMarriage ?? "--"),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  _matchingRate(widget.aiMatching?.matchingRate ?? 0)
                ],
              ),
            ),
          );
  }

  _matchingRate(int matchingRate) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '적합도',
          style: header05.copyWith(color: gray600),
        ),
        Container(
          height: 2,
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: gray200,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            children: [
              Expanded(
                  flex: matchingRate,
                  child: Container(
                    color: mainMint,
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
          style: header06.copyWith(color: gray900),
        )
      ],
    );
  }
}
