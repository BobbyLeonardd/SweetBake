import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime date, {String pattern = 'dd MMM yyyy HH:mm'}) {
    return DateFormat(pattern, 'id_ID').format(date);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm', 'id_ID').format(date);
  }
}
