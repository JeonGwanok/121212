import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oasis/bloc/my_story/bloc.dart';
import 'package:oasis/enum/my_story/my_story.dart';
import 'package:oasis/model/my_story/my_story.dart';
import 'package:oasis/repository/my_story_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/cache_image.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/common/on_off_switcher.dart';
import 'package:oasis/ui/common/showBottomSheet.dart';
import 'package:oasis/ui/common/write/tag_field.dart';
import 'package:oasis/ui/common/write/write_alert_screen.dart';
import 'package:oasis/ui/my_story/my_story_write/cubit/my_story_write_state.dart';

import '../../theme.dart';
import 'cubit/my_story_write_cubit.dart';

class MyStoryWriteScreen extends StatefulWidget {
  final BuildContext myStoryContext;
  final MyStory? editItem;
  MyStoryWriteScreen({
    required this.myStoryContext,
    this.editItem,
  });
  @override
  _MyStoryWriteScreenState createState() => _MyStoryWriteScreenState();
}

class _MyStoryWriteScreenState extends State<MyStoryWriteScreen> {
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
    return BlocProvider(
      create: (BuildContext context) => MyStoryWriteCubit(
        userRepository: context.read<UserRepository>(),
        myStoryBloc: widget.myStoryContext.read<MyStoryBloc>(),
        editItem: widget.editItem,
        myStoryRepository: context.read<MyStoryRepository>(),
      )..initialize(),
      child: BlocListener<MyStoryWriteCubit, MyStoryWriteState>(
        listener: (context, state) {
          if (state.status == MyStoryWriteStatus.success) {
            Navigator.pop(context);
          }
          if (state.status == MyStoryWriteStatus.hasSlang) {
            DefaultDialog.show(context,
                title: "비속어를 포함할 수 없습니다.", defaultButtonTitle: "확인");
          }
        },
        listenWhen: (pre, cur) => pre.status != cur.status,
        child: BlocBuilder<MyStoryWriteCubit, MyStoryWriteState>(
          builder: (context, state) {
            return BaseScaffold(
              title: "",
              backgroundColor: backgroundColor,
              onLoading: state.status == MyStoryWriteStatus.loading,
              resizeToAvoidBottomInset: true,
              onBack: () {
                Navigator.pop(context);
              },
              buttons: [
                BaseScaffoldDefaultButtonScheme(
                  title: "공유하기",
                  onTap: state.buttonEnable
                      ? () {
                          context.read<MyStoryWriteCubit>().save();
                        }
                      : null,
                )
              ],
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 23),
                    _title(
                      onPublic: state.publicStatus,
                      onChanged: (result) {
                        context.read<MyStoryWriteCubit>().changePublic(result);
                      },
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
                                initialValue: state.title,
                                backgroundColor: Colors.white,
                                onChange: (text) {
                                  context
                                      .read<MyStoryWriteCubit>()
                                      .enterTitle(text);
                                },
                              ),
                            ),
                            _objectFrame(
                              title: "내용",
                              child: Column(
                                children: [
                                  DefaultField(
                                    maxLine: 5,
                                    initialValue: state.content,
                                    showCancelButton: false,
                                    hintText: "내용을 적어주세요.",
                                    backgroundColor: Colors.white,
                                    onChange: (text) {
                                      context
                                          .read<MyStoryWriteCubit>()
                                          .enterContent(text);
                                    },
                                  ),
                                  SizedBox(height: 12),
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
                                                      .read<MyStoryWriteCubit>()
                                                      .cancelImage1();
                                                },
                                                onChange: (file) {
                                                  context
                                                      .read<MyStoryWriteCubit>()
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
                                                      .read<MyStoryWriteCubit>()
                                                      .cancelImage2();
                                                },
                                                onChange: (file) {
                                                  context
                                                      .read<MyStoryWriteCubit>()
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
                                                      .read<MyStoryWriteCubit>()
                                                      .cancelImage3();
                                                },
                                                onChange: (file) {
                                                  context
                                                      .read<MyStoryWriteCubit>()
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
                                                      .read<MyStoryWriteCubit>()
                                                      .cancelImage4();
                                                },
                                                onChange: (file) {
                                                  context
                                                      .read<MyStoryWriteCubit>()
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
                                                      .read<MyStoryWriteCubit>()
                                                      .cancelImage5();
                                                },
                                                onChange: (file) {
                                                  context
                                                      .read<MyStoryWriteCubit>()
                                                      .enterImage5(file);
                                                }),
                                          ),
                                        ],
                                      )
                                    ]),
                                  )
                                ],
                              ),
                            ),
                            _objectFrame(
                              title: "태그",
                              child: tagField(
                                tags: state.hashTags,
                                onAdd: (tag) {
                                  context.read<MyStoryWriteCubit>().addTag(tag);
                                },
                                onDelete: (tag) {
                                  context
                                      .read<MyStoryWriteCubit>()
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
                  decoration: BoxDecoration(  color: Colors.white,
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
  _title({required bool onPublic, required Function(bool) onChanged}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          MyStoryType.daily.title,
          style: header02.copyWith(
            fontFamily: "Godo",
            color: darkBlue,
          ),
        ),
        Row(
          children: [
            Text(
              '공개',
              style: caption01.copyWith(color: gray400),
            ),
            SizedBox(width: 8),
            OnOffSwitch(
              value: onPublic,
              onChanged: (result) {
                onChanged(result);
              },
            ),
          ],
        ),
      ],
    );
  }
}
