import 'package:equatable/equatable.dart';
import 'package:oasis/model/community/community.dart';
import 'package:oasis/model/user/user_profile.dart';

enum CommunityDetailStatus {
  initial,
  loaded,
  loading,
  notFound,
  alreadyLike,
  alreadyDislike,
  fail,
  success,
  hasSlang,

  commentDeleteSuccess,
  blockSuccess,
  reportSuccess,
  deleteSuccess,
}

class CommunityDetailState extends Equatable {
  final CommunityDetailStatus status;
  final UserProfile user;
  final bool likeStatus;
  final int like;
  final bool dislikeStatus;
  final int dislike;
  final CommunityDetail item;

  CommunityDetailState({
    this.status = CommunityDetailStatus.initial,
    this.user = UserProfile.empty,
    this.item = CommunityDetail.empty,
    this.likeStatus = false,
    this.like = 0,
    this.dislikeStatus = false,
    this.dislike = 0,
  });

  CommunityDetailState copyWith({
    CommunityDetailStatus? status,
    UserProfile? user,
    CommunityDetail? item,
    bool? likeStatus,
    int? like,
    bool? dislikeStatus,
    int? dislike,
  }) {
    return CommunityDetailState(
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
