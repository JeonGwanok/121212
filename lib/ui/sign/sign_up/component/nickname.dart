import 'package:flutter/material.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/common/object_text_default_frame.dart';
import 'package:oasis/ui/sign/util/field_status.dart';

import '../../../theme.dart';

class SignUpNickname extends StatefulWidget {
  final String initialValue;
  final Function(String) onChange;
  final NickNameFieldStatus status;
  final Function() onVerify;

  SignUpNickname({
    required this.initialValue,
    required this.onChange,
    required this.onVerify,
    required this.status,
  });
  @override
  _SignUpNicknameState createState() => _SignUpNicknameState();
}

class _SignUpNicknameState extends State<SignUpNickname> {
  var text = "";

  @override
  void initState() {
    text = "${widget.initialValue}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var guidMsg = "";
    bool onError = false;
    if (widget.status == NickNameFieldStatus.initial) {
      guidMsg = "2글자 이상 10글자 이하 한글, 영문, 숫자 혼용가능\n(특수문자, 띄어쓰기, 숫자로만 구성 불가)";
    }

    if (widget.status == NickNameFieldStatus.invalid) {
      guidMsg = "2글자 이상 10글자 이하 한글, 영문, 숫자 혼용가능\n(특수문자, 띄어쓰기, 숫자로만 구성 불가)";
      onError = true;
    }

    if (widget.status == NickNameFieldStatus.success) {
      guidMsg = "사용 가능한 닉네임입니다.";
    }

    if (widget.status == NickNameFieldStatus.alreadyUse) {
      guidMsg = "사용중인 닉네임입니다.";
      onError = true;
    }

    if (widget.status == NickNameFieldStatus.hasSlang) {
      guidMsg = "비속어를 제외해주세요.";
      onError = true;
    }

    return ObjectTextDefaultFrame(
      title: "* 별명(닉네임)",
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DefaultField(
                  initialValue: widget.initialValue,
                  hintText: "닉네임을 입력해주세요.",
                  onError: onError,
                  textLimit: 10,
                  onChange: (text) {
                    setState(() {
                      this.text = text;
                    });
                    widget.onChange(text);
                  }),
            ),
            Container(
              width: 92,
              margin: EdgeInsets.only(left: 12),
              child: DefaultSmallButton(
                onTap: widget.status == NickNameFieldStatus.valid
                    ? widget.onVerify
                    : null,
                color: mainMint,
                title: "중복확인",
              ),
            )
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            guidMsg,
            style: caption01.copyWith(
                height: 1.5, color: onError ? Colors.red : gray400),
          ),
        ),
      ]),
    );
  }
}
