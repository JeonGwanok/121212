import 'package:flutter/cupertino.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/common/illust.dart';
import 'package:oasis/ui/common/object_text_default_frame.dart';
import 'package:oasis/ui/sign/util/field_status.dart';

import '../../../theme.dart';

class SignUpPassword extends StatefulWidget {
  final String initialPasswordValue;
  final String initialRePasswordValue;
  final PasswordFieldStatus passwordStatus;
  final RepasswordFieldStatus rePasswordStatus;
  final Function(String) onPasswordChange;
  final Function(String) onRePasswordChange;

  SignUpPassword({
    required this.initialPasswordValue,
    required this.initialRePasswordValue,
    required this.passwordStatus,
    required this.rePasswordStatus,
    required this.onPasswordChange,
    required this.onRePasswordChange,
  });
  @override
  _SignUpPasswordState createState() => _SignUpPasswordState();
}

class _SignUpPasswordState extends State<SignUpPassword> {
  var showPw = false;
  var showRepw = false;

  @override
  Widget build(BuildContext context) {
    var pwGuide = "";
    var repwGuide = "";

    switch (widget.passwordStatus) {
      case PasswordFieldStatus.invalid:
        pwGuide = "영문+숫자+특수문자 포함 8자 이상 20글자 이하로 입력해주세요.";
        break;
      case PasswordFieldStatus.wrong:
        pwGuide = "비밀번호를 확인해주세요.";
        break;
      default:
        break;
    }

    switch (widget.rePasswordStatus) {
      case RepasswordFieldStatus.unMatched:
        repwGuide = "비밀번호가 일치하지 않습니다.";
        break;
      default:
        break;
    }

    return Column(children: [
      ObjectTextDefaultFrame(
        title: "* 비밀번호",
        body: DefaultField(
          hintText: "비밀번호를 입력해주세요.",
          textLimit: 20,
          initialValue: widget.initialPasswordValue,
          guideText: pwGuide,
          onError: !(widget.passwordStatus == PasswordFieldStatus.success ||
              widget.passwordStatus == PasswordFieldStatus.initial),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                showPw = !showPw;
              });
            },
            child: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              child: CustomIcon(
                path: showPw ? "icons/openEye" : "icons/closeEye",
              ),
            ),
          ),
          onHide: !showPw,
          onChange: widget.onPasswordChange,
        ),
      ),
      SizedBox(height: 16),
      ObjectTextDefaultFrame(
        title: "* 비밀번호 확인",
        body: DefaultField(
          hintText: "비밀번호를 한번 더 입력해주세요",
          guideText: repwGuide,
          textLimit: 20,
          initialValue: widget.initialRePasswordValue,
          onError: !(widget.rePasswordStatus == RepasswordFieldStatus.success ||
              widget.rePasswordStatus == RepasswordFieldStatus.initial),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                showRepw = !showRepw;
              });
            },
            child: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              child: CustomIcon(
                path: showRepw ? "icons/openEye" : "icons/closeEye",
              ),
            ),
          ),
          onHide: !showRepw,
          onChange: widget.onRePasswordChange,
        ),
      ),
      SizedBox(height: 16),
    ]);
  }
}
