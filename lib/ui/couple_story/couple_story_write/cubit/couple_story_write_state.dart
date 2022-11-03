import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/image_model.dart';

class CoupleStoryWriteState extends Equatable {
  final ScreenStatus status;

  final String title;
  final String content;
  final List<String> hashTags;

  final File? image1;
  final File? image2;
  final File? image3;

  final PostingImageList editImage1;
  final PostingImageList editImage2;
  final PostingImageList editImage3;

  CoupleStoryWriteState({
    this.status = ScreenStatus.initial,
    this.title = "",
    this.content = "",
    this.hashTags = const [],
    this.image1,
    this.image2,
    this.image3,
    this.editImage1 = PostingImageList.empty,
    this.editImage2 = PostingImageList.empty,
    this.editImage3 = PostingImageList.empty,
  });

  bool get buttonEnable =>
      title.isNotEmpty && content.isNotEmpty && hashTags.isNotEmpty;

  CoupleStoryWriteState copyWith({
    ScreenStatus? status,
    String? title,
    String? content,
    List<String>? hashTags,
    File? image1,
    File? image2,
    File? image3,
    PostingImageList? editImage1,
    PostingImageList? editImage2,
    PostingImageList? editImage3,
  }) {
    return CoupleStoryWriteState(
      status: status ?? this.status,
      title: title ?? this.title,
      content: content ?? this.content,
      hashTags: hashTags ?? this.hashTags,
      image1: image1 ?? this.image1,
      image2: image2 ?? this.image2,
      image3: image3 ?? this.image3,
      editImage1: editImage1 ?? this.editImage1,
      editImage2: editImage2 ?? this.editImage2,
      editImage3: editImage3 ?? this.editImage3,
    );
  }

  @override
  List<Object?> get props => [
        status,
        title,
        content,
        hashTags,
        image1,
        image2,
        image3,
        editImage1,
        editImage2,
        editImage3,
      ];
}
