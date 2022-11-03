import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/my_story/my_story.dart';
import 'package:oasis/model/user/user_profile.dart';

class MyStoryMainState extends Equatable {
  final ScreenStatus status;
  final int? customerId; // 누구의 내용을 보여줘야하는지
  final UserProfile? user;

  final int totalCount;
  final int page;
  final List<MyStory>? myStorys;

  MyStoryMainState({
    this.status = ScreenStatus.initial,
    this.customerId,
    this.user,
    this.totalCount = 0,
    this.page = 0,
    this.myStorys,
  });

  MyStoryMainState copyWith({
    ScreenStatus? status,
    UserProfile? user,
    int? customerId,
    int? totalCount,
    int? page,
    List<MyStory>? myStorys,
  }) {
    return MyStoryMainState(
      status: status ?? this.status,
      user: user ?? this.user,
      customerId: customerId ?? this.customerId,
      totalCount: totalCount ?? this.totalCount,
      page: page ?? this.page,
      myStorys: myStorys ?? this.myStorys,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        customerId,
        page,
        totalCount,
        myStorys,
      ];
}
