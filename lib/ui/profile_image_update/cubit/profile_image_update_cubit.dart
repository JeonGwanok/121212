import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/profile_image_update/cubit/profile_image_update_state.dart';

class ProfileImageUpdateCubit extends Cubit<ProfileImageUpdateState> {
  final UserRepository userRepository;
  final CommonRepository commonRepository;

  ProfileImageUpdateCubit({
    required this.userRepository,
    required this.commonRepository,
  }) : super(ProfileImageUpdateState());

  initialize() async {
    var user = await userRepository.getUser();
    emit(state.copyWith(user: user));
  }

  uploadImage(String profileImageId, File file) async {
    if (profileImageId == "representative1") {
      emit(state.copyWith(representative1: file));
    } else if (profileImageId == "representative2") {
      emit(state.copyWith(representative2: file));
    } else if (profileImageId == "face1") {
      emit(state.copyWith(face1: file));
    } else if (profileImageId == "face2") {
      emit(state.copyWith(face2: file));
    } else if (profileImageId == "free") {
      emit(state.copyWith(free: file));
    }
  }

  cancelImage(String profileImageId) async {
    var userImage = state.user.image;
    if (profileImageId == "representative1") {
      userImage = userImage?.copyWith(representative1: "");
      emit(state.copyWith(
          representative1: File(""),
          user: state.user.copyWith(image: userImage)));
    } else if (profileImageId == "representative2") {
      userImage = userImage?.copyWith(representative2: "");
      emit(state.copyWith(
          representative2: File(""),
          user: state.user.copyWith(image: userImage)));
    } else if (profileImageId == "face1") {
      userImage = userImage?.copyWith(face1: "");
      emit(state.copyWith(
          face1: File(""), user: state.user.copyWith(image: userImage)));
    } else if (profileImageId == "face2") {
      userImage = userImage?.copyWith(face2: "");
      emit(state.copyWith(
          face2: File(""), user: state.user.copyWith(image: userImage)));
    } else if (profileImageId == "free") {
      userImage = userImage?.copyWith(free: "");
      emit(state.copyWith(
          free: File(""), user: state.user.copyWith(image: userImage)));
    }
  }

  save() async {
    emit(state.copyWith(status: ScreenStatus.loading));
    var imageId = "${state.user.image!.id}";
    try {
      // 널이면 아무일도 일어나지 않고,
      // "" 이면 삭제
      // 뭔가 있으면 업로드

      if (state.representative1 != null) {
        if ((state.representative1!.path.isEmpty)) {
          await userRepository.deleteImage("representative1", imageId);
        } else {
          await userRepository.uploadImage(
              "representative1", imageId, state.representative1!);
        }
      }

      if (state.representative2 != null) {
        if ((state.representative2!.path.isEmpty)) {
          await userRepository.deleteImage("representative2", imageId);
        } else {
          await userRepository.uploadImage(
              "representative2", imageId, state.representative2!);
        }
      }

      if (state.free != null) {
        if ((state.free!.path.isEmpty)) {
          await userRepository.deleteImage("free", imageId);
        } else {
          await userRepository.uploadImage(
              "free", imageId, state.free!);
        }
      }

      if (state.face1 != null) {
        if ((state.face1!.path.isEmpty)) {
          await userRepository.deleteImage("face1", imageId);
        } else {
          await userRepository.uploadImage(
              "face1", imageId, state.face1!);
        }
      }

      if (state.face2 != null) {
        if ((state.face2!.path.isEmpty)) {
          await userRepository.deleteImage("face2", imageId);
        } else {
          await userRepository.uploadImage(
              "face2", imageId, state.face2!);
        }
      }

      var user = await userRepository.getUser();
      emit(state.copyWith(user: user, status: ScreenStatus.success));
    } catch (err) {
      print('실패입니다. $err');
    }
  }
}
