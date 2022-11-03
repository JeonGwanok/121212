import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/common/object_text_default_frame.dart';
import 'package:oasis/ui/sign/util/field_status.dart';

import '../../../theme.dart';
import '../phone_certificate_screen.dart';

class SignUpPhone extends StatefulWidget {
  final String initialValue;
  final PhoneFieldStatus status;
  final Function(String) onChange;
  final Function(String) onVerify; // 중복 확인

  SignUpPhone({
    required this.initialValue,
    required this.onChange,
    required this.status,
    required this.onVerify,
  });
  @override
  _SignUpPhoneState createState() => _SignUpPhoneState();
}

class _SignUpPhoneState extends State<SignUpPhone> {
  @override
  Widget build(BuildContext context) {
    var guidMsg = "-없이 입력해주세요.";
    var onErr = false;

    switch (widget.status) {
      case PhoneFieldStatus.initial:
        guidMsg = "-없이 입력해주세요.";
        break;
      case PhoneFieldStatus.invalid:
        guidMsg = "올바른 전화번호 형식으로 써주세요.";
        onErr = true;
        break;
      case PhoneFieldStatus.alreadyInUse:
        guidMsg = "이미 사용중인 휴대폰입니다";
        onErr = true;
        break;
      default:
        break;
    }

    return ObjectTextDefaultFrame(
      title: "* 휴대폰 번호",
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: DefaultField(
            focus: FocusNode(),
            enable: widget.status != PhoneFieldStatus.success,
            onError: onErr,
            hintText: "전화번호를 입력해주세요.",
            guideText: guidMsg,
            initialValue: widget.initialValue,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            textLimit: 11,
            onChange: widget.onChange,
          )),
          Container(
            width: 92,
            margin: EdgeInsets.only(left: 12),
            child: DefaultSmallButton(
              onTap: widget.status == PhoneFieldStatus.valid
                  ? () async {
                      var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhoneCertificateScreen(
                            phoneNumber: widget.initialValue,
                          ),
                        ),
                      );

                      if (result != null) {
                      widget.onVerify(result);
                      }
                    }
                  : null,
              color: mainMint,
              title: widget.status == PhoneFieldStatus.success
                  ? "인증완료"
                  : widget.status != PhoneFieldStatus.alreadyInUse
                      ? "인증하기"
                      : "인증하기",
            ),
          )
        ],
      ),
    );
  }
}
