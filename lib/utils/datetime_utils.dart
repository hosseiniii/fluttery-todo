import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

class DateTimeUtils {
  
  static String get currentDay {
    DateTime now = DateTime.now();
    return DateFormat('EEEE').format(now);
  }

  static String get currentMonth {
    DateTime now = DateTime.now();
    return DateFormat('MMM').format(now);
  }

  static String get currentDate {
    DateTime now = DateTime.now();
    return DateFormat('d').format(now);
  }

  static String getToday () {
    String today =
        Jalali.now().year.toString() + "/" +
        Jalali.now().month.toString() + "/" +
        Jalali.now().day.toString();
    return today;
  }

  static String selectedDate = getToday();

}
