import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../models/attraction.dart';
import '../services/location_service.dart';
import 'location_provider.dart';

/// Provider that returns attractions with calculated distances based on user location
final attractionsProvider = FutureProvider<List<Attraction>>((ref) async {
  final position = await ref.watch(locationProvider.future);

  // Get all attractions
  final attractions = Attraction.dummyAttractions;

  // If we have user location, calculate distances
  if (position != null) {
    final attractionsWithDistance = attractions.map((attraction) {
      final distance = LocationService.calculateDistance(
        startLat: position.latitude,
        startLon: position.longitude,
        endLat: attraction.latitude,
        endLon: attraction.longitude,
      );
      return attraction.copyWith(distance: distance);
    }).toList();

    // Sort by distance (nearest first)
    attractionsWithDistance.sort((a, b) => a.distance.compareTo(b.distance));

    return attractionsWithDistance;
  }

  // If no location, return attractions sorted by hardcoded distance
  final sortedAttractions = List<Attraction>.from(attractions);
  sortedAttractions.sort((a, b) => a.distance.compareTo(b.distance));
  return sortedAttractions;
});

final selectedAttractionProvider = StateProvider<Attraction?>((ref) {
  return null;
});
