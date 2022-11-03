import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oasis/ui/util/date.dart';

import 'calendar_date_cell.dart';

class CalendarForm extends StatefulWidget {
  final DateTime startDate; // 선택할 수 있는 시작 날짜
  Function(DateTime) onSelect;
  // 선택 된 날짜
  final DateTime? selectedDate;
  // 현재 달력에 보여지는 달
  final DateTime currentMonthDate;
  final List<DateTime> hollyDays;

  CalendarForm({
    required this.startDate,
    this.selectedDate,
    this.hollyDays = const [],
    required this.currentMonthDate,
    required this.onSelect,
  });

  @override
  _CalendarFormState createState() => _CalendarFormState();
}

class _CalendarFormState extends State<CalendarForm> {
  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        height = globalKey.currentContext?.size?.height ?? 1;
      });
    });
  }

  var height = 1.0;

  @override
  Widget build(BuildContext context) {
    List<DayCell> days = [];
    // 보여지는달 1일.
    var firstDay = DateTime(
        widget.currentMonthDate.year, widget.currentMonthDate.month, 1);
    // 보여지는달 마지막일.
    var lastDay = DateTime(
        widget.currentMonthDate.year, widget.currentMonthDate.month + 1, 0);

    // 총 셀 개수. ('이전달 + 이번달 + 다음달' 일수)
    int cellCount = (lastDay.day == 31 &&
                (firstDay.weekday == 5 || firstDay.weekday == 6)) ||
            (lastDay.day == 30 && firstDay.weekday == 6)
        ? 42
        : 35;

    // 이전달 셀 개수. (연한 회색)
    int lastDays = (firstDay.weekday == 7) ? 0 : -firstDay.weekday;
    for (var i = lastDays; i < cellCount + lastDays; i++) {
      var _date = DateTime(firstDay.year, firstDay.month, firstDay.day + i);
      var onLightColor =
          (_date.month == widget.currentMonthDate.month) ? false : true;

      var day = DayCell(
        enableStartDate: widget.startDate,
        date: _date,
        holyDays: widget.hollyDays,
        onSelect: (selected) {
          widget.onSelect(selected);
        },
        onLightColor: onLightColor,
        enabled: widget.selectedDate != null
            ? Date.isSame(widget.selectedDate!, _date)
            : false,
      );
      days.add(day);
    }

    var width = MediaQuery.of(context).size.width - 40;
    return Container(
      key: globalKey,
      child: GridView.count(
        padding: EdgeInsets.only(top: 0, bottom: 0),
        childAspectRatio: (cellCount == 42)
            ? (width / 7) / (height / 6)
            : (width / 7) / (height / 5),
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 7,
        children: days,
      ),
    );
  }
}
