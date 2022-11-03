import 'package:equatable/equatable.dart';

class PostingImageList extends Equatable {
  final int? id;
  final String? image;

  const PostingImageList({this.id, this.image});

  static const empty = PostingImageList();

  factory PostingImageList.fromJson(Map<String, dynamic> json) {
    return PostingImageList(
      id: json["id"],
      image: json["image"],
    );
  }

  PostingImageList copyWith({
    int? id,
    String? image,
  }) {
    return PostingImageList(
      id: id ?? this.id,
      image: image ?? this.image,
    );
  }

  @override
  List<Object?> get props => [
        id,
        image,
      ];
}
