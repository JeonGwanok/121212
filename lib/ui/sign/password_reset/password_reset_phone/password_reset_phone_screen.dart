import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/repository/auth_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/sign/password_reset/password_reset/password_reset_screen.dart';
import 'package:oasis/ui/sign/sign_up/phone_certificate_screen.dart';
import 'package:oasis/ui/sign/sign_up/sign_up_screen.dart';
import 'package:oasis/ui/sign/util/field_status.dart';
import 'package:oasis/ui/theme.dart';
import 'package:oasis/ui/util/bold_generator.dart';

import 'cubit/password_reset_phone_cubit.dart';

class PasswordResetPhoneScreen extends StatefulWidget {
  @override
  _PasswordResetPhoneScreenState createState() =>
      _PasswordResetPhoneScreenState();
}

class _PasswordResetPhoneScreenState extends State<PasswordResetPhoneScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => PasswordResetPhoneCubit(
          authRepository: context.read<AuthRepository>()),
      child: BlocListener<PasswordResetPhoneCubit, PasswordResetPhoneState>(
        listener: (context, state) {
          if (state.phoneStatus == PhoneFieldStatus.alreadyInUse) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PasswordResetScreen(
                  username: state.phoneN,
                ),
              ),
            );
          }
        },
        listenWhen: (pre, cur) =>
            pre.status != cur.status || pre.phoneStatus != cur.phoneStatus,
        child: BlocBuilder<PasswordResetPhoneCubit, PasswordResetPhoneState>(
          builder: (context, state) {
            var ratio = MediaQuery.of(context).size.height / 896;

            var phoneGuide = "";
            var onErr = false;

            switch (state.phoneStatus) {
              case PhoneFieldStatus.initial:
                phoneGuide = "-?????? ??????????????????.";
                break;
              case PhoneFieldStatus.invalid:
                phoneGuide = "????????? ???????????? ???????????? ????????????.";
                onErr = true;
                break;
              case PhoneFieldStatus.userNotFound:
                phoneGuide = "???????????? ?????? ?????????????????????.";
                onErr = true;
                break;
              default:
                break;
            }

            return BaseScaffold(
              title: "???????????? ??????",
              onBack: () {
                Navigator.pop(context);
              },
              buttons: [
                BaseScaffoldDefaultButtonScheme(
                  title: "????????????",
                  onTap: state.phoneStatus == PhoneFieldStatus.valid ||
                          state.phoneStatus == PhoneFieldStatus.alreadyInUse
                      ? () async {
                          var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhoneCertificateScreen(
                                phoneNumber: state.phoneN,
                              ),
                            ),
                          );

                          if (result != null) {
                            context
                                .read<PasswordResetPhoneCubit>()
                                .verifyPhoneN();
                          }
                        }
                      : null,
                ),
              ],
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(height: 42 * ratio),
                        Column(
                          children: [
                            CustomIcon(
                              path: 'icons/lock_illust',
                              height: 106,
                            ),
                            SizedBox(height: 20),
                            Text(
                              '???????????? ????????? ??????????',
                              style: header02.copyWith(color: gray900),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        DefaultField(
                          hintText: "????????? ????????? ??????????????? ??????????????????.",
                          guideText: phoneGuide,
                          onError: onErr,
                          keyboardType: TextInputType.phone,
                          textLimit: 11,
                          initialValue: state.phoneN,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChange: (text) {
                            context
                                .read<PasswordResetPhoneCubit>()
                                .changePhoneN(text);
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: gray300,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '??????',
                            style: caption01.copyWith(color: gray400),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: gray300,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            FocusScope.of(context).unfocus();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SignUpScreen(),
                                ));
                          },
                          child: Text(
                            '??? ?????? ?????????',
                            style: header02.copyWith(color: gray900),
                          ),
                        ),
                        SizedBox(height: 8),
                        BoldMsgGenerator.toRichText(
                          msg:
                              "??? ??????????????? ?????? ????????? ????????????\n?????? ????????? ?????? ?????? ??????\n???????????? *1544-2857*?????? ????????? ?????????.",
                          style: body02.copyWith(color: gray600, height: 1.5),
                          boldWeight: FontWeight.w800,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        Text(
                          '?????? ?????? ??? ?????? ?????? ????????????',
                          style: caption01.copyWith(color: gray400),
                        ),
                        Text(
                          '??????  |  10:00 ~ 18:00??????',
                          style: caption01.copyWith(
                              fontSize: 11, color: gray400, height: 1.5),
                        ),
                        Text(
                          '??????(?????????????????????)  |  ?????????',
                          style:
                              caption02.copyWith(color: gray400, height: 1.5),
                        ),
                      ],
                    ),
                    SizedBox(height: 110 * ratio),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
