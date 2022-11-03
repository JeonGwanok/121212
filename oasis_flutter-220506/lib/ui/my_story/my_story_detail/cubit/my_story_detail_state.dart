import 'package:equatable/equatable.dart';
import 'package:oasis/model/my_story/my_story.dart';
import 'package:oasis/model/user/user_profile.dart';

enum MyStoryDetailStatus {
  initial,
  loaded,
  loading,
  notFound,
  fail,
  success,


  blockSuccess,
  reportSuccess,
  deleteSuccess,
}

class MyStoryDetailState extends Equatable {
  final MyStoryDetailStatus status;
  final bool likeStatus;
  final int like;
  final MyStory myStory;
  final UserProfile user;

  MyStoryDetailState({
    this.status = MyStoryDetailStatus.initial,
    this.myStory = MyStory.empty,
    this.likeStatus = false,
    this.like = 0,
    this.user = UserProfile.empty,
  });

  MyStoryDetailState copyWith({
    MyStoryDetailStatus? status,
    MyStory? myStory,
    bool? likeStatus,
    int? like,
    UserProfile? user,
  }) {
    return MyStoryDetailState(
      status: status ?? this.status,
      myStory: myStory ?? this.myStory,
      likeStatus: likeStatus ?? this.likeStatus,
      like: like ?? this.like,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
        status,
        myStory,
        likeStatus,
        like,
        user,
      ];
}
