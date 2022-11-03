import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/ui/common/default_ignore_field.dart';
import 'package:oasis/ui/common/object_text_default_frame.dart';
import 'package:oasis/ui/common/showBottomSheet.dart';
import 'package:oasis/ui/register_user_info/cubit/register_user_info_cubit.dart';
import 'package:oasis/ui/register_user_info/cubit/register_user_info_state.dart';

class RegisterReligionPage extends StatefulWidget {
  @override
  _RegisterReligionPageState createState() => _RegisterReligionPageState();
}

class _RegisterReligionPageState extends State<RegisterReligionPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterUserInfoCubit, RegisterUserInfoState>(
        builder: (context, state) {
      return ObjectTextDefaultFrame(
        title: "* 종교",
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DefaultIgnoreField(
                hintMsg: "종교를 선택해주세요.",
                initialValue: state.religion,
                enable: state.agreeReligionTerm,
                onTap: () async {
                  if (state.agreeReligionTerm) {
                    var items = ["무교", "기독교", "불교", "천주교", "기타"];
                    var religion = await showBottomOptionSheet(context,
                        title: "* 종교", items: items, labels: items);
                    if (religion != null) {
                      context
                          .read<RegisterUserInfoCubit>()
                          .enterReligionInfo(religion: religion);
                    }
                  }
                },
              ),
            ),
            // Container(
            //   width: 120,
            //   margin: EdgeInsets.only(left: 12),
            //   child: DefaultSmallButton(
            //     onTap: !state.agreeReligionTerm
            //         ? () async {
            //             var result = await Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) => TermDetail(
            //                   buttonLabel: "동의",
            //                   item: TermsModel(
            //                       title: "종교 정보 이용 동의",
            //                       content: state.terms?.religionTerms ?? ""),
            //                 ),
            //               ),
            //             );
            //
            //             if (result) {
            //               context.read<RegisterUserInfoCubit>().religionAgree();
            //             }
            //           }
            //         : null,
            //     title: state.agreeReligionTerm ? "동의완료" : "정보제공동의",
            //   ),
            // )
          ],
        ),
      );
    });
  }
}
