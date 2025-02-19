import 'package:education_app/core/functions/service_locator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

String documentIdFromLocalData() => DateTime.now().toIso8601String();

abstract class AuthManager {
  static bool isWeb = kIsWeb;
  static String? idToken;
  static String? userType = getIt<SharedPreferences>().getString('userType');
}

class SharedPrefKeys {
  static String uid = "uid";
}
