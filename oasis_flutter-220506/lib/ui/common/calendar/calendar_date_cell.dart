import 'package:flutter/material.dart';
import 'package:oasis/ui/theme.dart';
import 'package:oasis/ui/util/date.dart';

class DayCell extends StatelessWidget {
  final DateTime enableStartDate; // 선택시작 날짜
  final Function(DateTime) onSelect;
  final DateTime date;
  final bool enabled;
  final bool onLightColor;
  final List<DateTime> holyDays;

  DayCell({
    required this.date,
    required this.onSelect,
    required this.enableStartDate,
    this.enabled = false,
    this.onLightColor = false,
    this.holyDays = const [],
  });

  @override
  Widget build(BuildContext context) {
    var isTodayDate = Date.isSame(DateTime.now(), date);

    var from = Date.clearDate(enableStartDate.add(Duration(days: -1)));
    var to = Date.clearDate(from.add(Duration(days: 15)));

    return GestureDetector(
      onTap: () {
        if (date.isBefore(to) &&
            date.isAfter(from) &&
            !onLightColor &&
            date.isAfter(DateTime.now().add(Duration(days: -1)))) {
          onSelect(date);
        }
      },
      child: Container(
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: onLightColor
                ? Colors.transparent
                : enabled
                    ? mainMint
                    : (isTodayDate ? backgroundColor : Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "${date.day}",
            textAlign: TextAlign.center,
            style: body01.copyWith(
                color: onLightColor
                    ? gray200.withOpacity(0.7)
                    : enabled
                        ? Colors.white
                        : date.isBefore(to) &&
                                date.isAfter(from) &&
                                !date.isBefore(
                                    DateTime.now().add(Duration(days: -1)))
                            ? (date.weekday == 7 ||
                                    date.weekday == 6 ||
                                    holyDays.contains(Date.clearDate(date)))
                                ? Colors.red
                                : gray600
                            : gray300),
          ),
        ),
      ),
    );
  }
}
