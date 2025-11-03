import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/attraction.dart';

final attractionsProvider = Provider<List<Attraction>>((ref) {
  return Attraction.dummyAttractions;
});

final selectedAttractionProvider = StateProvider<Attraction?>((ref) {
  return null;
});
