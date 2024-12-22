import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

// Request camera permission
Future<void> requestCameraPermission() async {
  final status = await Permission.camera.request();

  if (status.isGranted) {
    // Permission granted, proceed with camera usage
    debugPrint('Camera permission granted');
  } else if (status.isPermanentlyDenied) {
    // User opted to never again see the permission request dialog
    // Navigate to app settings
    openAppSettings();
  } else {
    // Permission denied
    debugPrint('Camera permission denied');
  }
}
