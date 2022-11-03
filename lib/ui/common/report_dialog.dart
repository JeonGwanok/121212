import 'package:flutter/material.dart';
import 'package:oasis/ui/theme.dart';

var reportList = [
  "욕설 및 비방",
  "개인 신상정보 노출",
  "광고 및 도배",
  "부적절한 사진",
  "다른 이를 사칭",
  "불법 촬영물",
  "허위 영상물",
  "아동 및 청소년 성착취물",
];

class ReportDialog extends StatefulWidget {
  final Function(String) onSuccess;

  ReportDialog({
    required this.onSuccess,
  });

  static Future<bool> show(
    BuildContext context, {
    required Function(String) onSuccess,
  }) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ReportDialog(
            onSuccess: onSuccess,
          );
        });
  }

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  ScrollController controller = ScrollController();

  String value = "";
  String etcValue = "";
  @override
  Widget build(BuildContext context) {

    var ratio = MediaQuery.of(context).size.height / 896;
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(
        width: 0,
        style: BorderStyle.none,
      ),
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
          controller: controller,
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
                  padding: EdgeInsets.symmetric(vertical: 20 * ratio, horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(height: 10 * ratio),
                      Text(
                        "신고하기",
                        textAlign: TextAlign.center,
                        style: header02,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          "어떤 문제가 있나요?",
                          textAlign: TextAlign.center,
                          style: body01.copyWith(color: gray600),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.only(bottom: 15 * ratio),
                  color: gray100,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ...reportList
                          .map(
                            (e) => GestureDetector(
                              onTap: () {
                                if (value == e) {
                                  setState(() {
                                    value = "";
                                  });
                                } else {
                                  setState(() {
                                    value = e;
                                  });
                                }
                              },
                              child: Container(
                                height: 43,width: double.infinity,color: Colors.transparent,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  e,
                                  style: body06.copyWith(
                                      color: e == value ? mainMint : gray400),
                                ),
                              ),
                            ),
                          )
                          .toList()
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: gray50,
                      border: Border(
                          bottom: BorderSide(color: gray200),
                          top: BorderSide(color: gray200))),
                  padding: EdgeInsets.symmetric(vertical: 5 * ratio),
                  child: TextFormField(
                    style: body01.copyWith(color: gray900),
                    onTap: () {
                      Future.delayed(Duration(milliseconds: 300), () {
                        controller.animateTo(
                            controller.position.maxScrollExtent,
                            duration: Duration(milliseconds: 100),
                            curve: Curves.easeIn);
                      });
                    },
                    onChanged: (text) {
                      setState(() {
                        etcValue = text;
                      });
                    },
                    cursorColor: darkBlue,
                    decoration: InputDecoration(
                        hintText: "기타사유",
                        hintStyle: body01.copyWith(color: gray400),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        focusedBorder: border,
                        border: border),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15 * ratio),
                  child: Text(
                    '신고 처리를 위해 필요한 경우\n회원님의 활동 내역을 조회할 수 있습니다.',
                    style: body01.copyWith(color: gray400),
                    textAlign: TextAlign.center,
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
                        child: GestureDetector(
                          onTap: value.isEmpty && etcValue.isEmpty
                              ? null
                              : () {
                                  Navigator.pop(context);
                                  widget.onSuccess("$value $etcValue");
                                },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0),
                            ),
                            child: Text(
                              '신고전송',
                              style: header02.copyWith(
                                  color: value.isEmpty && etcValue.isEmpty
                                      ? gray300
                                      : darkBlue),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
