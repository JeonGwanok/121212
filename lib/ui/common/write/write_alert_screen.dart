import 'package:flutter/material.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/theme.dart';

class WriteAlertScreen extends StatefulWidget {
  @override
  _WriteAlertScreenState createState() => _WriteAlertScreenState();
}

class _WriteAlertScreenState extends State<WriteAlertScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
              top: 30,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).padding.bottom + 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '게시물 작성 시 주의해 주세요.',
                style: header05.copyWith(color: gray900),
              ),
              SizedBox(height: 16),
              Text(
                '''
정보통신망에서 불법 촬영물 등을 유통할 경우 「전기통신사업법」
재22조의 5 제1항에 따른 삭제 · 접속 차단 등 유통 방지에 필요한
조치가 취해지며 「성폭력 처벌법」 제14조 「청소년 성 보호법」
제11조에 따라 형사처분을 받을 수 있습니다.

타인 비방, 욕설 혹은 개인을 특정하여 언급하는 행위는 삼가주세요.
기준을 위반한 게시물을 작성할 경우 제재될 수 있습니다.
      ''',
                style: body01.copyWith(color: gray900),
              ),
              DefaultSmallButton(
                title: "확인",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
