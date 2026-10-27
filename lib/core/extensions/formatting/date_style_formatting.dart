import 'package:intl/intl.dart';

extension DateStyleFormatting on DateTime {
  String get shortMonthDayYear => DateFormat.yMMMd().format(this);
  String get shortMonthDay => DateFormat.MMMd().format(this);
}
