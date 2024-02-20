import 'package:intl/intl.dart';

extension DateFormatString on DateTime {
  String toDateFormatString() {
    return DateFormat('dd MMM yyyy').format(this);
  }
}

extension DateCompare on DateTime {
  bool isSameDate(DateTime date) {
    return (day == date.day && month == date.month && year == date.year);
  }
}
