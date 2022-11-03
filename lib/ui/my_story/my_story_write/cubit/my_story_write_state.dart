import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:oasis/model/image_model.dart';

enum MyStoryWriteStatus {
  initial, loaded,loading, fail, success, refresh, hasSlang
}


class MyStoryWriteState extends Equatable {
  final MyStoryWriteStatus status;

  final bool publicStatus;
  final String title;
  final String content;
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

  MyStoryWriteState({
    this.status = MyStoryWriteStatus.initial,
    this.publicStatus = true,
    this.title = "",
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

  bool get buttonEnable =>
      title.isNotEmpty &&
      content.isNotEmpty &&
      hashTags.isNotEmpty &&
      !(((image1?.path ?? "").isEmpty && (editImage1.image ?? "").isEmpty) &&
          ((image2?.path ?? "").isEmpty && (editImage2.image ?? "").isEmpty) &&
          ((image3?.path ?? "").isEmpty && (editImage3.image ?? "").isEmpty));

  MyStoryWriteState copyWith({
    MyStoryWriteStatus? status,
    bool? publicStatus,
    String? title,
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
    return MyStoryWriteState(
      status: status ?? this.status,
      publicStatus: publicStatus ?? this.publicStatus,
      title: title ?? this.title,
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
        publicStatus,
        title,
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
