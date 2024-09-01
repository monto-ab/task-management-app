import 'package:intl/intl.dart';

class CommonFunction {
  static final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

  static String getFormattedDateFromTimeInMillis(int? timeInMillis) {
    if (timeInMillis == null) return '';
    return getFormattedDateFromDateTime(
        DateTime.fromMillisecondsSinceEpoch(timeInMillis));
  }

  static String getFormattedDateFromDateTime(DateTime? date) {
    if (date == null) return '';
    return _dateFormat.format(date);
  }
}
