import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/auth_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/common/snack_bar.dart';
import 'package:oasis/ui/sign/util/field_status.dart';

import 'cubit/password_reset_cubit.dart';

class PasswordResetScreen extends StatefulWidget {
  final String username;
  PasswordResetScreen({required this.username});
  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  var showPw = false;
  var showRepw = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => PasswordResetCubit(
          authRepository: context.read<AuthRepository>(),
          username: widget.username),
      child: BlocListener<PasswordResetCubit, PasswordResetState>(
        listener: (context, state) async {
          if (state.status == ScreenStatus.success) {
            await DefaultDialog.show(context,
                title: "성공적으로 설정되었습니다.", defaultButtonTitle: "확인");
            Navigator.pop(context);
            Navigator.pop(context);
          }

        },
        listenWhen: (pre, cur) => pre.status != cur.status,
        child: BlocBuilder<PasswordResetCubit, PasswordResetState>(
          builder: (context, state) {
            var ratio = MediaQuery.of(context).size.height / 896;

            var pwGuide = "";
            var repwGuide = "";

            switch (state.passwordStatus) {
              case PasswordFieldStatus.invalid:
                pwGuide = "영문+숫자+특수문자 포함 8자 이상 20글자 이하로 입력해주세요.";
                break;
              case PasswordFieldStatus.wrong:
                pwGuide = "비밀번호를 확인해주세요.";
                break;
              default:
                break;
            }

            switch (state.repwStatus) {
              case RepasswordFieldStatus.unMatched:
                repwGuide = "비밀번호가 일치하지 않습니다.";
                break;
              default:
                break;
            }

            return BaseScaffold(
              title: "비밀번호 재설정",
              resizeToAvoidBottomInset: true,
              onBack: () {
                Navigator.pop(context);
              },
              onLoading: state.status == ScreenStatus.loading,
              buttons: [
                BaseScaffoldDefaultButtonScheme(
                  title: "비밀번호 재설정",
                  onTap: state.enableButton
                      ? () {
                          context.read<PasswordResetCubit>().resetPassword();
                        }
                      : null,
                )
              ],
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Container(
                        height: 77 * ratio,
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top),
                        padding: EdgeInsets.only(
                          left: 38,
                          right: 38,
                        ),
                        alignment: Alignment.center,
                        child: CustomIcon(
                          width: double.infinity,
                          height: double.infinity,
                          path: "photos/logo_green",
                          type: ".png",
                        ),
                      ),
                      SizedBox(height: 66),
                      Column(children: [
                        DefaultField(
                          hintText: "새로운 비밀번호를 입력해주세요.",
                          textLimit: 20,
                          initialValue: state.password,
                          guideText: pwGuide,
                          onError: !(state.passwordStatus ==
                                  PasswordFieldStatus.success ||
                              state.passwordStatus ==
                                  PasswordFieldStatus.initial),
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
                                path:
                                    showPw ? "icons/openEye" : "icons/closeEye",
                              ),
                            ),
                          ),
                          onHide: !showPw,
                          onChange: (text) {
                            context
                                .read<PasswordResetCubit>()
                                .changePassword(text);
                          },
                        ),
                        SizedBox(height: 16),
                        DefaultField(
                          hintText: "비밀번호를 한번 더 입력해주세요",
                          guideText: repwGuide,
                          textLimit: 20,
                          initialValue: state.rePassword,
                          onError: !(state.repwStatus ==
                                  RepasswordFieldStatus.success ||
                              state.repwStatus ==
                                  RepasswordFieldStatus.initial),
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
                                path: showRepw
                                    ? "icons/openEye"
                                    : "icons/closeEye",
                              ),
                            ),
                          ),
                          onHide: !showRepw,
                          onChange: (text) {
                            context
                                .read<PasswordResetCubit>()
                                .changeRepassword(text);
                          },
                        ),
                        SizedBox(height: 16),
                      ])
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
