import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oasis/bloc/my_story/bloc.dart';
import 'package:oasis/enum/my_story/my_story.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/my_story/my_story.dart';
import 'package:oasis/repository/my_story_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/cache_image.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/common/showBottomSheet.dart';
import 'package:oasis/ui/common/write/tag_field.dart';
import 'package:oasis/ui/couple_story/couple_story_write/cubit/couple_story_write_state.dart';

import '../../theme.dart';
import 'cubit/couple_story_write_cubit.dart';

class CoupleStoryWriteScreen extends StatefulWidget {
  final BuildContext myStoryContext;
  final MyStory? editItem;
  final MyStoryType type;
  CoupleStoryWriteScreen({
    required this.type,
    this.editItem,
    required this.myStoryContext,
  });
  @override
  _CoupleStoryWriteScreenState createState() => _CoupleStoryWriteScreenState();
}

class _CoupleStoryWriteScreenState extends State<CoupleStoryWriteScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CoupleStoryWriteCubit(
        userRepository: context.read<UserRepository>(),
        myStoryRepository: context.read<MyStoryRepository>(),
        type: widget.type,
        myStoryBloc: widget.myStoryContext.read<MyStoryBloc>(),
        editItem: widget.editItem,
      )..initialize(),
      child: BlocListener<CoupleStoryWriteCubit, CoupleStoryWriteState>(
        listener: (context, state) {
          if (state.status == ScreenStatus.success) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<CoupleStoryWriteCubit, CoupleStoryWriteState>(
          builder: (context, state) {

            return BaseScaffold(
              title: "",
              onLoading: state.status == ScreenStatus.loading,
              backgroundColor: backgroundColor,
              resizeToAvoidBottomInset: true,
              onBack: () {
                Navigator.pop(context);
              },
              buttons: [
                BaseScaffoldDefaultButtonScheme(
                  title: widget.type == MyStoryType.love
                      ? "내 연애 이야기를 들어줘"
                      : "내 결혼 이야기를 들어줘",
                  onTap: state.buttonEnable
                      ? () {
                          context.read<CoupleStoryWriteCubit>().save();
                        }
                      : null,
                )
              ],
              body:(state.status != ScreenStatus.initial) ? Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 23),
                    _title(
                      onAdd: () {},
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _objectFrame(
                              title: "제목",
                              child: DefaultField(
                                hintText: "제목을 적어주세요.",
                                backgroundColor: Colors.white,initialValue: state.title,
                                onChange: (text) {
                                  context
                                      .read<CoupleStoryWriteCubit>()
                                      .enterTitle(text);
                                },
                              ),
                            ),
                            _objectFrame(
                              title: "내용",
                              child: Column(
                                children: [
                                  DefaultField(
                                    maxLine: 5,initialValue: state.content,
                                    showCancelButton: false,
                                    hintText: "내용을 적어주세요.",
                                    backgroundColor: Colors.white,
                                    onChange: (text) {
                                      context
                                          .read<CoupleStoryWriteCubit>()
                                          .enterContent(text);
                                    },
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _imageButton(
                                            editImage: state.editImage1.image,
                                            file: state.image1,
                                            onCancel: () {
                                              context
                                                  .read<CoupleStoryWriteCubit>()
                                                  .cancelImage1();
                                            },
                                            onChange: (file) {
                                              context
                                                  .read<CoupleStoryWriteCubit>()
                                                  .enterImage1(file);
                                            }),
                                      ),
                                      SizedBox(width: 11),
                                      Expanded(
                                        child: _imageButton(
                                            editImage: state.editImage2.image,
                                            file: state.image2,
                                            onCancel: () {
                                              context
                                                  .read<CoupleStoryWriteCubit>()
                                                  .cancelImage2();
                                            },
                                            onChange: (file) {
                                              context
                                                  .read<CoupleStoryWriteCubit>()
                                                  .enterImage2(file);
                                            }),
                                      ),
                                      SizedBox(width: 11),
                                      Expanded(
                                        child: _imageButton(
                                          editImage: state.editImage3.image,
                                          file: state.image3,
                                          onCancel: () {
                                            context
                                                .read<CoupleStoryWriteCubit>()
                                                .cancelImage3();
                                          },
                                          onChange: (file) {
                                            context
                                                .read<CoupleStoryWriteCubit>()
                                                .enterImage3(file);
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            _objectFrame(
                              title: "태그",
                              child: tagField(
                                tags: state.hashTags,
                                onAdd: (tag) {
                                  context
                                      .read<CoupleStoryWriteCubit>()
                                      .addTag(tag);
                                },
                                onDelete: (tag) {
                                  context
                                      .read<CoupleStoryWriteCubit>()
                                      .removeTag(tag);
                                },
                                onErr: () {},
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).padding.bottom + 30,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ) : Container(),
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
                color: Colors.white,
                child: Container(
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
  _title({required Function onAdd}) {
    return Text(
      widget.type == MyStoryType.love ? "연애 이야기 💕" : "결혼 이야기 👩‍❤️‍👨",
      style: header02.copyWith(
        fontFamily: "Godo",
        color: darkBlue,
      ),
    );
  }
}
