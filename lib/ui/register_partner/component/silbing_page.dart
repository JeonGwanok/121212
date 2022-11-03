import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/common/object_text_default_frame.dart';
import 'package:oasis/ui/common/radio_button_set.dart';
import 'package:oasis/ui/register_extra_user_profile/cubit/register_extra_user_info_cubit.dart';
import 'package:oasis/ui/register_extra_user_profile/cubit/register_extra_user_info_state.dart';
import 'package:oasis/ui/theme.dart';

class RegisterSiblingPage extends StatefulWidget {
  @override
  _RegisterSiblingPageState createState() => _RegisterSiblingPageState();
}

class _RegisterSiblingPageState extends State<RegisterSiblingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterExtraUserInfoCubit, RegisterExtraUserInfoState>(
      builder: (context, state) {
        return Column(
          children: [
            ObjectTextDefaultFrame(
              title: "형제자매여부",
              description: "형제자매여부를 선택해주세요.",
              body: RadioButtonSet(
                  initialValue: state.sibling != null
                      ? (state.sibling! ? "있음" : "없음")
                      : null,
                  items: ["없음", "있음"],
                  labels: ["없음", "있음"],
                  onTap: (type) {
                    context.read<RegisterExtraUserInfoCubit>().enterValue(
                        sibling: (type as String) == "없음" ? false : true);
                  }),
            ),
            // if (state.sibling != null && state.sibling!) SizedBox(height: 20),
            // if (state.sibling != null && state.sibling!)
            //   ObjectTextDefaultFrame(
            //     title: "* 형제관계",
            //     body: Row(
            //       children: [
            //         _siblingCountField("남", state.siblingMan, (count) {
            //           context
            //               .read<RegisterExtraUserInfoCubit>()
            //               .enterValue(siblingMan: count);
            //         }),
            //         _siblingCountField("여", state.siblingWoman, (count) {
            //           context
            //               .read<RegisterExtraUserInfoCubit>()
            //               .enterValue(siblingWoman: count);
            //         }),
            //         _siblingCountField("중", state.siblingRank, (count) {
            //           context
            //               .read<RegisterExtraUserInfoCubit>()
            //               .enterValue(siblingRank: count);
            //         }),
            //         Text(
            //           "째",
            //           style: body02,
            //         )
            //       ],
            //     ),
            //   ),
          ],
        );
      },
    );
  }

  _siblingCountField(String title, String? initial, Function(String) onChange) {
    return Row(
      children: [
        Text(
          title,
          style: body02,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: 60,
          child: DefaultField(
            showCancelButton: false,
            hintText: "00",
            initialValue: initial != null ? "$initial" : null,
            keyboardType: TextInputType.number,
            onChange: (text) {
                onChange(text);

            },
          ),
        )
      ],
    );
  }
}
