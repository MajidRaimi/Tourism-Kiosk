import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';
import '../services/prayer_time_service.dart';

final locationProvider = FutureProvider<Position?>((ref) async {
  return await LocationService.getCurrentPosition();
});

final cityNameProvider = FutureProvider<String>((ref) async {
  final position = await ref.watch(locationProvider.future);
  if (position != null) {
    return await LocationService.getCityName(
      position.latitude,
      position.longitude,
    );
  }
  return 'Riyadh, Saudi Arabia';
});

final weatherProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final position = await ref.watch(locationProvider.future);
  if (position != null) {
    return await WeatherService.getWeather(
      position.latitude,
      position.longitude,
    );
  }
  // Default Riyadh coordinates
  return await WeatherService.getWeather(24.7136, 46.6753);
});

final nextPrayerProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final position = await ref.watch(locationProvider.future);
  if (position != null) {
    return PrayerTimeService.getNextPrayer(
      position.latitude,
      position.longitude,
    );
  }
  // Default Riyadh coordinates
  return PrayerTimeService.getNextPrayer(24.7136, 46.6753);
});
