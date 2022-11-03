import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/bloc/my_story/bloc.dart';
import 'package:oasis/enum/my_story/my_story.dart';
import 'package:oasis/model/my_story/my_story.dart';
import 'package:oasis/model/my_story/my_story_write.dart';
import 'package:oasis/repository/my_story_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/util/text_filter.dart';

import 'my_story_write_state.dart';

class MyStoryWriteCubit extends Cubit<MyStoryWriteState> {
  final UserRepository userRepository;
  final MyStoryBloc myStoryBloc;
  final MyStory? editItem;
  final MyStoryRepository myStoryRepository;

  MyStoryWriteCubit({
    required this.userRepository,
    required this.myStoryBloc,
    this.editItem,
    required this.myStoryRepository,
  }) : super(MyStoryWriteState());

  initialize() {
    emit(state.copyWith(
      status: MyStoryWriteStatus.loaded,
      title: editItem?.title,
      content: editItem?.content,
      hashTags: editItem?.hashTag,
      publicStatus: editItem?.publicStatus,
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

  enterImage4(File image) {
    emit(state.copyWith(image4: image));
  }

  enterImage5(File image) {
    emit(state.copyWith(image5: image));
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
        image3: File(""), editImage3: state.editImage3.copyWith(image: "")));
  }

  cancelImage4() {
    emit(state.copyWith(
        image4: File(""), editImage4: state.editImage4.copyWith(image: "")));
  }

  cancelImage5() {
    emit(state.copyWith(
        image5: File(""), editImage5: state.editImage5.copyWith(image: "")));
  }

  changePublic(bool onPublic) {
    emit(state.copyWith(publicStatus: onPublic));
  }

  save() async {
    emit(state.copyWith(status: MyStoryWriteStatus.loading));
    var hasSlang = false;
    for (var item in textFilter) {
      if (state.title.contains(item) || state.content.contains(item)) {
        hasSlang = true;
        break;
      }
    }

    // 해쉬테그에 포함
    if (!hasSlang) {
      for (var item in state.hashTags) {
        for (var slang in textFilter) {
          if (item.contains(slang)) {
            hasSlang = true;
            break;
          }
        }
        if (hasSlang) {
          break;
        }
      }
    }

    if (hasSlang) {
      emit(state.copyWith(status: MyStoryWriteStatus.hasSlang));
    } else {
      try {
        var user = await userRepository.getUser();
        MyStoryWrite result = MyStoryWrite(
          title: state.title,
          content: state.content,
          publicStatus: state.publicStatus,
          hashTags: state.hashTags,
        );

        var payload = result.toDailyPayload();
        if (editItem == null) {
          await myStoryRepository.uploadMyStory(
            image1: state.image1,
            image2: state.image2,
            image3: state.image3,
            image4: state.image4,
            image5: state.image5,
            type: MyStoryType.daily,
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

          if (state.editImage4.id != null &&
              (state.editImage4.image ?? "").isEmpty) {
            await myStoryRepository.deleteImage(imageId: state.editImage4.id!);
          }

          if (state.editImage5.id != null &&
              (state.editImage5.image ?? "").isEmpty) {
            await myStoryRepository.deleteImage(imageId: state.editImage5.id!);
          }

          await myStoryRepository.updateMyStory(
            image1: state.image1,
            image2: state.image2,
            image3: state.image3,
            image4: state.image4,
            image5: state.image5,
            payload: payload,
            myStoryId: editItem!.id!,
          );
        }
        myStoryBloc.add(MyStoryUpdate());
        emit(state.copyWith(status: MyStoryWriteStatus.success));
      } on ApiClientException catch (err) {
        emit(state.copyWith(status: MyStoryWriteStatus.fail));
      } catch (err) {
        emit(state.copyWith(status: MyStoryWriteStatus.fail));
      }
    }
  }
}
