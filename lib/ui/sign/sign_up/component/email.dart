import 'package:flutter/cupertino.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/common/object_text_default_frame.dart';
import 'package:oasis/ui/sign/util/field_status.dart';

import '../../../theme.dart';

class SignUpEmail extends StatefulWidget {
  final String initialValue;
  final EmailFieldStatus status;
  final Function onVerify;
  final Function(String) onChange;

  SignUpEmail({
    required this.initialValue,
    required this.status,
    required this.onVerify,
    required this.onChange,
  });
  @override
  _SignUpEmailState createState() => _SignUpEmailState();
}

class _SignUpEmailState extends State<SignUpEmail> {
  @override
  Widget build(BuildContext context) {
    var guidMsg = "";
    bool onError = false;
    if (widget.status == EmailFieldStatus.invalid) {
      guidMsg = "올바른 형식의 이메일을 입력해주세요.";
      onError = true;
    }

    if (widget.status == EmailFieldStatus.success) {
      guidMsg = "사용 가능한 이메일입니다.";
    }

    if (widget.status == EmailFieldStatus.alreadyInUse) {
      guidMsg = "사용중인 이메일입니다.";
      onError = true;
    }

    return ObjectTextDefaultFrame(
      title: "* 이메일 주소",
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: DefaultField(
              focus: FocusNode(),
              initialValue: widget.initialValue,
              hintText: "이메일 주소를 입력해주세요.",
              guideText: guidMsg,
              onError: onError,
              onChange: widget.onChange,
            ),
          ),
          Container(
            width: 92,
            margin: EdgeInsets.only(left: 12),
            child: DefaultSmallButton(
              onTap: widget.status == EmailFieldStatus.valid
                  ? widget.onVerify
                  : null,
              color: mainMint,
              title: "중복확인",
            ),
          )
        ],
      ),
    );
  }
}
