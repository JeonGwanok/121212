import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/profile/academic_type.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/common/default_ignore_field.dart';
import 'package:oasis/ui/common/object_text_default_frame.dart';
import 'package:oasis/ui/common/showBottomSheet.dart';
import 'package:oasis/ui/register_user_info/cubit/register_user_info_cubit.dart';
import 'package:oasis/ui/register_user_info/cubit/register_user_info_state.dart';
import 'package:oasis/ui/sign/util/field_status.dart';


class RegisterAcademicPage extends StatefulWidget {
  @override
  _RegisterAcademicPageState createState() => _RegisterAcademicPageState();
}

class _RegisterAcademicPageState extends State<RegisterAcademicPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterUserInfoCubit, RegisterUserInfoState>(
        builder: (context, state) {
          var schoolGuideMsg = "";
          if (state.schoolStatus == SchoolFieldStatus.invalid) {
            schoolGuideMsg = "2글자 이상, 숫자 입력 불가";
          }

      return Container(
        child: Column(
          children: [
            ObjectTextDefaultFrame(
              title: "* 학력",
              body: DefaultIgnoreField(
                hintMsg: "학력을 선택해주세요.",
                initialValue: state.academic?.title,
                onTap: () async {
                  var academic = await showBottomOptionSheet(context,
                      title: "* 학력",
                      items: AcademicType.values,
                      labels: AcademicType.values.map((e) => e.title).toList());
                  if (academic != null) {
                    context
                        .read<RegisterUserInfoCubit>()
                        .enterAcademicInfo(academic: academic);
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            ObjectTextDefaultFrame(
              title: "* 최종학력",
              body: DefaultField(
                hintText: "학교명을 적어주세요.",
                textLimit: 20,
                onError: !(state.schoolStatus == SchoolFieldStatus.success ||
                    state.schoolStatus == SchoolFieldStatus.initial),
                initialValue: state.schoolName,guideText: schoolGuideMsg,
                onChange: (school) {
                  context
                      .read<RegisterUserInfoCubit>()
                      .enterAcademicInfo(schoolName: school);
                },
              ),
            )
          ],
        ),
      );
    });
  }
}
