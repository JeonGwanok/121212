import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:oasis/enum/community/community.dart';
import 'package:oasis/model/image_model.dart';

enum CommunityWriteStatus {
  initial,
  loaded,
  loading,
  fail,
  success,
  refresh,
  hasSlang
}

class CommunityWriteState extends Equatable {
  final CommunityWriteStatus status;
  final CommunitySubType? subType;

  final String title;
  final String info;
  final String content;
  final String url;

  final List<String> hashTags;

  final File? image1;
  final File? image2;
  final File? image3;
  final File? image4;
  final File? image5;

  final PostingImageList editImage1;
  final PostingImageList editImage2;
  final PostingImageList editImage3;
  final PostingImageList editImage4;
  final PostingImageList editImage5;

  CommunityWriteState({
    this.status = CommunityWriteStatus.initial,
    this.subType,
    this.title = "",
    this.info = "",
    this.url = "",
    this.content = "",
    this.hashTags = const [],
    this.image1,
    this.image2,
    this.image3,
    this.image4,
    this.image5,
    this.editImage1 = PostingImageList.empty,
    this.editImage2 = PostingImageList.empty,
    this.editImage3 = PostingImageList.empty,
    this.editImage4 = PostingImageList.empty,
    this.editImage5 = PostingImageList.empty,
  });

  bool get buttonEnable {
    bool result = false;
    if (subType?.parent == CommunityType.love ||
        subType?.parent == CommunityType.marry) {
      result = title.isNotEmpty && content.isNotEmpty;
    } else {
      result = info.isNotEmpty;
    }

    return result &&
        hashTags.isNotEmpty &&
        !(((image1?.path ?? "").isEmpty && (editImage1.image ?? "").isEmpty) &&
            ((image2?.path ?? "").isEmpty && (editImage2.image ?? "").isEmpty));
  }

  CommunityWriteState copyWith({
    CommunityWriteStatus? status,
    CommunitySubType? subType,
    String? title,
    String? info,
    String? url,
    String? content,
    List<String>? hashTags,
    File? image1,
    File? image2,
    PostingImageList? editImage1,
    PostingImageList? editImage2,
    File? image3,
    File? image4,
    PostingImageList? editImage3,
    PostingImageList? editImage4,
    File? image5,
    PostingImageList? editImage5,
  }) {
    return CommunityWriteState(
      status: status ?? this.status,
      subType: subType ?? this.subType,
      title: title ?? this.title,
      info: info ?? this.info,
      url: url ?? this.url,
      content: content ?? this.content,
      hashTags: hashTags ?? this.hashTags,
      image1: image1 ?? this.image1,
      image2: image2 ?? this.image2,
      image3: image3 ?? this.image3,
      image4: image4 ?? this.image4,
      image5: image5 ?? this.image5,
      editImage1: editImage1 ?? this.editImage1,
      editImage2: editImage2 ?? this.editImage2,
      editImage3: editImage3 ?? this.editImage3,
      editImage4: editImage4 ?? this.editImage4,
      editImage5: editImage5 ?? this.editImage5,
    );
  }

  @override
  List<Object?> get props => [
        status,
        subType,
        title,
        info,
        url,
        content,
        hashTags,
        image1,
        image2,
        editImage1,
        editImage2,
        image3,
        image4,
        editImage3,
        editImage4,
        image5,
        editImage5,
      ];
}
