import 'package:adhan/adhan.dart';

class PrayerTimeService {
  static Map<String, DateTime> getPrayerTimes(double lat, double lon) {
    final coordinates = Coordinates(lat, lon);
    final params = CalculationMethod.umm_al_qura.getParameters();
    params.madhab = Madhab.shafi;

    final prayerTimes = PrayerTimes.today(coordinates, params);

    return {
      'Fajr': prayerTimes.fajr,
      'Sunrise': prayerTimes.sunrise,
      'Dhuhr': prayerTimes.dhuhr,
      'Asr': prayerTimes.asr,
      'Maghrib': prayerTimes.maghrib,
      'Isha': prayerTimes.isha,
    };
  }

  static Map<String, dynamic> getNextPrayer(double lat, double lon) {
    final prayerTimes = getPrayerTimes(lat, lon);
    final now = DateTime.now();

    for (var entry in prayerTimes.entries) {
      if (entry.value.isAfter(now)) {
        return {
          'name': entry.key,
          'nameAr': _getArabicName(entry.key),
          'time': entry.value,
        };
      }
    }

    // If no prayer left today, return Fajr of tomorrow
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final coordinates = Coordinates(lat, lon);
    final params = CalculationMethod.umm_al_qura.getParameters();
    params.madhab = Madhab.shafi;

    final tomorrowPrayers = PrayerTimes(coordinates, DateComponents.from(tomorrow), params);

    return {
      'name': 'Fajr',
      'nameAr': 'الفجر',
      'time': tomorrowPrayers.fajr,
    };
  }

  static String _getArabicName(String prayerName) {
    switch (prayerName) {
      case 'Fajr':
        return 'الفجر';
      case 'Sunrise':
        return 'الشروق';
      case 'Dhuhr':
        return 'الظهر';
      case 'Asr':
        return 'العصر';
      case 'Maghrib':
        return 'المغرب';
      case 'Isha':
        return 'العشاء';
      default:
        return prayerName;
    }
  }

  static String formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
