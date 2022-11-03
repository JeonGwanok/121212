import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oasis/bloc/community/bloc.dart';
import 'package:oasis/enum/community/community.dart';
import 'package:oasis/model/community/community.dart';
import 'package:oasis/repository/community_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/cache_image.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/common/showBottomSheet.dart';
import 'package:oasis/ui/common/write/tag_field.dart';
import 'package:oasis/ui/common/write/write_alert_screen.dart';
import 'package:oasis/ui/community/community_write/cubit/community_write_state.dart';

import '../../theme.dart';
import 'cubit/community_write_cubit.dart';

class CommunityWriteScreen extends StatefulWidget {
  final BuildContext communityContext;
  final CommunityDetail? editItem;
  final CommunitySubType type;
  CommunityWriteScreen(
      {required this.communityContext, this.editItem, required this.type});
  @override
  _CommunityWriteScreenState createState() => _CommunityWriteScreenState();
}

class _CommunityWriteScreenState extends State<CommunityWriteScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false, // set to false
          pageBuilder: (_, __, ___) => WriteAlertScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var ratio = MediaQuery.of(context).size.width / 414;
    return BlocProvider(
      create: (BuildContext context) => CommunityWriteCubit(
        userRepository: context.read<UserRepository>(),
        communityBloc: widget.communityContext.read<CommunityBloc>(),
        communityRepository: context.read<CommunityRepository>(),
        editItem: widget.editItem,
        subType: widget.type,
      )..initialize(widget.type),
      child: BlocListener<CommunityWriteCubit, CommunityWriteState>(
        listener: (context, state) {
          if (state.status == CommunityWriteStatus.success) {
            Navigator.pop(context);
          }

          if (state.status == CommunityWriteStatus.hasSlang) {
            DefaultDialog.show(context,
                title: "비속어를 포함할 수 없습니다.", defaultButtonTitle: "확인");
          }
        },
        listenWhen: (pre, cur) => pre.status != cur.status,
        child: BlocBuilder<CommunityWriteCubit, CommunityWriteState>(
          builder: (context, state) {
            return BaseScaffold(
              title: "",
              onLoading: state.status == CommunityWriteStatus.loading,
              backgroundColor: backgroundColor,
              resizeToAvoidBottomInset: true,
              onBack: () {
                Navigator.pop(context);
              },
              buttons: [
                BaseScaffoldDefaultButtonScheme(
                  title: "글 올리기",
                  onTap: state.buttonEnable
                      ? () {
                          context.read<CommunityWriteCubit>().save();
                        }
                      : null,
                )
              ],
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 23),
                      _title(),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          ...widget.type.parent.subs
                              .asMap()
                              .map(
                                (i, e) => MapEntry(
                                  i,
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: i != 0 ? 10 * ratio : 0),
                                      child: DefaultSmallButton(
                                        horizontalPadding: 0,
                                        reverse: state.subType != e,
                                        title: e.title
                                            .substring(0, e.title.length - 3),
                                        onTap: () {
                                          context
                                              .read<CommunityWriteCubit>()
                                              .changeSubType(e);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .values
                              .toList()
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: [
                          if (widget.type.parent == CommunityType.marry ||
                              widget.type.parent == CommunityType.love)
                            _objectFrame(
                              title: "제목",
                              child: DefaultField(
                                hintText: "제목을 적어주세요.",
                                initialValue: state.title,
                                backgroundColor: Colors.white,
                                onChange: (text) {
                                  context
                                      .read<CommunityWriteCubit>()
                                      .enterTitle(text);
                                },
                              ),
                            ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Column(children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _imageButton(
                                        file: state.image1,
                                        editImage: state.editImage1.image ?? "",
                                        onCancel: () {
                                          context
                                              .read<CommunityWriteCubit>()
                                              .cancelImage1();
                                        },
                                        onChange: (file) {
                                          context
                                              .read<CommunityWriteCubit>()
                                              .enterImage1(file);
                                        }),
                                  ),
                                  SizedBox(width: 11),
                                  Expanded(
                                    child: _imageButton(
                                        file: state.image2,
                                        editImage: state.editImage2.image ?? "",
                                        onCancel: () {
                                          context
                                              .read<CommunityWriteCubit>()
                                              .cancelImage2();
                                        },
                                        onChange: (file) {
                                          context
                                              .read<CommunityWriteCubit>()
                                              .enterImage2(file);
                                        }),
                                  ),
                                ],
                              ),
                              SizedBox(height: 11),
                              Row(
                                children: [
                                  Expanded(
                                    child: _imageButton(
                                        editImage: state.editImage3.image ?? "",
                                        file: state.image3,
                                        onCancel: () {
                                          context
                                              .read<CommunityWriteCubit>()
                                              .cancelImage3();
                                        },
                                        onChange: (file) {
                                          context
                                              .read<CommunityWriteCubit>()
                                              .enterImage3(file);
                                        }),
                                  ),
                                  SizedBox(width: 11),
                                  Expanded(
                                    child: _imageButton(
                                        editImage: state.editImage4.image ?? "",
                                        file: state.image4,
                                        onCancel: () {
                                          context
                                              .read<CommunityWriteCubit>()
                                              .cancelImage4();
                                        },
                                        onChange: (file) {
                                          context
                                              .read<CommunityWriteCubit>()
                                              .enterImage4(file);
                                        }),
                                  ),
                                  SizedBox(width: 11),
                                  Expanded(
                                    child: _imageButton(
                                        editImage: state.editImage5.image ?? "",
                                        file: state.image5,
                                        onCancel: () {
                                          context
                                              .read<CommunityWriteCubit>()
                                              .cancelImage5();
                                        },
                                        onChange: (file) {
                                          context
                                              .read<CommunityWriteCubit>()
                                              .enterImage5(file);
                                        }),
                                  ),
                                ],
                              )
                            ]),
                          ),
                          if (widget.type.parent == CommunityType.marry ||
                              widget.type.parent == CommunityType.love)
                            _objectFrame(
                              title: "내용",
                              child: Column(
                                children: [
                                  DefaultField(
                                    maxLine: 5,
                                    showCancelButton: false,
                                    initialValue: state.content,
                                    hintText: "내용을 적어주세요.",
                                    backgroundColor: Colors.white,
                                    onChange: (text) {
                                      context
                                          .read<CommunityWriteCubit>()
                                          .enterContent(text);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          if (widget.type.parent == CommunityType.date ||
                              widget.type.parent == CommunityType.stylist)
                            _objectFrame(
                              title: widget.type.parent == CommunityType.stylist
                                  ? "구매정보"
                                  : "장소정보",
                              child: Column(
                                children: [
                                  DefaultField(
                                    maxLine: 1,
                                    showCancelButton: false,
                                    initialValue: state.info,
                                    hintText: widget.type.parent ==
                                            CommunityType.stylist
                                        ? "구매처, 가격 등을 자유롭게 적어주세요."
                                        : "장소, 가격, 추천 메뉴 등을 자유롭게 적어주세요.",
                                    backgroundColor: Colors.white,
                                    onChange: (text) {
                                      context
                                          .read<CommunityWriteCubit>()
                                          .enterInfo(text);
                                    },
                                  ),
                                ],
                              ),
                            ),

                          _objectFrame(
                            title: "URL",
                            child: Column(
                              children: [
                                DefaultField(
                                  maxLine: 1,
                                  showCancelButton: false,
                                  initialValue: state.url,
                                  hintText: "링크를 입력해주세요.",
                                  backgroundColor: Colors.white,
                                  onChange: (text) {
                                    context
                                        .read<CommunityWriteCubit>()
                                        .enterUrl(text);
                                  },
                                ),
                              ],
                            ),
                          ),
                          _objectFrame(
                            title: "태그",
                            child: tagField(
                              tags: state.hashTags,
                              onAdd: (tag) {
                                context.read<CommunityWriteCubit>().addTag(tag);
                              },
                              onDelete: (tag) {
                                context
                                    .read<CommunityWriteCubit>()
                                    .removeTag(tag);
                              },
                              onErr: () {},
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom + 30,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _objectFrame({required String title, required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: body03.copyWith(color: gray900),
          ),
          SizedBox(height: 8),
          child
        ],
      ),
    );
  }

  _imageButton({
    required File? file,
    required String? editImage,
    required Function(File) onChange,
    required Function onCancel,
  }) {
    Widget _image = Container();

    if ((file?.path ?? "").isNotEmpty) {
      _image = Image.file(
        file!,
        fit: BoxFit.cover,
      );
    } else if ((editImage ?? "").isNotEmpty) {
      _image = CacheImage(
        url: editImage ?? "",
        boxFit: BoxFit.cover,
      );
    }

    return GestureDetector(
      onTap: () async {
        await _picker(context, (file) {
          onChange(file);
        });
      },
      child: AspectRatio(
        aspectRatio: 1.0,
        child: (editImage ?? "").isEmpty && (file?.path ?? "").isEmpty
            ? Container(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: gray300),
                      borderRadius: BorderRadius.circular(8)),
                  alignment: Alignment.center,
                  child: CustomIcon(
                    width: 30,
                    height: 30,
                    path: "icons/big_plus",
                  ),
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

  _picker(BuildContext context, Function(File) onChange) async {
    var cameraType = await showBottomOptionWithCancelSheet(context,
        title: "사진 올리기",
        minChildSize: (270 + MediaQuery.of(context).padding.bottom) /
            MediaQuery.of(context).size.height,
        items: ["나의 앨범", "카메라 촬영", "취소"],
        labels: ["나의 앨범", "카메라 촬영", "취소"]);

    if (cameraType != null && cameraType != "취소") {
      var selected = await _pickImage(
          cameraType == "나의 앨범" ? ImageSource.gallery : ImageSource.camera);
      if (selected != null) {
        onChange(selected);
      }
    }
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

  // 공개
  _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.type.parent.writeTitle,
          style: header02.copyWith(
            fontFamily: "Godo",
            color: darkBlue,
          ),
        ),
        // Container(
        //   width: 44,
        //   height: 24,
        //   alignment: Alignment.center,
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     boxShadow: cardShadow,
        //     borderRadius: BorderRadius.circular(8),
        //   ),
        //   // child: CustomIcon(
        //   //   path: "icons/big_plus",
        //   //   color: mainMint,
        //   //   width: 20,
        //   //   height: 20,
        //   // ),
        // ),
      ],
    );
  }
}
