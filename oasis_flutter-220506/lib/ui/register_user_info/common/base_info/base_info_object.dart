import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oasis/model/user/image/user_image.dart';
import 'package:oasis/ui/common/cache_image.dart';
import 'package:oasis/ui/common/custom_date_picker.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/common/default_ignore_field.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/common/object_text_default_frame.dart';
import 'package:oasis/ui/profile_image_update/profile_image_update_screen.dart';
import 'package:oasis/ui/register_user_info/common/base_info/gender_select.dart';
import 'package:oasis/ui/register_user_info/cubit/register_user_info_cubit.dart';
import 'package:oasis/ui/register_user_info/cubit/register_user_info_state.dart';
import 'package:oasis/ui/sign/util/field_status.dart';
import 'package:oasis/ui/util/date.dart';

import '../../../theme.dart';

class RegisterBaseInfoPage extends StatefulWidget {
  @override
  _RegisterBaseInfoPageState createState() => _RegisterBaseInfoPageState();
}

class _RegisterBaseInfoPageState extends State<RegisterBaseInfoPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterUserInfoCubit, RegisterUserInfoState>(
      builder: (context, state) {
        var ratio = MediaQuery.of(context).size.height / 896;
        return Column(
          children: [
            SizedBox(height: 42 * ratio),
            _imageSelect(context, state),
            SizedBox(height: 20),
            GenderSelect(
              initialValue: state.gender,
              onChangeGender: (gender) {
                // context
                //     .read<RegisterUserInfoCubit>()
                //     .enterBaseInfo(gender: gender);
              },
            ),
            SizedBox(height: 20),
            _nameField(state.name ?? "", state.nameStatus),
            SizedBox(height: 20),
            _birthField(Date.stringToDate(state.birth)),
            SizedBox(height: 35),
          ],
        );
      },
    );
  }

  _imageSelect(BuildContext context, RegisterUserInfoState state) {
    var ratio = MediaQuery.of(context).size.height / 896;
    return Container(
      width: 180,
      child: Column(
        children: [
          (state.images.representative1 ?? "").isNotEmpty
              ? Container(
                  width: 180 * ratio,
                  height: 180 * ratio,
                  clipBehavior: Clip.hardEdge,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: CacheImage(
                    url: state.images.representative1!,
                    boxFit: BoxFit.cover,
                  ),
                )
              : GestureDetector(
                  onTap: () async {
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPhotoPage(),
                      ),
                    );

                    if (result != null && !(result is bool)) {
                      context
                          .read<RegisterUserInfoCubit>()
                          .enterImage(image: result);
                    }
                  },
                  child: Container(
                    width: 180 * ratio,
                    height: 180 * ratio,
                    decoration: BoxDecoration(
                      border: Border.all(color: gray300),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: CustomIcon(
                      width: 40,
                      height: 40,
                      path: "icons/big_plus",
                    ),
                  ),
                ),
          SizedBox(height: 6),
          DefaultSmallButton(
            title: "???????????????",
            onTap: () async {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterPhotoPage(),
                ),
              );

              if (result != null && !(result is bool)) {
                context.read<RegisterUserInfoCubit>().enterImage(image: result);
              }
            },
          )
        ],
      ),
    );
  }

  _nameField(String initial, NickNameFieldStatus status) {
    var guidMsg = "";
    bool onError = false;
    // if (status == NickNameFieldStatus.initial) {
    //   guidMsg = "2?????? ?????? 10?????? ?????? ??????, ??????, ?????? ????????????\n(????????????, ????????????, ???????????? ?????? ??????)";
    // }

    if (status == NickNameFieldStatus.invalid) {
      guidMsg = "2??? ??????, 10??? ??????. ??????, ????????????, ???????????? ?????? ??????";
      onError = true;
    }

    return ObjectTextDefaultFrame(
      title: "* ??????",
      body: DefaultField(
        hintText: "????????? ??????????????????",
        initialValue: initial,
        enable: false,
        guideText: guidMsg,
        onError: onError,
        textLimit: 10,
        onChange: (name) {
          context.read<RegisterUserInfoCubit>().enterBaseInfo(name: name);
        },
      ),
    );
  }

  _birthField(DateTime? initial) {
    var date = initial ?? DateTime.now();
    return ObjectTextDefaultFrame(
      title: "* ????????????",
      body: DefaultField(
        enable: false,
        initialValue: initial != null ? DateFormat("yyyy-MM-dd").format(initial) : null,
      ),
      // body: DefaultIgnoreField(
      //   hintMsg: '??????????????? ??????????????????.',
      //   initialValue:
      //       initial != null ? DateFormat("yyyy-MM-dd").format(initial) : null,
      //   onTap: () {
      //     FocusScope.of(context).unfocus();
      //     showModalBottomSheet(
      //         context: context,
      //         isDismissible: false,
      //         builder: (_context) {
      //           return CustomDatePicker(
      //             initValue: date,
      //             onDateChanged: (datetime) {
      //               var birthYear = DateTime.now().year - datetime.year + 1;
      //               context.read<RegisterUserInfoCubit>().enterBaseInfo(
      //                   birth:
      //                       "${datetime.year}-${datetime.month}-${datetime.day}");
      //               Navigator.pop(context);
      //               if (birthYear < 20) {
      //                 DefaultDialog.show(
      //                   context,
      //                   title: "??????????????? ????????? ??????????????????.",
      //                   defaultButtonTitle: "??????",
      //                 );
      //               }
      //             },
      //           );
      //         });
      //   },
      // ),
    );
  }
}
