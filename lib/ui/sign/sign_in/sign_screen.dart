import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/repository/auth_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/common/snack_bar.dart';
import 'package:oasis/ui/sign/password_reset/password_reset_phone/password_reset_phone_screen.dart';
import 'package:oasis/ui/sign/sign_in/enum/sign_in_option.dart';
import 'package:oasis/ui/sign/sign_up/sign_up_screen.dart';
import 'package:oasis/ui/sign/util/field_status.dart';
import 'package:oasis/ui/sign/util/sign_status.dart';
import 'package:oasis/ui/theme.dart';

import 'cubit/sign_in_cubit.dart';

class SignScreen extends StatefulWidget {
  @override
  _SignScreenState createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  bool showPw = true;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          SignInCubit(authRepository: context.read<AuthRepository>())
            ..initialize(),
      child: BlocListener<SignInCubit, SignInState>(
        listener: (context, state) {
          if (state.passwordStatus == PasswordFieldStatus.wrong) {
            ScaffoldMessenger.of(context).showSnackBar(
              snackBar(context, "비밀번호가 올바르지 않습니다."),
            );
          }

          if (state.phoneStatus == PhoneFieldStatus.userNotFound) {
            ScaffoldMessenger.of(context).showSnackBar(
              snackBar(context, "등록되지 않은 휴대폰번호 입니다."),
            );
          }
        },
        listenWhen: (pre, cur) =>
            (pre.phoneStatus != cur.phoneStatus ||
                pre.passwordStatus != cur.passwordStatus) &&
            pre.updatedAt != cur.updatedAt,
        child: BlocBuilder<SignInCubit, SignInState>(
          builder: (context, state) {
            var ratio = MediaQuery.of(context).size.height / 896;

            var phoneGuide = "";
            var passwordGuide = "";

            switch (state.phoneStatus) {
              case PhoneFieldStatus.initial:
                phoneGuide = "-없이 입력해주세요.";
                break;
              case PhoneFieldStatus.invalid:
                phoneGuide = "올바른 전화번호 형식으로 써주세요.";
                break;
              case PhoneFieldStatus.userNotFound:
                phoneGuide = "가입되지 않은 전화번호입니다.";
                break;
              default:
                break;
            }

            switch (state.passwordStatus) {
              case PasswordFieldStatus.initial:
                passwordGuide = "영문+숫자+특수문자 포함 8자 이상 20글자 이하로 입력해주세요.";
                break;
              case PasswordFieldStatus.invalid:
                passwordGuide = "영문+숫자+특수문자 포함 8자 이상 20글자 이하로 입력해주세요.";
                // r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$%&*~]).{8,16}$')
                break;
              case PasswordFieldStatus.wrong:
                passwordGuide = "비밀번호를 확인해주세요.";
                break;
              default:
                break;
            }

            return BaseScaffold(
              onLoading: state.status == SignStatus.loading,
              isFirstPage: true,
              buttons: [
                BaseScaffoldDefaultButtonScheme(
                  title: "로그인",
                  onTap: state.enabledButton
                      ? () {
                          FocusScope.of(context).unfocus();
                          context.read<SignInCubit>().login();
                        }
                      : null,
                ),
              ],
              body: state.status == SignStatus.initial
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).padding.top),
                              padding: EdgeInsets.only(
                                left: 38,
                                right: 38,
                                top: 50 * ratio,
                              ),
                              alignment: Alignment.center,
                              child: CustomIcon(
                                width: double.infinity,
                                height: double.infinity,
                                path: "photos/logo_green",
                                type: ".png",
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 33 * ratio),
                                child: Column(
                                  children: [
                                    DefaultField(
                                      prefixIcon:
                                          CustomIcon(path: "icons/phone"),
                                      onError: !state.validEmail,
                                      keyboardType: TextInputType.number,
                                      textLimit: 11,
                                      initialValue: state.phoneN,
                                      hintText: "전화번호를 입력해주세요.",
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      guideText: phoneGuide,
                                      onChange: (phoneN) {
                                        context
                                            .read<SignInCubit>()
                                            .changePhoneN(phoneN);
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    DefaultField(
                                      prefixIcon: CustomIcon(
                                        path: "icons/lock",
                                      ),
                                      onHide: showPw,
                                      keyboardType: TextInputType.text,
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
                                            path: showPw
                                                ? "icons/openEye"
                                                : "icons/closeEye",
                                          ),
                                        ),
                                      ),
                                      onError: !state.validPassword,
                                      guideText: passwordGuide,
                                      hintText: "비밀번호를 입력해주세요.",
                                      onChange: (password) {
                                        context
                                            .read<SignInCubit>()
                                            .changePassword(password);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 81 * ratio),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _checkButton(
                                      enable: state.signInOptions
                                          .contains(SignInOption.autoLogin),
                                      title: '자동로그인',
                                      onTap: () {
                                        context
                                            .read<SignInCubit>()
                                            .changeOption(
                                                SignInOption.autoLogin);
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    _checkButton(
                                      enable: state.signInOptions
                                          .contains(SignInOption.saveId),
                                      title: '아이디 저장',
                                      onTap: () {
                                        context
                                            .read<SignInCubit>()
                                            .changeOption(SignInOption.saveId);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 52 * ratio),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _textButton(
                                      title: '회원가입',
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SignUpScreen(),
                                            ));
                                      },
                                    ),
                                    _textButton(
                                      title: '비밀번호 찾기',
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PasswordResetPhoneScreen(),
                                            ));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 20 * ratio),
                                child: Column(
                                  children: [
                                    Text(
                                      '문의전화 : 1544-2857',
                                      style: caption02.copyWith(color: gray400),
                                    ),
                                    Text(
                                      '문의 메일 : help@nisoft.kr',
                                      style: caption02.copyWith(color: gray400),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  _checkButton({
    required bool enable,
    required String title,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CustomIcon(
            path: enable ? "icons/check" : "icons/uncheck",
            width: 20,
            height: 20,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white.withOpacity(0),
            height: 40,
            alignment: Alignment.center,
            child: Text(
              title,
              style: body02.copyWith(color: gray400),
            ),
          ),
        ],
      ),
    );
  }

  _textButton({required String title, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white.withOpacity(0),
        height: 40,
        width: 100,
        alignment: Alignment.center,
        child: Text(
          title,
          style: body02.copyWith(color: gray400),
        ),
      ),
    );
  }
}
