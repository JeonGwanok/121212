import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/authentication/authentication_bloc.dart';
import 'package:oasis/bloc/authentication/authentication_event.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/my_page/remove_account/cubit/remove_account_cubit.dart';
import 'package:oasis/ui/sign/util/field_status.dart';
import 'package:oasis/ui/theme.dart';

import '../../common/showBottomSheet.dart';
import 'cubit/remove_account_state.dart';

class RemoveAccountScreen extends StatefulWidget {
  @override
  _RemoveAccountScreenState createState() => _RemoveAccountScreenState();
}

class _RemoveAccountScreenState extends State<RemoveAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RemoveAccountCubit(
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: BlocListener<RemoveAccountCubit, RemoveAccountState>(
        listener: (context, state) {
          if (state.status == RemoveAccountStatus.deleteUser) {
            context.read<AuthenticationBloc>().add(AuthLogoutRequested());
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          }

          if (state.status == RemoveAccountStatus.wrongPassword) {
            DefaultDialog.show(
              context,
              defaultButtonTitle: "확인",
              title: "비밀번호를 확인해주세요",
            );
          }
        },
        listenWhen: (pre, cur) =>
            pre.status != cur.status || pre.status != cur.status,
        child: BlocBuilder<RemoveAccountCubit, RemoveAccountState>(
          builder: (context, state) {
            var pwGuide = "";

            switch (state.passwordFieldStatus) {
              case PasswordFieldStatus.invalid:
                pwGuide = "영문+숫자+특수문자 포함 8자 이상 20글자 이하로 입력해주세요.";
                break;
              case PasswordFieldStatus.wrong:
                pwGuide = "비밀번호를 확인해주세요.";
                break;
              default:
                break;
            }

            return BaseScaffold(
              title: "",
              resizeToAvoidBottomInset: true,
              buttons: [
                BaseScaffoldDefaultButtonScheme(
                    title: "탈퇴하기",
                    onTap: state.enabled
                        ? () {
                            FocusScope.of(context).unfocus();

                            DefaultDialog.show(context, title: "정말 탈퇴하시겠습니까?",
                                onTap: () {
                              context.read<RemoveAccountCubit>().deleteUser();
                            });
                          }
                        : null),
              ],
              onBack: () {
                Navigator.pop(context);
              },
              backgroundColor: backgroundColor,
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      _description(),
                      SizedBox(height: 20),
                      _objectField(
                        title: "비밀번호 입력",
                        child: DefaultField(
                          backgroundColor: Colors.white,
                          guideText: pwGuide,
                          onError: !(state.passwordFieldStatus ==
                                  PasswordFieldStatus.success ||
                              state.passwordFieldStatus ==
                                  PasswordFieldStatus.initial),
                          hintText: "현재 비밀번호를 입력해주세요.",
                          onChange: (text) {
                            context
                                .read<RemoveAccountCubit>()
                                .changePasswordValue(text);
                          },
                        ),
                      ),
                      _objectField(
                        title: "무엇이 불편하셨나요?",
                        child: GestureDetector(
                          onTap: () async {
                            var items = [
                              "매칭이 되지 않음",
                              "서비스 사용이 어려움",
                              "비용이 비쌈",
                              "마음에 드는 상대가 없음",
                              "연인 또는 결혼 상대가 없음",
                              "다른 결혼 정보 회사로 이동",
                              "서비스가 신뢰가 가지 않음",
                              "기타 (직접 작성)"
                            ];
                            var inconvenient = await showBottomOptionSheet(
                              context,
                              title: "불편사항",
                              items: items,
                              labels: items,
                            );
                            if (inconvenient != null) {
                              context
                                  .read<RemoveAccountCubit>()
                                  .changeInconvenientValue(inconvenient);
                            }
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: gray300),
                            ),
                            child: Text(
                              state.inconvenient.isNotEmpty
                                  ? state.inconvenient
                                  : '불편사항을 선택해주세요.',
                              style: body01.copyWith(color:state.inconvenient.isEmpty ? gray400 : gray900),
                            ),
                          ),
                        ),
                      ),
                      if (state.inconvenient == "기타 (직접 작성)")
                      DefaultField(
                        backgroundColor: Colors.white,
                        maxLine: 5,
                        hintText: "불편사항을 입력해주세요.",
                        onChange: (text) {
                          context
                              .read<RemoveAccountCubit>()
                              .changeInconvenientValue(text);
                        },
                      ),

                      SizedBox(height: 20),
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

  _objectField({required String title, required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: body03.copyWith(color: gray900),
          ),
          SizedBox(height: 8),
          child
        ],
      ),
    );
  }

  _description() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: cardShadow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '회원탈퇴 안내\n',
            style: body03.copyWith(color: gray600),
          ),
          Text(
            '고객님께서 회원 탈퇴를 원하신다니 저희 앱의 서비스가 많이 부족하고 미흡했나 봅니다. 불편하셨던 점이나 불만사항을 알려주시면 적극 반영해서 고객님의 불편함을 해결해 드리도록 노력하겠습니다.',
            style: body01.copyWith(color: gray600),
          ),
          Text(
            '\n아울러 회원 탈퇴시의 아래 사항을 숙지하시기 바랍니다.\n',
            style: body03.copyWith(color: gray600),
          ),
          Text(
            '1. 회원 탈퇴 시 고객님의 정보는 상품 반품 및 A/S를 위해 전자상거래 등에서의 소비자 보호에 관한 법률에 의거한 고객정보 보호정책에 따라 관리 됩니다.\n\n2. 탈퇴 시 고객님께서 보유하셨던 적립금은 모두 삭제 됩니다.\n\n3. 회원 탈퇴 후 30일간 재가입이 불가능합니다.\n\n4. 회원 탈퇴시 회원 해지는 별도로 고객센터(1544-2857)를 통해서 가능합니다. 직접 해지를 요청하지 않으면 해지 처리가 되지 않습니다.',
            style: body01.copyWith(color: gray600),
          ),
        ],
      ),
    );
  }
}
