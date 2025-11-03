import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  // Using Open-Meteo (free, no API key required)
  static Future<Map<String, dynamic>?> getWeather(
      double lat, double lon) async {
    try {
      final url = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,weather_code&timezone=auto');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final current = data['current'];

        return {
          'temperature': current['temperature_2m'].round(),
          'weatherCode': current['weather_code'],
          'icon': _getWeatherIcon(current['weather_code']),
        };
      }
    } catch (e) {
      print('Error fetching weather: $e');
    }
    return null;
  }

  static String _getWeatherIcon(int code) {
    // WMO Weather interpretation codes
    if (code == 0) return '☀️'; // Clear sky
    if (code <= 3) return '⛅'; // Partly cloudy
    if (code <= 48) return '🌫️'; // Fog
    if (code <= 67) return '🌧️'; // Rain
    if (code <= 77) return '🌨️'; // Snow
    if (code <= 82) return '🌧️'; // Rain showers
    if (code <= 86) return '🌨️'; // Snow showers
    if (code <= 99) return '⛈️'; // Thunderstorm
    return '🌤️';
  }
}
