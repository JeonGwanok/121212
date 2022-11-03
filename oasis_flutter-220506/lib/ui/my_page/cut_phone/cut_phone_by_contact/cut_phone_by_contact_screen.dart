import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/model/user/cut_phone.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/common/on_off_switcher.dart';
import 'package:oasis/ui/my_page/cut_phone/cut_phone_by_contact/cubit/cut_phone_by_contact_state.dart';
import 'package:oasis/ui/theme.dart';

import 'cubit/cut_phone_by_contact_cubit.dart';

class CutPhoneByContactScreen extends StatefulWidget {
  @override
  _CutPhoneByContactScreenState createState() =>
      _CutPhoneByContactScreenState();
}

class _CutPhoneByContactScreenState extends State<CutPhoneByContactScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CutPhoneByContactCubit(
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: BlocListener<CutPhoneByContactCubit, CutPhoneByContactState>(
        listener: (context, state) {
          if (state.status == CutPhoneByContactScreenStatus.cutSuccess) {
            DefaultDialog.show(
              context,
              title: "1개의 연락처를\n지인방지 해제했습니다.",
              defaultButtonTitle: "확인",
            );
          }

          if (state.status ==
              CutPhoneByContactScreenStatus.registerCutsSuccess) {
            DefaultDialog.show(
              context,
              title: "${state.registeredNumber.length} 개의 연락처를\n지인방지 처리했습니다.",
              defaultButtonTitle: "확인",
            );
          }

          if (state.status ==
              CutPhoneByContactScreenStatus.registerRemoveSuccess) {
            DefaultDialog.show(
              context,
              title: "${state.registeredNumber.length} 개의 연락처를\n지인방지 해제했습니다.",
              defaultButtonTitle: "확인",
            );
          }

          if (state.status == CutPhoneByContactScreenStatus.selectCutsSuccess) {
            DefaultDialog.show(
              context,
              title: "${state.selected.length} 개의 연락처를\n지인방지 처리했습니다.",
              description: "이미 추가한 번호는 처리되지 않습니다.",
              defaultButtonTitle: "확인",
            );
          }
        },
        listenWhen: (pre, cur) => pre.status != cur.status,
        child: BlocBuilder<CutPhoneByContactCubit, CutPhoneByContactState>(
          builder: (context, state) {
            return BaseScaffold(
              title: "연락처로 번호 차단 등록",
              onLoading: state.status == CutPhoneByContactScreenStatus.loading,
              showAppbarUnderline: false,
              backgroundColor: backgroundColor,
              buttons: [
                BaseScaffoldDefaultButtonScheme(
                    title: "저장",
                    onTap: () {
                      context.read<CutPhoneByContactCubit>().save();
                    })
              ],
              onBack: () {
                Navigator.pop(context);
              },
              body: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: OnOffSwitch(
                        title: state.switchOff ? "전체차단" : "전체해제",
                        onChanged: (value) {
                          if (state.switchOff) {
                            context.read<CutPhoneByContactCubit>().allCut();
                          } else {
                            context.read<CutPhoneByContactCubit>().allRemove();
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 7),
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
                                ...state.phones.map(
                                  (e) {
                                    var phoneNumber =
                                        (e.phones ?? []).isNotEmpty
                                            ? e.phones!.first.value!
                                                .replaceAll("-", "")
                                                .replaceAll(" ", "")
                                                .replaceAll("(", "")
                                                .replaceAll(")", "")
                                            : "";

                                    List<CutPhone> registereds = state
                                        .registeredNumber
                                        .where((element) =>
                                            phoneNumber == element.phoneNumber)
                                        .toList();
                                    CutPhone? registered;
                                    if (registereds.isNotEmpty) {
                                      registered = registereds.first;
                                    }

                                    return _tile(
                                      contact: e,
                                      isSelect: state.selected.contains(e),
                                      isRegistered: registered != null,
                                      onTap: () {
                                        if (registered != null) {
                                          context
                                              .read<CutPhoneByContactCubit>()
                                              .remove(registered);
                                        } else if (state.selected.contains(e)) {
                                          context
                                              .read<CutPhoneByContactCubit>()
                                              .unselect(e);
                                        } else {
                                          context
                                              .read<CutPhoneByContactCubit>()
                                              .select(e);
                                        }
                                      },
                                    );
                                  },
                                ).toList(),
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
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _tile({
    required Contact contact,
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
                  "${contact.displayName}",
                  style: header03.copyWith(color: gray900),
                ),
                SizedBox(height: 8),
                Text(
                    "${(contact.phones ?? []).isNotEmpty ? contact.phones!.first.value : "--"}",
                    style: body01.copyWith(color: gray900)),
              ],
            ),
          ),
          Container(
            width: 86,
            child: DefaultSmallButton(
              reverse: isRegistered,
              color: isRegistered
                  ? null
                  : isSelect
                      ? heartRed
                      : null,
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
