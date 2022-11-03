import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/bloc/my_story/bloc.dart';
import 'package:oasis/enum/my_story/my_story.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/my_story/my_story.dart';
import 'package:oasis/model/my_story/my_story_write.dart';
import 'package:oasis/repository/my_story_repository.dart';
import 'package:oasis/repository/user_repository.dart';

import 'couple_story_write_state.dart';

class CoupleStoryWriteCubit extends Cubit<CoupleStoryWriteState> {
  final MyStoryType type;
  final MyStory? editItem;
  final UserRepository userRepository;
  final MyStoryBloc myStoryBloc;
  final MyStoryRepository myStoryRepository;

  CoupleStoryWriteCubit({
    required this.type,
    required this.editItem,
    required this.userRepository,
    required this.myStoryBloc,
    required this.myStoryRepository,
  }) : super(CoupleStoryWriteState());

  initialize() {
    emit(state.copyWith(
      status: ScreenStatus.loaded,
      title: editItem?.title,
      content: editItem?.content,
      hashTags: editItem?.hashTag,
      editImage1: (editItem?.imageList != null &&
              editItem!.imageList.isNotEmpty &&
              editItem!.imageList.length >= 1)
          ? editItem!.imageList.first
          : null,
      editImage2: (editItem?.imageList != null &&
              editItem!.imageList.isNotEmpty &&
              editItem!.imageList.length >= 2)
          ? editItem!.imageList[1]
          : null,
      editImage3: (editItem?.imageList != null &&
              editItem!.imageList.isNotEmpty &&
              editItem!.imageList.length >= 3)
          ? editItem!.imageList[2]
          : null,
    ));
  }

  enterTitle(String title) {
    emit(state.copyWith(title: title));
  }

  enterContent(String content) {
    emit(state.copyWith(content: content));
  }

  addTag(String tag) {
    var _tags = [...state.hashTags];
    _tags.add(tag);
    emit(state.copyWith(hashTags: _tags));
  }

  removeTag(String tag) {
    var _tags = [...state.hashTags];
    _tags.remove(tag);
    emit(state.copyWith(hashTags: _tags));
  }

  enterImage1(File image) {
    emit(state.copyWith(image1: image));
  }

  enterImage2(File image) {
    emit(state.copyWith(image2: image));
  }

  enterImage3(File image) {
    emit(state.copyWith(image3: image));
  }

  cancelImage1() {
    emit(state.copyWith(
        image1: File(""), editImage1: state.editImage1.copyWith(image: "")));
  }

  cancelImage2() {
    emit(state.copyWith(
        image2: File(""), editImage2: state.editImage2.copyWith(image: "")));
  }

  cancelImage3() {
    emit(state.copyWith(
        image3: File(""), editImage2: state.editImage3.copyWith(image: "")));
  }

  save() async {
    try {
      emit(state.copyWith(status: ScreenStatus.loading));
      var user = await userRepository.getUser();
      MyStoryWrite result = MyStoryWrite(
        title: state.title,
        content: state.content,
        hashTags: state.hashTags,
      );

      var payload = result.toLovePayload();
      if (editItem == null) {
        await myStoryRepository.uploadMyStory(
          image1: state.image1,
          image2: state.image2,
          image3: state.image3,
          type: type,
          payload: payload,
          customerId: user.customer!.id!,
        );
      } else {
        if (state.editImage1.id != null &&
            (state.editImage1.image ?? "").isEmpty) {
          await myStoryRepository.deleteImage(imageId: state.editImage1.id!);
        }

        if (state.editImage2.id != null &&
            (state.editImage2.image ?? "").isEmpty) {
          await myStoryRepository.deleteImage(imageId: state.editImage2.id!);
        }

        if (state.editImage3.id != null &&
            (state.editImage3.image ?? "").isEmpty) {
          await myStoryRepository.deleteImage(imageId: state.editImage3.id!);
        }

        await myStoryRepository.updateMyStory(
          image1: state.image1,
          image2: state.image2,
          image3: state.image3,
          payload: payload,
          myStoryId: editItem!.id!,
        );
      }
      myStoryBloc.add(MyStoryUpdate());
      emit(state.copyWith(status: ScreenStatus.success));
    } on ApiClientException catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }
}
