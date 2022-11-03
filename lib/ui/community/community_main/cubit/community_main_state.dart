import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/community/community_main/community_main.dart';
import 'package:oasis/ui/common/search_bar.dart';

class CommunityMainState extends Equatable {
  final ScreenStatus status;
  final CommunityMain? communityMain;
  final SearchSortType searchSortType;
  final String searchText;

  CommunityMainState({
    this.status = ScreenStatus.initial,
    this.communityMain,
    this.searchSortType = SearchSortType.nickName,
    this.searchText = "",
  });

  CommunityMainState copyWith({
    ScreenStatus? status,
    CommunityMain? communityMain,
    SearchSortType? searchSortType,
    String? searchText,
  }) {
    return CommunityMainState(
      status: status ?? this.status,
      communityMain: communityMain ?? this.communityMain,
      searchSortType: searchSortType ?? this.searchSortType,
      searchText: searchText ?? this.searchText,
    );
  }

  @override
  List<Object?> get props => [
        status,
        communityMain,
        searchSortType,
        searchText,
      ];
}
