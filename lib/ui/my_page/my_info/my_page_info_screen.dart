import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/authentication/authentication_bloc.dart';
import 'package:oasis/bloc/authentication/authentication_event.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/my_page/component/my_page_top_profile_frame.dart';
import 'package:oasis/ui/my_page/my_info/cubit/my_page_info_state.dart';
import 'package:oasis/ui/my_page/my_info_detail/my_info_detail_screen.dart';
import 'package:oasis/ui/my_page/my_partner_info/my_partner_info_screen.dart';
import 'package:oasis/ui/my_page/my_temper_result/my_temper_result_screen.dart';
import 'package:oasis/ui/my_page/remove_account/remove_account_screen.dart';
import 'package:oasis/ui/my_story/my_story_main/my_story_screen.dart';
import 'package:oasis/ui/theme.dart';

import '../my_community_list.dart';
import 'cubit/my_page_info_cubit.dart';

class MyPageInfoScreen extends StatefulWidget {
  final BuildContext mainContext;
  MyPageInfoScreen({
    required this.mainContext,
  });
  @override
  _MyPageInfoScreenState createState() => _MyPageInfoScreenState();
}

class _MyPageInfoScreenState extends State<MyPageInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MyPageInfoCubit(
        userRepository: context.read<UserRepository>(),
        commonRepository: context.read<CommonRepository>(),
      )..initialize(),
      child: BlocBuilder<MyPageInfoCubit, MyPageInfoState>(
        builder: (context, state) {
          return BaseScaffold(
            title: "",
            appbarColor: Colors.white,
            backgroundColor: backgroundColor,
            onBack: () {
              Navigator.pop(context);
            },
            body: Container(
              child: Column(
                children: [
                  MyPageTopProfileFrame(
                    user: state.user,
                    buttonName: "더보기",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyInfoDetailScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 12),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        _button(
                          title: "내 성향분석 결과",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TemperResultScreen(),
                              ),
                            );
                          },
                        ),
                        _button(
                          title: "나의 일상",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyStoryScreen(
                                  customerId: state.user.customer?.id,
                                ),
                              ),
                            );
                          },
                        ),
                        _button(
                          title: "나의 정보 커뮤니티",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyCommunityListScreen(
                                  customerId: state.user.customer?.id,
                                ),
                              ),
                            );
                          },
                        ),
                        _button(
                          title: "나의 이상형 정보",
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => RegisterPartnerInfoScreen(
                                        widget.mainContext)));
                          },
                        ),
                        _button(
                          title: "로그아웃",
                          isGrayScale: true,
                          onTap: () {
                            DefaultDialog.show(context,
                                title: "로그아웃",
                                description: "로그아웃 하시겠습니까?", onTap: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              context
                                  .read<AuthenticationBloc>()
                                  .add(AuthLogoutRequested());
                            });
                          },
                        ),
                        _button(
                          title: "서비스 탈퇴",
                          isGrayScale: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RemoveAccountScreen(),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).padding.bottom + 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _button({
    required String title,
    required Function onTap,
    bool isGrayScale = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: DefaultSmallButton(
        title: title,
        onTap: () {
          onTap();
        },
        showShadow: true,
        reverse: true,
        isGrayScale: isGrayScale,
      ),
    );
  }
}
