import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/model/user/image/user_image.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/cache_image.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/common/object_text_default_frame.dart';
import 'package:oasis/ui/my_page/my_info_detail/cubit/my_info_detail_state.dart';
import 'package:oasis/ui/profile_image_update/profile_image_update_screen.dart';
import 'package:oasis/ui/theme.dart';

import 'component/my_info_edit_object.dart';
import 'cubit/my_info_detail_cubit.dart';

class MyInfoDetailScreen extends StatefulWidget {
  @override
  _MyInfoDetailScreenState createState() => _MyInfoDetailScreenState();
}

class _MyInfoDetailScreenState extends State<MyInfoDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MyInfoDetailCubit(
        userRepository: context.read<UserRepository>(),
        commonRepository: context.read<CommonRepository>(),
      )..initialize(),
      child: BlocListener<MyInfoDetailCubit, MyInfoDetailState>(
        listener: (context, state) async {
          if (state.status == MyInfoDetailStateStatus.editSuccess) {
            DefaultDialog.show(
              context,
              defaultButtonTitle: "확인",
              title: "성공적으로 수정되었습니다.",
            );
          }
        },
        listenWhen: (pre, cur) => pre.status != cur.status,
        child: BlocBuilder<MyInfoDetailCubit, MyInfoDetailState>(
          builder: (context, state) {
            return BaseScaffold(
              title: "",
              showAppbarUnderline: false,
              resizeToAvoidBottomInset: true,
              backgroundColor: backgroundColor,
              onBack: () {
                Navigator.pop(context);
              },
              body: state.status != MyInfoDetailStateStatus.loading
                  ? Container(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: 90,
                                  margin: EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  child: DefaultSmallButton(
                                    title: "수정하기",
                                    reverse: true,
                                    showShadow: true,
                                    hideBorder: true,
                                    onTap: state.enabledButton
                                        ? () {
                                            DefaultDialog.show(context,
                                                title: "수정하시겠습니까?", onTap: () {
                                              context
                                                  .read<MyInfoDetailCubit>()
                                                  .updateProfile();
                                            });
                                          }
                                        : null,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _image(
                                            state.userProfile.image
                                                    ?.representative1 ??
                                                "",
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: _image(
                                              state.userProfile.image
                                                      ?.representative2 ??
                                                  "",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: DefaultSmallButton(
                                        title: "내 사진 수정하기",
                                        reverse: true,
                                        showShadow: true,
                                        onTap: () async {
                                          UserImage? result =
                                              await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterPhotoPage(
                                                type:
                                                    RegisterPhotoPageType.edit,
                                              ),
                                            ),
                                          );

                                          if (result != null) {
                                            context
                                                .read<MyInfoDetailCubit>()
                                                .updateImage(image: result);
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: cardShadow,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyInfoEditObject(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: cardShadow,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      child: Column(
                                        children: [
                                          ObjectTextDefaultFrame(
                                            title: "자기소개 (매력・장점・인사말)",
                                            body: DefaultField(
                                              textLimit: 200,
                                              maxLine: 4,
                                              hintText: "최소 10자~최대200자",
                                              onError: state.disabledMyself,
                                              showCount: true,
                                              guideText: state.disabledMyself
                                                  ? "최소 10자 ~ 최대 200자"
                                                  : "",
                                              initialValue: state.myIntroduce,
                                              onChange: (text) {
                                                context
                                                    .read<MyInfoDetailCubit>()
                                                    .changeMyIntroduce(text);
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          ObjectTextDefaultFrame(
                                            title: "나의 업무 소개",
                                            body: DefaultField(
                                              hintText: "최소 10자~최대200자",
                                              maxLine: 4,
                                              textLimit: 200,
                                              showCount: true,
                                              onError: state.disabledMyWork,
                                              guideText: state.disabledMyWork
                                                  ? "최소 10자 ~ 최대 200자"
                                                  : "",
                                              initialValue: state.myWorkIntro,
                                              onChange: (text) {
                                                context
                                                    .read<MyInfoDetailCubit>()
                                                    .changeMyWorkIntro(text);
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          ObjectTextDefaultFrame(
                                            title: "나의 가족 소개",
                                            body: DefaultField(
                                              hintText: "최소 10자~최대200자",
                                              showCount: true,
                                              maxLine: 4,
                                              textLimit: 200,
                                              onError: state.disabledFamily,
                                              guideText: state.disabledFamily
                                                  ? "최소 10자 ~ 최대 200자"
                                                  : "",
                                              initialValue: state.myFamilyIntro,
                                              onChange: (text) {
                                                context
                                                    .read<MyInfoDetailCubit>()
                                                    .changeMyFamilyIntro(text);
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          ObjectTextDefaultFrame(
                                            title: "나만의 힐링법",
                                            body: DefaultField(
                                              hintText: "최소 10자~최대200자",
                                              textLimit: 200,
                                              maxLine: 4,
                                              initialValue: state.myHealing,
                                              onError: state.disabledMyHealing,
                                              showCount: true,
                                              guideText: state.disabledMyHealing
                                                  ? "최소 10자 ~ 최대 200자"
                                                  : "",
                                              onChange: (text) {
                                                context
                                                    .read<MyInfoDetailCubit>()
                                                    .changeMyHealing(text);
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          ObjectTextDefaultFrame(
                                            title: "미래 배우자에게 한마디",
                                            body: DefaultField(
                                              hintText: "최소 10자~최대200자",
                                              showCount: true,
                                              maxLine: 4,
                                              textLimit: 200,
                                              onError: state.disabledToPartner,
                                              guideText: state.disabledToPartner
                                                  ? "최소 10자 ~ 최대 200자"
                                                  : "",
                                              initialValue:
                                                  state.myVoiceToLover,
                                              onChange: (text) {
                                                context
                                                    .read<MyInfoDetailCubit>()
                                                    .changeMyVoiceToLover(text);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context)
                                              .padding
                                              .bottom +
                                          20,
                                    )
                                  ],
                                ),
                              ]),
                        ),
                      ),
                    )
                  : Container(),
            );
          },
        ),
      ),
    );
  }

  _image(String url) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white)),
        clipBehavior: Clip.antiAlias,
        child: CacheImage(
          url: url,
          boxFit: BoxFit.cover,
        ),
      ),
    );
  }
}
