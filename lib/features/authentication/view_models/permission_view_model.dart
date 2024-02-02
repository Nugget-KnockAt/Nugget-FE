import 'package:flutter_riverpod/flutter_riverpod.dart';

final cameraPermissionProvider = StateProvider<bool>((ref) {
  return false;
});

final locationPermissionProvider = StateProvider<bool>((ref) {
  return false;
});
