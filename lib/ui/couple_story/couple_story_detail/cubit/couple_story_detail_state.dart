import 'package:equatable/equatable.dart';
import 'package:oasis/model/my_story/my_story.dart';
import 'package:oasis/model/user/user_profile.dart';

enum CoupleStoryDetailStatus {
  initial,
  loaded,
  loading,
  notFound,
  alreadyLike,
  alreadyDislike,
  fail,
  success,
  deleteSuccess,
  reportSuccess
}

class CoupleStoryDetailState extends Equatable {
  final CoupleStoryDetailStatus status;
  final UserProfile user;
  final bool likeStatus;
  final int like;
  final bool dislikeStatus;
  final int dislike;
  final MyStory item;

  CoupleStoryDetailState({
    this.status = CoupleStoryDetailStatus.initial,
    this.user = UserProfile.empty,
    this.item = MyStory.empty,
    this.likeStatus = false,
    this.like = 0,
    this.dislikeStatus = false,
    this.dislike = 0,
  });

  CoupleStoryDetailState copyWith({
    CoupleStoryDetailStatus? status,
    UserProfile? user,
    MyStory? item,
    bool? likeStatus,
    int? like,
    bool? dislikeStatus,
    int? dislike,
  }) {
    return CoupleStoryDetailState(
      status: status ?? this.status,
      user: user ?? this.user,
      item: item ?? this.item,
      likeStatus: likeStatus ?? this.likeStatus,
      like: like ?? this.like,
      dislikeStatus: dislikeStatus ?? this.dislikeStatus,
      dislike: dislike ?? this.dislike,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        item,
        likeStatus,
        like,
        dislikeStatus,
        dislike,
      ];
}
