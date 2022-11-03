import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/community/community.dart';
import 'package:oasis/ui/common/search_bar.dart';

class CommunityMainMoreState extends Equatable {
  final ScreenStatus status;
  final int totalCount;
  final int page;
  final List<CommunityResponseItem>? items;
  final SearchSortType searchSortType;
  final String searchText;

  CommunityMainMoreState({
    this.status = ScreenStatus.initial,
    this.totalCount = 0,
    this.page = 0,
    this.items,
    this.searchSortType = SearchSortType.nickName,
    this.searchText = "",
  });

  CommunityMainMoreState copyWith({
    ScreenStatus? status,
    int? totalCount,
    int? page,
    List<CommunityResponseItem>? items,
    SearchSortType? searchSortType,
    String? searchText,
  }) {
    return CommunityMainMoreState(
      status: status ?? this.status,
      totalCount: totalCount ?? this.totalCount,
      page: page ?? this.page,
      items: items ?? this.items,
      searchSortType: searchSortType ?? this.searchSortType,
      searchText: searchText ?? this.searchText,
    );
  }

  @override
  List<Object?> get props => [
        status,
        totalCount,
        page,
        items,
        searchSortType,
        searchText,
      ];
}
