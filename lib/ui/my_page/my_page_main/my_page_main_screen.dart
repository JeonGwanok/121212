import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/matching/last_matching_history/last_matching_history_screen.dart';
import 'package:oasis/ui/my_page/component/my_page_top_profile_frame.dart';
import 'package:oasis/ui/my_page/cut_phone/cut_phone_main/cut_phone_screen.dart';
import 'package:oasis/ui/my_page/frequently_question/frequently_question_screen.dart';
import 'package:oasis/ui/my_page/my_info/cubit/my_page_info_cubit.dart';
import 'package:oasis/ui/my_page/my_info/cubit/my_page_info_state.dart';
import 'package:oasis/ui/my_page/my_info/my_page_info_screen.dart';
import 'package:oasis/ui/my_page/my_status/my_status_screen.dart';
import 'package:oasis/ui/my_page/purchase_history/purchase_history_screen.dart';
import 'package:oasis/ui/purchase/purchase_screen.dart';
import 'package:oasis/ui/sign/sign_up/component/terms/terms_detail.dart';
import 'package:oasis/ui/sign/sign_up/component/terms/terms_model.dart';
import 'package:oasis/ui/theme.dart';

import '../business_info_screen.dart';

class MyPageMainScreen extends StatefulWidget {
  final BuildContext mainContext;
  MyPageMainScreen({required this.mainContext});
  @override
  _MyPageMainScreenState createState() => _MyPageMainScreenState();
}

class _MyPageMainScreenState extends State<MyPageMainScreen> {
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
                    buttonName: "내 정보",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => MyPageInfoScreen(
                                    mainContext: widget.mainContext,
                                  )));
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    _button01(
                                      title: "나의\n현재 상태",
                                      iconName: "myStatus",
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyStatusScreen(
                                                      mainContext:
                                                          widget.mainContext,
                                                    )));
                                      },
                                    ),
                                    _button01(
                                      title: "결제 내역",
                                      iconName: "payment",
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PurchaseHistoryScreen()));
                                      },
                                    ),
                                    _button01(
                                        title: "지난 추천\n프로필 내역",
                                        iconName: "pastRecommend",
                                        onTap: () {
                                          if (state.user.customer?.membership ==
                                              null ) {
                                            DefaultDialog.show(context,
                                                title: "회원권이 없습니다.",
                                                yesRatio: 2,
                                                description: "회원권을 구매해주세요.",
                                                onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          PurchaseScreen(
                                                              mainContext: widget
                                                                  .mainContext)));
                                            });
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LastMatchingHistoryScreen()));
                                          }
                                        }),
                                    _button01(
                                      title: "지인 방지",
                                      iconName: "people",
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CutPhoneMainScreen()));
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Column(
                                  children: [
                                    _button02(
                                      title: "자주 묻는 질문",
                                      description:
                                          "궁금한 사항을 자주묻는 질문에서 먼저 찾아보세요.",
                                      imagePath: "qa",
                                      height: 35,
                                      imageColor: mainMint.withOpacity(0.1),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FrequentlyQuestionScreen()));
                                      },
                                    ),
                                    SizedBox(height: 16),
                                    _button02(
                                      title: "회원권 • 만남권 구매",
                                      description: "회원권, 만남권을 구매해보세요!",
                                      imagePath: "heart",
                                      height: 40,
                                      imageColor: heartRed.withOpacity(0.2),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => PurchaseScreen(
                                                    mainContext:
                                                        widget.mainContext)));
                                      },
                                    ),
                                    SizedBox(height: 16),
                                    _button03(
                                        title: "이용약관",
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TermDetail(
                                                item: state.terms.isNotEmpty
                                                    ? state.terms.first
                                                    : TermsModel(
                                                        title: "", content: ""),
                                              ),
                                            ),
                                          );
                                        }),
                                    SizedBox(height: 16),
                                    _button03(
                                        title: "개인정보 처리방침",
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TermDetail(
                                                item: state.terms.length > 1
                                                    ? state.terms[1]
                                                    : TermsModel(
                                                        title: "", content: ""),
                                              ),
                                            ),
                                          );
                                        }),
                                    SizedBox(height: 16),
                                    // _button03(
                                    //     title: "위치기반서비스 이용약관",
                                    //     onTap: () {
                                    //       Navigator.push(
                                    //         context,
                                    //         MaterialPageRoute(
                                    //           builder: (context) => TermDetail(
                                    //             item: state.terms.length > 2
                                    //                 ? state.terms[2]
                                    //                 : TermsModel(
                                    //                     title: "", content: ""),
                                    //           ),
                                    //         ),
                                    //       );
                                    //     }),
                                    // SizedBox(height: 16),
                                    _button03(
                                        title: "사업자 정보",
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BusinessInfoScreen()));
                                        }),
                                    SizedBox(
                                        height: MediaQuery.of(context)
                                                .padding
                                                .bottom +
                                            10),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

  Widget _button01({
    required String title,
    required String iconName,
    required Function onTap,
  }) {
    var ratio = MediaQuery.of(context).size.width / 414;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              border: Border.all(color: gray200),
              color: Colors.white,
              boxShadow: cardShadow,
              borderRadius: BorderRadius.circular(8)),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  CustomIcon(
                    path: "icons/$iconName",
                    width: 32 * ratio,
                    height: 32 * ratio,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: header03.copyWith(
                            fontFamily: "Godo", color: gray600, fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _button02({
    required String title,
    required String description,
    required String imagePath,
    Color? imageColor,
    double? height,
    required Function onTap,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
            border: Border.all(color: gray200),
            color: Colors.white,
            boxShadow: cardShadow,
            borderRadius: BorderRadius.circular(8)),
        child: Container(
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                width: double.infinity,
                height: 70,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style:
                          header03.copyWith(fontFamily: "Godo", color: gray600),
                    ),
                    SizedBox(height: 8),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: body01.copyWith(color: gray600),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 5,
                  right: 8,
                ),
                child: CustomIcon(
                  path: "icons/$imagePath",
                  color: imageColor,
                  width: 58,
                  height: height ?? 45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button03({
    required String title,
    required Function onTap,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: double.infinity,
        height: 48,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 16),
        margin: EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
            border: Border.all(color: gray200),
            color: Colors.white,
            boxShadow: cardShadow,
            borderRadius: BorderRadius.circular(8)),
        child: Container(
          child: Text(
            title,
            style: header03.copyWith(
              fontFamily: "Godo",
              color: gray600,
            ),
          ),
        ),
      ),
    );
  }
}
