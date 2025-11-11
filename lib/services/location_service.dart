import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  static Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  static Future<String> getCityName(double lat, double lon) async {
    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon');
      final response = await http.get(
        url,
        headers: {'User-Agent': 'SaudiTourismKiosk/1.0'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['address']['city'] ??
            data['address']['town'] ??
            data['address']['village'] ??
            'Saudi Arabia';
      }
    } catch (e) {
      print('Error getting city name: $e');
    }
    return 'Saudi Arabia';
  }

  /// Calculate distance between two points in kilometers
  static double calculateDistance({
    required double startLat,
    required double startLon,
    required double endLat,
    required double endLon,
  }) {
    final distanceInMeters = Geolocator.distanceBetween(
      startLat,
      startLon,
      endLat,
      endLon,
    );
    return distanceInMeters / 1000; // Convert to kilometers
  }
}
