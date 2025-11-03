import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';

final eventsProvider = Provider<List<Event>>((ref) {
  return Event.dummyEvents;
});

final selectedEventProvider = StateProvider<Event?>((ref) {
  return null;
});
