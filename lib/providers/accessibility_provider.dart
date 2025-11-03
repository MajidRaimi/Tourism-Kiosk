import 'package:flutter_riverpod/flutter_riverpod.dart';

final fontSizeProvider = StateProvider<double>((ref) {
  return 1.0; // Default font size multiplier
});

final highContrastProvider = StateProvider<bool>((ref) {
  return false;
});

final textToSpeechProvider = StateProvider<bool>((ref) {
  return false;
});
