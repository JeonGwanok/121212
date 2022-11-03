import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/my_story/my_story.dart';
import 'package:oasis/model/my_story/my_story_response.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/ui/common/search_bar.dart';

class CoupleStoryMainDepth2State extends Equatable {
  final ScreenStatus status;
  final UserProfile user;

  final int totalCount;
  final int page;
  final List<MyStoryPopular> popular;
  final List<MyStory>? myStorys;

  final SearchSortType searchSortType;
  final String searchText;

  CoupleStoryMainDepth2State({
    this.status = ScreenStatus.initial,
    this.user = UserProfile.empty,
    this.totalCount = 0,
    this.page = 0,
    this.popular = const [],
    this.myStorys,
    this.searchSortType = SearchSortType.title,
    this.searchText = "",
  });

  CoupleStoryMainDepth2State copyWith({
    ScreenStatus? status,
    UserProfile? user,
    int? totalCount,
    int? page,
    List<MyStoryPopular>? popular,
    List<MyStory>? myStorys,
    SearchSortType? searchSortType,
    String? searchText,
  }) {
    return CoupleStoryMainDepth2State(
      status: status ?? this.status,
      user: user ?? this.user,
      popular: popular ?? this.popular,
      totalCount: totalCount ?? this.totalCount,
      page: page ?? this.page,
      myStorys: myStorys ?? this.myStorys,
      searchSortType: searchSortType ?? this.searchSortType,
      searchText: searchText ?? this.searchText,
    );
  }

  @override
  List<Object?> get props => [
        status,
        popular,
        user,
        page,
        totalCount,
        myStorys,
        searchSortType,
        searchText,
      ];
}
