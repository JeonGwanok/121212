import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/theme.dart';

class BusinessInfoScreen extends StatelessWidget {
  const BusinessInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "사업자 정보",
      onBack: () {
        Navigator.pop(context);
      },
      buttons: [
        BaseScaffoldDefaultButtonScheme(
          title: "닫기",
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(16),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: cardShadow,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: backgroundColor)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _tile(title: "엔아이소프트", value: ""),
              _tile(title: "대표이사", value: "김낙일"),
              _tile(title: "사업자등록번호", value: "208-22-96117"),
              _tile(title: "주소", value: "서울특별시 용산구 새창로45길 19,2층"),
              _tile(title: "통신판매업신고번호", value: "제 2022-서울용산-0157 호"),
              _tile(title: "문의전화", value: "1544-2857"),
              _tile(title: "이메일", value: "help@nisoft.kr"),
          _tile(title: "국내결혼중개업 신고번호", value: "제 서울-용산-국내-22-0001 호"),
            ],
          ),
        ),
      ),
    );
  }

  _tile({
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 125,
            child: Text(
              title,
              style: header03.copyWith(color: gray600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: body01.copyWith(color: gray600),
            ),
          ),
        ],
      ),
    );
  }
}
