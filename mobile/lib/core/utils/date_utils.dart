import 'package:intl/intl.dart';

class DateUtils {
  static List<DateTime> getAvailableDates() {
    List<DateTime> dates = [];
    DateTime now = DateTime.now();
    
    for (int i = 1; i <= 30; i++) {
      dates.add(now.add(Duration(days: i)));
    }
    
    return dates;
  }

  static List<String> getAvailableTimeSlots() {
    return [
      '08:00',
      '09:00',
      '10:00',
      '11:00',
      '12:00',
      '13:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00',
      '18:00',
    ];
  }

  static bool isDateAvailable(DateTime date) {
    DateTime now = DateTime.now();
    return date.isAfter(now) && date.isBefore(now.add(const Duration(days: 30)));
  }

  static bool isTimeSlotAvailable(String timeSlot, DateTime date) {
    // Aquí implementarías la lógica para verificar disponibilidad
    // consultando las reservas existentes
    return true;
  }

  static String formatDateForDisplay(DateTime date) {
    final formatter = DateFormat('EEEE, dd MMMM yyyy', 'es_ES');
    return formatter.format(date);
  }

  static String formatTimeForDisplay(String time) {
    return time;
  }

  static DateTime combineDateAndTime(DateTime date, String time) {
    List<String> timeParts = time.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}
