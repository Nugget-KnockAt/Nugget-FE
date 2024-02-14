import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final cameraPermissionProvider = StateProvider<bool>((ref) {
  return false;
});

final locationPermissionProvider = StateProvider<bool>((ref) {
  return false;
});

final notiPermissionProvider = StateProvider<bool>((ref) {
  return false;
});
