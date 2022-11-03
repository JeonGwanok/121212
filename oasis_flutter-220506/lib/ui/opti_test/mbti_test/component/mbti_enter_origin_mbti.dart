import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/common/showBottomSheet.dart';
import 'package:oasis/ui/theme.dart';

class MBTIEnterOriginMBTI extends StatefulWidget {
  final String initialValue;
  final Function(String) onEnter;

  MBTIEnterOriginMBTI({required this.initialValue, required this.onEnter});
  @override
  _MBTIEnterOriginMBTIState createState() => _MBTIEnterOriginMBTIState();
}

class _MBTIEnterOriginMBTIState extends State<MBTIEnterOriginMBTI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나의 MBTI',
            style: header03.copyWith(color: gray900),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              var items = [
                "ISTJ",
                "ISTP",
                "ISFJ",
                "ISFP",
                "INTJ",
                "INTP",
                "INFJ",
                "INFP",
                "ESTJ",
                "ESTP",
                "ESFJ",
                "ESFP",
                "ENTJ",
                "ENTP",
                "ENFJ",
                "ENFP",
              ];
              var mbti = await showBottomOptionSheet(
                context,
                title: "나의 MBTI",
                items: items,
                labels: items,
              );
              if (mbti != null) {
                widget.onEnter(mbti);
              }
            },
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: gray300),
              ),
              child: Text(
                widget.initialValue.isNotEmpty
                    ? widget.initialValue
                    : 'MBIT를 선택해주세요.',
                style: body01.copyWith(color: gray900),
              ),
            ),
          ),
          SizedBox(height: 19),
          Text(
            """
나의 MBTI를  알지 못할 경우 넘기셔도 됩니다.
※  회원가입 완료 후 '내 성향분석 결과'에서 입력할 수 있습니다.

기존에 알고 계신 MBTI를 입력하시면 연애 MBTI와 다른 부분에 대한
해설을 받아보실 수 있습니다.

ex) MBTI (ESTJ) - OPTI (ISTJ)

       당신은 연애를 할 때 연인에게 집중하려고 노력하고 있습니다.
       
       당신이 사랑을 할 때 자신이 선택한 사랑에 대해 확신을 갖고
       주관적으로 연인을 바라보고 있습니다.
          
          """,
            style: body01.copyWith(color: gray600),
          ),
        ],
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
