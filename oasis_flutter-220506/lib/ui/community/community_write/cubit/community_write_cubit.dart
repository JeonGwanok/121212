import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/bloc/community/bloc.dart';
import 'package:oasis/enum/community/community.dart';
import 'package:oasis/model/community/community.dart';
import 'package:oasis/model/community/community_write.dart';
import 'package:oasis/repository/community_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/community/community_write/cubit/community_write_state.dart';
import 'package:oasis/util/text_filter.dart';

class CommunityWriteCubit extends Cubit<CommunityWriteState> {
  final CommunitySubType subType;
  final UserRepository userRepository;
  final CommunityBloc communityBloc;
  final CommunityRepository communityRepository;
  final CommunityDetail? editItem;

  CommunityWriteCubit({
    required this.subType,
    required this.userRepository,
    required this.communityBloc,
    required this.communityRepository,
    this.editItem,
  }) : super(CommunityWriteState());

  initialize(CommunitySubType initialSubType) {
    emit(state.copyWith(
      subType: initialSubType,
      title: editItem?.title,
      info: editItem?.info,
      url: editItem?.url,
      content: editItem?.content,
      hashTags: editItem?.hashTag,
      editImage1: (editItem?.image != null &&
              editItem!.image!.isNotEmpty &&
              editItem!.image!.length >= 1)
          ? editItem!.image!.first
          : null,
      editImage2: (editItem?.image != null &&
              editItem!.image!.isNotEmpty &&
              editItem!.image!.length >= 2)
          ? editItem!.image![1]
          : null,
      editImage3: (editItem?.image != null &&
              editItem!.image!.isNotEmpty &&
              editItem!.image!.length >= 3)
          ? editItem!.image![2]
          : null,
      editImage4: (editItem?.image != null &&
              editItem!.image!.isNotEmpty &&
              editItem!.image!.length >= 4)
          ? editItem!.image![3]
          : null,
      editImage5: (editItem?.image != null &&
              editItem!.image!.isNotEmpty &&
              editItem!.image!.length >= 5)
          ? editItem!.image![4]
          : null,
    ));
  }

  changeSubType(CommunitySubType subType) {
    emit(state.copyWith(subType: subType));
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

  enterInfo(String info) {
    emit(state.copyWith(info: info));
  }

  enterUrl(String url) {
    emit(state.copyWith(url: url));
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

  save() async {
    emit(state.copyWith(status: CommunityWriteStatus.loading));
    var hasSlang = false;
    for (var item in textFilter) {
      if (state.title.contains(item) ||
          state.content.contains(item) ||
          state.info.contains(item)) {
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
      emit(state.copyWith(status: CommunityWriteStatus.hasSlang));
    } else {
      try {
        var user = await userRepository.getUser();
        CommunityWrite result = CommunityWrite(
          topic: state.subType!,
          info: state.info,
          url: state.url,
          title: state.title,
          content: state.content,
          hashTags: state.hashTags,
        );

        var payload = "";
        switch (this.subType.parent) {
          case CommunityType.stylist:
          case CommunityType.date:
            payload = result.infoToPayload();
            break;
          case CommunityType.love:
          case CommunityType.marry:
            payload = result.contentToPayload();
            break;
        }

        if (editItem == null) {
          await communityRepository.uploadCommunity(
            image1: state.image1,
            image2: state.image2,
            image3: state.image3,
            image4: state.image4,
            image5: state.image5,
            type: state.subType!,
            payload: payload,
            customerId: user.customer!.id!,
          );
        } else {
          if (state.editImage1.id != null &&
              (state.editImage1.image ?? "").isEmpty) {
            await communityRepository.deleteImage(
                imageId: state.editImage1.id!);
          }

          if (state.editImage2.id != null &&
              (state.editImage2.image ?? "").isEmpty) {
            await communityRepository.deleteImage(
                imageId: state.editImage2.id!);
          }

          if (state.editImage3.id != null &&
              (state.editImage3.image ?? "").isEmpty) {
            await communityRepository.deleteImage(
                imageId: state.editImage3.id!);
          }

          if (state.editImage4.id != null &&
              (state.editImage4.image ?? "").isEmpty) {
            await communityRepository.deleteImage(
                imageId: state.editImage4.id!);
          }

          if (state.editImage5.id != null &&
              (state.editImage5.image ?? "").isEmpty) {
            await communityRepository.deleteImage(
                imageId: state.editImage5.id!);
          }

          await communityRepository.updateCommunity(
            image1: state.image1,
            image2: state.image2,
            image3: state.image3,
            image4: state.image4,
            image5: state.image5,
            type: state.subType!,
            payload: payload,
            communityId: editItem!.id!,
          );
        }

        communityBloc.add(CommunityUpdate());
        emit(state.copyWith(status: CommunityWriteStatus.success));
      } on ApiClientException catch (err) {
        emit(state.copyWith(status: CommunityWriteStatus.fail));
      } catch (err) {
        emit(state.copyWith(status: CommunityWriteStatus.fail));
      }
    }
  }
}
