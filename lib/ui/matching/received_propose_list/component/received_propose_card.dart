import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oasis/model/matching/propose.dart';
import 'package:oasis/ui/common/info_field.dart';
import 'package:oasis/ui/theme.dart';
import 'package:oasis/ui/util/bold_generator.dart';

class ProposeCard extends StatefulWidget {
  final Propose propose;
  final Function openPropose;
  ProposeCard({
    required this.propose,
    required this.openPropose,
  });
  @override
  _ProposeCardState createState() => _ProposeCardState();
}

class _ProposeCardState extends State<ProposeCard> {
  @override
  Widget build(BuildContext context) {
    Color buttonColor = gray300;
    String buttonTitle = "";
    Function onTap = () {
      widget.openPropose();
    };

    switch (widget.propose.status) {
      case ProposeStatus.intial:
        buttonColor = mainMint;
        buttonTitle = "미확인";
        break;
      case ProposeStatus.accept:
        buttonColor = gray300;
        buttonTitle = "수락됨";

        break;
      case ProposeStatus.autoRejected:
        buttonColor = gray300;
        buttonTitle = "자동 거절됨";

        break;
      case ProposeStatus.endLove:
        buttonColor = gray300;
        buttonTitle = "연애 종료";

        break;
      case ProposeStatus.processLove:
        buttonColor = gray300;
        buttonTitle = "연애중";

        break;
      case ProposeStatus.afterMeeting:
        buttonColor = gray300;
        buttonTitle = "만남 후기 대기";

        break;
      case ProposeStatus.waitMeeting:
        buttonColor = gray300;
        buttonTitle = "만남 대기";

        break;
      case ProposeStatus.endMeeting:
        buttonColor = gray300;
        buttonTitle = "연애 종료";
        break;
      case ProposeStatus.processMeetingSchedule:
        buttonColor = gray300;
        buttonTitle = "만남 일정 선택중";
        break;
      case ProposeStatus.opened:
        buttonColor = mainMint;
        buttonTitle = "확인";
        break;
      case ProposeStatus.rejected:
        buttonColor = gray300;
        buttonTitle = "거절";
        break;
      case ProposeStatus.cancelMeeting:
        buttonColor = gray300;
        buttonTitle = "만남 취소";
        break;
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: cardShadow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              widget.openPropose();
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BoldMsgGenerator.toRichText(
                      msg:
                          "*요청일시 : * ${widget.propose.createdAt != null ? DateFormat("yyyy-MM-dd HH:mm:ss").format(widget.propose.createdAt!) : "--"}",
                      style: body01.copyWith(color: gray600),
                      boldWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: InfoField(
                              title: "연애 MBTI",
                              titleWidth: 90,
                              value:
                                  widget.propose.fromCustomer?.customer?.mbti ??
                                      "--"),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: InfoField(
                              title: "사랑의 삼각형",
                              titleWidth: 90,
                              value: widget.propose.fromCustomer?.customer
                                      ?.loveType ??
                                  "--"),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    _matchingRate(widget.propose.matchingRate ?? 0)
                  ]),
            ),
          ),
          GestureDetector(
            onTap: () {
              onTap();
            },
            child: Container(
              width: double.infinity,
              height: 52,
              alignment: Alignment.center,
              color: buttonColor,
              child: Text(
                buttonTitle,
                style: header05.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _matchingRate(int matchingRate) {
    return Container(
      margin: EdgeInsets.only(left: 11, right: 11),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '매칭률',
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
            style: header06.copyWith(color: gray600),
          )
        ],
      ),
    );
  }
}
