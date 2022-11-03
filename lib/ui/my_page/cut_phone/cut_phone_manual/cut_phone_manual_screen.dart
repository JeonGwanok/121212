import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/model/user/cut_phone.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/common/on_off_switcher.dart';
import 'package:oasis/ui/my_page/cut_phone/cut_phone_manual/cubit/cut_phone_manual_state.dart';
import 'package:oasis/ui/sign/util/field_status.dart';
import 'package:oasis/ui/theme.dart';

import 'cubit/cut_phone_manual_cubit.dart';

class CutPhoneManualScreen extends StatefulWidget {
  @override
  _CutPhoneManualScreenState createState() => _CutPhoneManualScreenState();
}

class _CutPhoneManualScreenState extends State<CutPhoneManualScreen> {
  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var ratio = MediaQuery.of(context).size.height / 896;
    return BlocProvider(
      create: (BuildContext context) => CutPhoneManualCubit(
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: BlocListener<CutPhoneManualCubit, CutPhoneManualState>(
        listener: (context, state) {
          if (state.status == CutPhoneManualScreenStatus.success) {
            DefaultDialog.show(
              context,
              title: "1개의 연락처를\n지인방지 처리했습니다.",
              defaultButtonTitle: "확인",
            );
          }

          if (state.status == CutPhoneManualScreenStatus.removeSuccess) {
            DefaultDialog.show(
              context,
              title: "1개의 연락처를\n지인방지 해제했습니다.",
              defaultButtonTitle: "확인",
            );
          }

          if (state.status ==
              CutPhoneManualScreenStatus.registerRemoveSuccess) {
            DefaultDialog.show(
              context,
              title: "${state.registered.length} 개의 연락처를\n지인방지 해제했습니다.",
              description: "이미 추가한 번호는 처리되지 않습니다.",
              defaultButtonTitle: "확인",
            );
          }

          if (state.status == CutPhoneManualScreenStatus.registerCutsSuccess) {
            DefaultDialog.show(
              context,
              title: "${state.registered.length} 개의 연락처를\n지인방지 처리했습니다.",
              description: "이미 추가한 번호는 처리되지 않습니다.",
              defaultButtonTitle: "확인",
            );
          }

          if (state.status == CutPhoneManualScreenStatus.selectCutsSuccess) {
            DefaultDialog.show(
              context,
              title: "${state.selected.length} 개의 연락처를\n지인방지 처리했습니다.",
              description: "이미 추가한 번호는 처리되지 않습니다.",
              defaultButtonTitle: "확인",
            );
          }
          setState(() {
            globalKey = GlobalKey();
          });
        },
        listenWhen: (pre, cur) => pre.status != cur.status,
        child: BlocBuilder<CutPhoneManualCubit, CutPhoneManualState>(
          builder: (context, state) {
            return BaseScaffold(
              title: "연락처로 지인 차단하기",
              onLoading: state.status == CutPhoneManualScreenStatus.loading,
              resizeToAvoidBottomInset: true,
              showAppbarUnderline: false,
              backgroundColor: backgroundColor,
              onBack: () {
                Navigator.pop(context);
              },
              body: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: OnOffSwitch(
                        value: state.switchOff,
                        title: "전체 해제",
                        onChanged: (value) {
                          if (state.switchOff) {
                            context.read<CutPhoneManualCubit>().allCut();
                          } else {
                            context.read<CutPhoneManualCubit>().allRemove();
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: _plusObject(
                        context: context,
                        state: state,
                      ),
                    ),
                    SizedBox(height: 10),
                    if (state.registered.isNotEmpty)
                      Expanded(
                        child: RawScrollbar(
                          thumbColor: gray300,
                          radius: Radius.circular(20),
                          thickness: 5,
                          crossAxisMargin: 3,
                          child: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  ...state.registered
                                      .map(
                                        (e) => _tile(
                                          phone: e,
                                          isRegistered:
                                              state.registered.contains(e),
                                          isSelect: state.selected.contains(e),
                                          onTap: () {
                                            if (state.registered.contains(e)) {
                                              context
                                                  .read<CutPhoneManualCubit>()
                                                  .remove(e);
                                            } else if (state.selected
                                                .contains(e)) {
                                              context
                                                  .read<CutPhoneManualCubit>()
                                                  .unselect(e);
                                            } else {
                                              context
                                                  .read<CutPhoneManualCubit>()
                                                  .select(e);
                                            }
                                          },
                                        ),
                                      )
                                      .toList(),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).padding.bottom +
                                            30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (state.registered.isEmpty)
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.only(top: 40),
                          child: Text(
                            '저장된 연락처가 없습니다.',
                            style: header02.copyWith(color: gray300),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _plusObject(
      {required BuildContext context, required CutPhoneManualState state}) {


    var phoneGuide = "";
    switch (state.phoneFieldStatus) {
      case PhoneFieldStatus.initial:
        phoneGuide = "-없이 입력해주세요.";
        break;
      case PhoneFieldStatus.invalid:
        phoneGuide = "올바른 전화번호 형식으로 써주세요.";
        break;
      default:
        break;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: gray300),
      ),
      child: Column(
        key: globalKey,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "이름",
                style: header03.copyWith(color: gray900),
              ),
              SizedBox(height: 8),
              DefaultField(
                hintText: "이름을 입력해주세요.",
                textLimit: 10,
                onChange: (text) {
                  context.read<CutPhoneManualCubit>().enterName(text);
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "전화번호",
                style: header03.copyWith(color: gray900),
              ),
              SizedBox(height: 8),
              DefaultField(
                hintText: "전화번호를 입력해주세요.",guideText: phoneGuide,
                onError: state.phoneFieldStatus != PhoneFieldStatus.initial &&
                    state.phoneFieldStatus != PhoneFieldStatus.valid,
                textLimit: 11,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChange: (text) {
                  context.read<CutPhoneManualCubit>().enterPhoneNumber(text);
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              if (state.name.isNotEmpty && state.phoneNumber.isNotEmpty) {
                context.read<CutPhoneManualCubit>().addPhoneNumber();
              }
            },
            child: CustomIcon(
              width: 28,
              height: 28,
              path: "icons/plus",
              color: gray300,
            ),
          ),
        ],
      ),
    );
  }

  _tile({
    required CutPhone phone,
    required bool isRegistered,
    required bool isSelect,
    required Function onTap,
  }) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: cardShadow,
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${phone.name}",
                  style: header03.copyWith(color: gray900),
                ),
                SizedBox(height: 8),
                Text("${phone.phoneNumber}",
                    style: body01.copyWith(color: gray900)),
              ],
            ),
          ),
          Container(
            width: 86,
            child: DefaultSmallButton(
              reverse: isRegistered,
              title: isRegistered
                  ? "해제"
                  : isSelect
                      ? "선택됨"
                      : "선택안됨",
              onTap: () {
                onTap();
              },
            ),
          )
        ],
      ),
    );
  }
}
