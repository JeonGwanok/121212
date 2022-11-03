import 'package:intl/intl.dart';

enum DateType { month, day }
enum TimeType { am, pm }

class Date {
  static bool isSame(DateTime a, DateTime b) => clearDate(a) == clearDate(b);

  static DateTime clearDate(DateTime? date, {DateType queryBy = DateType.day}) {
    var _date = date ?? DateTime.now();
    if (queryBy == DateType.month) {
      return DateTime(_date.year, _date.month, 1);
    }
    return DateTime(_date.year, _date.month, _date.day);
  }

  static String dateToStringKey(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  static String timeToStringKey(DateTime date) {
    return "${date.hour}:${date.minute}:00";
  }

  static DateTime? stringToDate(String? date) {
    if (date == null || date == "") return null;
    return DateTime(int.parse(date.split("-")[0]),
        int.parse(date.split("-")[1]), int.parse(date.split("-")[2]));
  }

  static DateTime utcToDateTime(String value) {
    value = value.replaceAll("T", " ");
    if (value.length <= 10) {
      var dateTime = DateFormat("yyyy-MM-dd").parse(value, true);
      var dateLocal = dateTime.toLocal();
      return dateLocal;
    } else if (value.length > 10) {
      var dateTime = DateFormat("yyyy-MM-dd HH:mm:ssZ").parse(value, false);
      var dateLocal = dateTime.toLocal();
      return dateLocal;
    }
    return DateTime.now();
  }
}

String getWeekKorean(int value) {
  if (value == 1) {
    return "월";
  } else if (value == 2) {
    return "화";
  } else if (value == 3) {
    return "수";
  } else if (value == 4) {
    return "목";
  } else if (value == 5) {
    return "금";
  } else if (value == 6) {
    return "토";
  } else if (value == 7) {
    return "일";
  }
  return "";
}
