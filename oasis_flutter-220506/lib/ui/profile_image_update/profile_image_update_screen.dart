import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/cache_image.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/showBottomSheet.dart';
import 'package:oasis/ui/common/snack_bar.dart';
import 'package:oasis/ui/profile_image_update/cubit/profile_image_update_state.dart';
import 'package:oasis/ui/theme.dart';

import 'cubit/profile_image_update_cubit.dart';

enum RegisterPhotoPageType { signUp, edit }

class RegisterPhotoPage extends StatefulWidget {
  final RegisterPhotoPageType type;
  RegisterPhotoPage({this.type = RegisterPhotoPageType.signUp});
  @override
  _RegisterPhotoPageState createState() => _RegisterPhotoPageState();
}

class _RegisterPhotoPageState extends State<RegisterPhotoPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ProfileImageUpdateCubit(
        userRepository: context.read<UserRepository>(),
        commonRepository: context.read<CommonRepository>(),
      )..initialize(),
      child: BlocListener<ProfileImageUpdateCubit, ProfileImageUpdateState>(
        listener: (context, state) {
          if (state.status == ScreenStatus.success) {
            Navigator.pop(
                context, state.user.image); // pop 되면서 방금 업데이트 된 사진이 전달 됨
          }
        },
        child: BlocBuilder<ProfileImageUpdateCubit, ProfileImageUpdateState>(
          builder: (context, state) {
            var ratio = MediaQuery.of(context).size.height / 896;
            return BaseScaffold(
              title: widget.type == RegisterPhotoPageType.edit ? "" : "회원가입",
              showAppbarUnderline: widget.type != RegisterPhotoPageType.edit,
              onLoading: state.status == ScreenStatus.loading,
              onBack: () {
                if (widget.type == RegisterPhotoPageType.edit) {
                  DefaultDialog.show(context, title: "수정을 취소하시겠습니까?",
                      onTap: () {
                    Navigator.pop(context);
                  });
                } else {
                  Navigator.pop(context);
                }
              },
              buttons: [
                BaseScaffoldDefaultButtonScheme(
                  title: widget.type == RegisterPhotoPageType.edit
                      ? "수정하기"
                      : "제출하기",
                  onTap: () {
                    if (((state.user.image?.representative1 ?? "").isNotEmpty ||
                            (state.representative1?.path ?? "").isNotEmpty) &&
                        ((state.user.image?.representative2 ?? "").isNotEmpty ||
                            (state.representative2?.path ?? "").isNotEmpty)) {
                      context.read<ProfileImageUpdateCubit>().save();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        snackBar(context, "대표사진 2장을 필수로 제출하셔야합니다."),
                      );
                    }
                  },
                ),
              ],
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 18 / ratio),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 10 * ratio),
                        Row(
                          children: [
                            Expanded(
                                child: _image(
                              title: "대표사진(필수)",
                              file: state.representative1,
                              image: state.user.image?.representative1,
                              onCancel: () {
                                context
                                    .read<ProfileImageUpdateCubit>()
                                    .cancelImage("representative1");
                              },
                              onTap: () async {
                                await _picker(context, 'representative1');
                              },
                            )),
                            SizedBox(width: 12),
                            Expanded(
                                child: _image(
                              title: "대표사진(필수)",
                              file: state.representative2,
                              image: state.user.image?.representative2,
                              onCancel: () {
                                context
                                    .read<ProfileImageUpdateCubit>()
                                    .cancelImage("representative2");
                              },
                              onTap: () async {
                                await _picker(context, 'representative2');
                              },
                            )),
                          ],
                        ),
                        SizedBox(height: 8 * ratio),
                        Row(
                          children: [
                            Expanded(
                                child: _image(
                              title: "얼굴 사진",
                              file: state.face1,
                              image: state.user.image?.face1,
                              onCancel: () {
                                context
                                    .read<ProfileImageUpdateCubit>()
                                    .cancelImage("face1");
                              },
                              onTap: () async {
                                await _picker(context, 'face1');
                              },
                            )),
                            SizedBox(width: 11),
                            Expanded(
                                child: _image(
                              title: "얼굴 사진",
                              file: state.face2,
                              image: state.user.image?.face2,
                              onCancel: () {
                                context
                                    .read<ProfileImageUpdateCubit>()
                                    .cancelImage("face2");
                              },
                              onTap: () async {
                                await _picker(context, 'face2');
                              },
                            )),
                            SizedBox(width: 11),
                            Expanded(
                                child: _image(
                              title: "본인 자유사진",
                              file: state.free,
                              image: state.user.image?.free,
                              onCancel: () {
                                context
                                    .read<ProfileImageUpdateCubit>()
                                    .cancelImage("free'");
                              },
                              onTap: () async {
                                await _picker(context, 'free');
                              },
                            )),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8 * ratio),
                    _description()
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _image({
    required String title,
    required Function onTap,
    required Function onCancel,
    required File? file,
    required String? image,
  }) {
    var ratio = MediaQuery.of(context).size.height / 896;

    Widget _image = Container();

    if ((file?.path ?? "").isNotEmpty) {
      _image = Image.file(
        file!,
        fit: BoxFit.cover,
      );
    } else if ((image ?? "").isNotEmpty) {
      _image = CacheImage(
        url: image!,
        boxFit: BoxFit.cover,
      );
    }

    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: AspectRatio(
        aspectRatio: 1.0,
        child: (image ?? "").isEmpty && (file?.path ?? "").isEmpty
            ? Container(
                color: Colors.white,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: gray300),
                          borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: CustomIcon(
                        width: 30,
                        height: 30,
                        path: "icons/big_plus",
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 18 * ratio),
                      child: Text(
                        title,
                        style: header03.copyWith(color: gray400),
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: _image,
                    ),
                    GestureDetector(
                      onTap: () {
                        onCancel();
                      },
                      child: Container(
                        margin: EdgeInsets.all(4),
                        width: 23,
                        height: 23,
                        child: CustomIcon(path: "icons/circleCancel"),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  _picker(BuildContext context, String imageId) async {
    var cameraType = await showBottomOptionWithCancelSheet(context,
        title: "사진 올리기",
        minChildSize: (250 + MediaQuery.of(context).padding.bottom) /
            MediaQuery.of(context).size.height,
        items: ["나의 앨범", "카메라 촬영", "취소"],
        labels: ["나의 앨범", "카메라 촬영", "취소"]);

    if (cameraType != null && cameraType != "취소") {
      var selected = await _pickImage(
          cameraType == "나의 앨범" ? ImageSource.gallery : ImageSource.camera);
      if (selected != null) {
        context.read<ProfileImageUpdateCubit>().uploadImage(imageId, selected);
      }
    }
  }

  _description() {
    var ratio = MediaQuery.of(context).size.height / 896;

    return Container(
      height: 280 * ratio,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      margin: EdgeInsets.only(bottom: 20 * ratio),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: red400),
        color: Colors.white,
        boxShadow: cardShadow,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIcon(
                  path: "icons/alert",
                  color: Colors.red,
                ),
                SizedBox(width: 3),
                Text(
                  '주의해주세요!',
                  style: header02.copyWith(color: red500),
                ),
              ],
            ),
            SizedBox(height: 10 * ratio),
            Text(
              '* 심사 후 반려시 가입이 취소 될 수 있습니다.\n* 마스크나 가려진 사진은 ‘본인 자유사진’에 올려주세요.',
              style: body01.copyWith(color: gray600),
            ),
            SizedBox(height: 15 * ratio),
            Text('[등록 불가 사진]', style: header03.copyWith(color: gray600)),
            Text('* 가려진 얼굴, 과도한표정, 비슷한 사진, 노출사진\n* 단체사진, 과한효과, 오래된사진, 비호감 사진',
                style: body01.copyWith(color: gray600)),
            SizedBox(height: 15 * ratio),
            Text('[유의사항]', style: header03.copyWith(color: gray600)),
            Text('* 사진의 품질이 떨어지는 사진의 경우 등록이 되지 않고, 재요청이 있을 수 있습니다.',
                style: body01.copyWith(color: gray600)),
          ],
        ),
      ),
    );
  }

  _pickImage(ImageSource source) async {
    try {
      XFile? image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 100,
        maxWidth: 500,
      );
      if (image != null) {
        var result = File(image.path);
        return result;
      } else {
        return null;
      }
    } catch (err) {
      print('사진 못가져오는 이슈 $err');
    }
  }
}
