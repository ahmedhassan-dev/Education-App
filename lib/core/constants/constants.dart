import 'package:flutter/foundation.dart' show kIsWeb;

String documentIdFromLocalData() => DateTime.now().toIso8601String();
String currentTeacherVersion = "1.0.0";
String currentStudentVersion = "1.0.0";

abstract class AuthManager {
  static bool isWeb = kIsWeb;
}
