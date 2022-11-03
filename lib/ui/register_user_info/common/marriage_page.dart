import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/profile/marriage_type.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/common/object_text_default_frame.dart';
import 'package:oasis/ui/common/radio_button_set.dart';
import 'package:oasis/ui/register_user_info/cubit/register_user_info_cubit.dart';
import 'package:oasis/ui/register_user_info/cubit/register_user_info_state.dart';
import 'package:oasis/ui/theme.dart';

class RegisterMarriagePage extends StatefulWidget {
  @override
  _RegisterMarriagePageState createState() => _RegisterMarriagePageState();
}

class _RegisterMarriagePageState extends State<RegisterMarriagePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterUserInfoCubit, RegisterUserInfoState>(
      builder: (context, state) {
        return Column(
          children: [
            ObjectTextDefaultFrame(
              title: "* 혼인 여부",
              description: "혼인 여부를 선택해주세요.",
              body: RadioButtonSet(
                  initialValue: state.marriage,
                  items: MarriageType.values,
                  labels: MarriageType.values.map((e) => e.title).toList(),
                  onTap: (type) {
                    context.read<RegisterUserInfoCubit>().enterMarriageInfo(
                        marriage: type as MarriageType,
                        hasChildren: type == MarriageType.single
                            ? HasChildrenType.no
                            : null);
                  }),
            ),
            SizedBox(height: 20),
            if (state.marriage == MarriageType.married)
              ObjectTextDefaultFrame(
                title: "* 자녀여부",
                description: "자녀 여부를 선택해주세요.",
                body: RadioButtonSet(
                    initialValue: state.hasChildren,
                    items: HasChildrenType.values,
                    labels: HasChildrenType.values.map((e) => e.title).toList(),
                    onTap: (type) {
                      context.read<RegisterUserInfoCubit>().enterMarriageInfo(
                          hasChildren: type as HasChildrenType);
                    }),
              ),
            SizedBox(height: 20),
            if (state.hasChildren == HasChildrenType.yes)
              ObjectTextDefaultFrame(
                title: "* 자녀",
                body: Row(
                  children: [
                    _childrenCountField("남", state.childrenMan, (count) {
                      context
                          .read<RegisterUserInfoCubit>()
                          .enterMarriageInfo(childrenMan: count);
                    }),
                    _childrenCountField("여", state.childrenWomen, (count) {
                      context
                          .read<RegisterUserInfoCubit>()
                          .enterMarriageInfo(childrenWomen: count);
                    }),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  _childrenCountField(
      String title, String? initial, Function(String) onChange) {
    return Row(
      children: [
        Text(
          title,
          style: body02,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: 80,
          child: DefaultField(
            hintText: "00",
            showCancelButton: false,
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
