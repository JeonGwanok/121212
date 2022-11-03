import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/repository/auth_repository.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/snack_bar.dart';
import 'package:oasis/ui/sign/sign_up/component/email.dart';
import 'package:oasis/ui/sign/sign_up/component/nickname.dart';
import 'package:oasis/ui/sign/sign_up/component/password.dart';
import 'package:oasis/ui/sign/sign_up/component/phone.dart';
import 'package:oasis/ui/sign/sign_up/component/recommnedId.dart';
import 'package:oasis/ui/sign/sign_up/component/terms/terms.dart';
import 'package:oasis/ui/sign/sign_up/cubit/sign_up_cubit.dart';
import 'package:oasis/ui/sign/util/field_status.dart';
import 'package:oasis/ui/sign/util/sign_status.dart';
import 'package:oasis/ui/theme.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SignUpCubit(
          commonRepository: context.read<CommonRepository>(),
          authRepository: context.read<AuthRepository>())
        ..initialize(),
      child: BlocListener<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state.status == SignStatus.success) {
            Navigator.pop(context);
          }

          if (state.emailStatus == EmailFieldStatus.alreadyInUse) {
            ScaffoldMessenger.of(context).showSnackBar(
              snackBar(context, "이미 등록된 이메일 주소입니다."),
            );
          }

          if (state.status == SignStatus.disableBirth) {
            DefaultDialog.show(context, title: "미성년자는 가입할 수 없습니다.",defaultButtonTitle: "확인");
          }
        },
        listenWhen: (pre, cur) =>
            pre.status != cur.status || pre.emailStatus != cur.emailStatus,
        child: BlocBuilder<SignUpCubit, SignUpState>(
          builder: (context, state) {
            return BaseScaffold(
              resizeToAvoidBottomInset: true,
              title: state.page == 0 ? "이용약관" : "회원가입",
              onBack: () async {
                if (state.page == 0) {
                  var popResult = await DefaultDialog.show(
                    context,
                    title: "그만하시겠어요?",
                    description: "이전 내용들은 그대로 저장됩니다.", // TODO: ?? 이거 어떤의미?
                    onTap: () {},
                  );

                  if (popResult) {
                    Navigator.pop(context);
                  }
                } else {
                  context.read<SignUpCubit>().prev();
                }
              },
              buttons: [
                BaseScaffoldDefaultButtonScheme(
                  title: state.isLast ? "완료" : "다음",
                  onTap: state.enableButton
                      ? () {
                          if (state.isLast) {
                            context.read<SignUpCubit>().signUp();
                          } else {
                            context.read<SignUpCubit>().next();
                          }
                        }
                      : null,
                ),
              ],
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      if (state.page != 0) _message(),
                      if (state.page == 0)
                        SignUpTerms(
                          initialTerms: state.selectedTerms,
                          terms: state.terms,
                          onChange: (items) {
                            context.read<SignUpCubit>().changeTerms(items);
                          },
                        ),
                      if (state.page == 1)
                        SignUpPhone(
                          initialValue: state.phoneN,
                          status: state.phoneStatus,
                          onChange: (phoneN) {
                            context.read<SignUpCubit>().changePhoneN(phoneN);
                          },
                          onVerify: (impUid) {
                            context.read<SignUpCubit>().verifyPhoneN(impUid);
                          },
                        ),
                      if (state.page == 2)
                        SignUpEmail(
                          initialValue: state.email,
                          status: state.emailStatus,
                          onVerify: () {
                            context.read<SignUpCubit>().verifyEmail();
                          },
                          onChange: (email) {
                            context.read<SignUpCubit>().changeEmail(email);
                          },
                        ),
                      if (state.page == 3)
                        SignUpNickname(
                          initialValue: state.nickName,
                          status: state.nickNameStatus,
                          onChange: (nickname) {
                            context
                                .read<SignUpCubit>()
                                .changeNickName(nickname);
                          },
                          onVerify: () {
                            context.read<SignUpCubit>().checkNickName();
                          },
                        ),
                      if (state.page == 4)
                        SignUpPassword(
                          initialPasswordValue: state.password,
                          initialRePasswordValue: state.rePassword,
                          passwordStatus: state.passwordStatus,
                          rePasswordStatus: state.repwStatus,
                          onPasswordChange: (password) {
                            context
                                .read<SignUpCubit>()
                                .changePassword(password);
                          },
                          onRePasswordChange: (password) {
                            context
                                .read<SignUpCubit>()
                                .changeRepassword(password);
                          },
                        ),
                      if (state.page == 5)
                        SignUpRecommendId(
                          initialValue: state.recommendId,
                          onChange: (recommendId) {
                            context
                                .read<SignUpCubit>()
                                .changeRecommendId(recommendId);
                          },
                        ),
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

  _message() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 52),
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '* 표시는 필수입력 사항입니다.',
        style: body01.copyWith(color: gray700),
      ),
    );
  }
}
