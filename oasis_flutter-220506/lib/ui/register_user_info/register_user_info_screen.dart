import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/authentication/authentication_bloc.dart';
import 'package:oasis/bloc/authentication/authentication_event.dart';
import 'package:oasis/enum/profile/job_type.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/common/default_ignore_field.dart';
import 'package:oasis/ui/common/object_text_default_frame.dart';
import 'package:oasis/ui/common/showBottomSheet.dart';
import 'package:oasis/ui/register_user_info/common/academic_page.dart';
import 'package:oasis/ui/register_user_info/common/base_info/base_info_object.dart';
import 'package:oasis/ui/register_user_info/common/marriage_page.dart';
import 'package:oasis/ui/register_user_info/common/region_page.dart';
import 'package:oasis/ui/register_user_info/common/religion_page.dart';
import 'package:oasis/ui/sign/util/field_status.dart';
import 'package:oasis/ui/theme.dart';

import 'common/work_region_page.dart';
import 'cubit/register_user_info_cubit.dart';
import 'cubit/register_user_info_state.dart';

class RegisterUserInfoScreen extends StatelessWidget {
  final int initialPage;
  final Function onNext;
  final Function onPrev;

  RegisterUserInfoScreen({
    required this.initialPage,
    required this.onNext,
    required this.onPrev,
  });

  @override
  Widget build(BuildContext mainContext) {
    return BlocProvider(
      create: (BuildContext context) => RegisterUserInfoCubit(
          initialPage:initialPage,
        userRepository: context.read<UserRepository>(),
        commonRepository: context.read<CommonRepository>(),
      )..initialize(),
      child: BlocListener<RegisterUserInfoCubit, RegisterUserInfoState>(
        listener: (context, state) {
          if (state.isComplete) {
            onNext();
          }
        },
        child: BlocBuilder<RegisterUserInfoCubit, RegisterUserInfoState>(
          builder: (context, state) {
            var ratio = MediaQuery.of(context).size.height / 896;
            return BaseScaffold(
              onBack: () async {
                if (state.page == 0) {
                  DefaultDialog.show(
                    context,
                    title: "그만하시겠어요?",
                    description: "이전 내용들은 그대로 저장됩니다.", // TODO: ?? 이거 어떤의미?
                    onTap: () {
                      context
                          .read<AuthenticationBloc>()
                          .add(AuthLogoutRequested());
                      onPrev();
                    },
                  );
                } else {
                  context.read<RegisterUserInfoCubit>().prev();
                }
              },
              resizeToAvoidBottomInset: true,
              buttons: [
                BaseScaffoldDefaultButtonScheme(
                  title: "다음",
                  onTap: state.enableButton
                      ? () {
                          context.read<RegisterUserInfoCubit>().next();
                        }
                      : null,
                )
              ],
              title: "회원가입",
              body: state.status == ScreenStatus.initial
                  ? Container()
                  : Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          height: double.infinity,
                          padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: state.page == 0 ? 0 : 80 * ratio,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                if (state.page == 0) RegisterBaseInfoPage(),
                                if (state.page == 1)
                                  ObjectTextDefaultFrame(
                                    title: "* 키",
                                    body: DefaultField(
                                      hintText: "cm",
                                      initialValue: state.height,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      guideText: (state.heightStatus ==
                                                  HeightFieldStatus.success ||
                                              state.heightStatus ==
                                                  HeightFieldStatus.initial)
                                          ? null
                                          : "120cm이상 300cm이하로 입력해주세요.",
                                      onError: (state.heightStatus ==
                                                  HeightFieldStatus.success ||
                                              state.heightStatus ==
                                                  HeightFieldStatus.initial)
                                          ? false
                                          : true,
                                      onChange: (height) {
                                        context
                                            .read<RegisterUserInfoCubit>()
                                            .enterHeightInfo(height: height);
                                      },
                                    ),
                                  ),
                                if (state.page == 2) RegisterRegionPage(),
                                if (state.page == 3) RegisterWorkRegionPage(),
                                if (state.page == 4) RegisterAcademicPage(),
                                if (state.page == 5)
                                  ObjectTextDefaultFrame(
                                    title: "* 직업",
                                    body: DefaultIgnoreField(
                                      hintMsg: "직업을 선택해주세요.",
                                      initialValue: state.job?.title,
                                      onTap: () async {
                                        var job = await showBottomOptionSheet(
                                            context,
                                            title: "* 직업",
                                            items: JobType.values,
                                            labels: JobType.values
                                                .map((e) => e.title)
                                                .toList());
                                        if (job != null) {
                                          context
                                              .read<RegisterUserInfoCubit>()
                                              .enterJobInfo(job: job);
                                        }
                                      },
                                    ),
                                  ),
                                if (state.page == 6) RegisterMarriagePage(),
                                if (state.page == 7) RegisterReligionPage(),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10 * ratio),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${state.page + 1} ',
                                style: body03.copyWith(color: gray400),
                              ),
                              Text(
                                '/ 8',
                                style: body03.copyWith(color: gray300),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}
