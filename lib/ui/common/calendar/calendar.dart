import 'package:flutter/material.dart';
import 'package:infinity_page_view/infinity_page_view.dart';

import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/theme.dart';
import 'package:oasis/ui/util/date.dart';
import 'dart:math' as math;

import 'calendar_form.dart';

class Calendar extends StatefulWidget {
  final DateTime startDate; // 선택 시작 날짜
  final Function(DateTime) onSelect;
  final DateTime? selectedDate;
  final bool enablePreviousDate;
  final List<DateTime> hollyDays;
  Calendar({
    required this.startDate,
    required this.onSelect,
    this.selectedDate,
    this.enablePreviousDate = true,
    this.hollyDays = const [],
  });
  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  DateTime _date = DateTime.now();
  int year = 0;
  int month = 0;
  int day = 0;

  late InfinityPageController pageController;
  List<DateTime> pageData = [];
  @override
  void initState() {
    super.initState();
    pageController = InfinityPageController(initialPage: 0);
    pageData = [
      _date,
      DateTime(_date.year, _date.month + 1, _date.day),
      DateTime(_date.year, _date.month - 1, _date.day)
    ];
  }

  @override
  Widget build(BuildContext context) {
    year = _date.year;
    month = _date.month;
    day = _date.day;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          navigator(),
          SizedBox(height: 30),
          weeks(),
          SizedBox(height: 5),
          Expanded(child: calendar()),
        ],
      ),
    );
  }

  Widget navigator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              _date = DateTime(year, (month - 1), day);
              _setPage(_pageIndex);
            });
          },
          child: Container(
            width: 30,
            height: 30,
            child: CustomIcon(
              path: "icons/back",
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          width: 130,
          child: Text(
            "${_date.year}년 ${_date.month}월 ",
            textScaleFactor: 1,
            style: header02.copyWith(color: black),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _date = DateTime(year, month + 1, day);
              _setPage(_pageIndex);
            });
          },
          child: Transform.rotate(
            angle: math.pi,
            child: Container(
              width: 30,
              height: 30,
              child: CustomIcon(
                path: "icons/back",
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget weeks() {
    List<Widget> days = List.generate(7, (day) {
      return Expanded(
        child: Center(
          child: Text(
            getWeekKorean(DateTime(2021, 9, 19 + day).weekday),
            textScaleFactor: 1,
            style: body01.copyWith(color: gray400),
          ),
        ),
      );
    }).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days,
    );
  }

// 달력 몸통.
  int _pageIndex = 0;
  Widget calendar() {
    return InfinityPageView(
        controller: pageController,
        itemCount: 3,
        onPageChanged: (idx) {
          setState(() {
            if (_pageIndex == 1 && idx == 2 ||
                _pageIndex == 2 && idx == 0 ||
                _pageIndex == 0 && idx == 1) {
              _date = DateTime(year, month + 1, day);
            } else {
              _date = DateTime(year, month - 1, day);
            }
          });
          _setPage(idx);
          _pageIndex = idx;
        },
        itemBuilder: (BuildContext context, int index) {
          return CalendarForm(startDate: widget.startDate,
            hollyDays: widget.hollyDays,
            selectedDate: widget.selectedDate,
            currentMonthDate: pageData[index],
            onSelect: (selected) {
              if (widget.enablePreviousDate &&
                  Date.clearDate(selected).isBefore(
                      Date.clearDate(DateTime.now()).add(Duration(days: 0)))) {
              } else {
                widget.onSelect(selected);
              }
            },
          );
        });
  }

  _setPage(int page) {
    var nextMonth = DateTime(_date.year, _date.month + 1, _date.day);
    var lastMonth = DateTime(_date.year, _date.month - 1, _date.day);

    switch (page) {
      case 0:
        pageData = [_date, nextMonth, lastMonth];
        break;
      case 1:
        pageData = [lastMonth, _date, nextMonth];
        break;
      case 2:
        pageData = [nextMonth, lastMonth, _date];
        break;
    }
  }
}
