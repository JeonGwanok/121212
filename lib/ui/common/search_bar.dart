import 'package:flutter/material.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/common/showBottomSheet.dart';
import 'package:oasis/ui/theme.dart';

import 'custom_icon.dart';

enum SearchSortType {
  title,
  nickName,
  tag,
}

extension SearchSortTypeExtension on SearchSortType {
  String get title {
    switch (this) {
      case SearchSortType.title:
        return "제목+내용";
      case SearchSortType.nickName:
        return "닉네임";
      case SearchSortType.tag:
        return "태그";
    }
  }

  String? get key {
    switch (this) {
      case SearchSortType.title:
        return "title";
      case SearchSortType.nickName:
        return "nick_name";
      case SearchSortType.tag:
        return "tag";
    }
  }
}

class SearchBar extends StatefulWidget {
  final String title;
  final SearchSortType searchType;
  final String searchText;
  final List<SearchSortType> searchItems;
  final Function(SearchSortType) onChangeType;
  final Function(String) onChangeText;
  final Function() onSearch;
  final Widget? action;

  SearchBar({
    required this.title,
    required this.searchText,
    required this.searchType,
    required this.searchItems,
    required this.onChangeType,
    required this.onChangeText,
    required this.onSearch,
    this.action,
  });

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: header02.copyWith(color: darkBlue),
            ),
            widget.action ?? Container()
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                var searchType = await showBottomOptionWithCancelSheet(context,
                    title: "카테고리",
                    items: [
                      ...widget.searchItems,
                      "취소"
                    ],
                    labels: [
                      ...widget.searchItems.map((e) => e.title).toList(),
                      "취소"
                    ]);

                if (searchType != null && searchType != "취소") {
                  widget.onChangeType(searchType as SearchSortType);
                }
              },
              child: Container(
                width: 123,
                height: 52,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: cardShadow,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.searchType.title,
                      style: body01.copyWith(color: gray600),
                    ),
                    CustomIcon(
                      width: 16,
                      height: 16,
                      path: "icons/downArrow",
                    )
                  ],
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: DefaultField(
                maxLine: 1,
                onChange: (text) {
                  widget.onChangeText(text);
                },
                onFieldSubmitted: (text) {
                  widget.onSearch();
                },
                backgroundColor: Colors.white,
                prefixIcon: CustomIcon(
                  path: "icons/search",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
