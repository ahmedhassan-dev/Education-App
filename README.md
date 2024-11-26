# Education App

This is an education app built with Flutter & Dart, built (and still working on it).

![IronMan](https://github.com/ahmedhassan-dev/Education-App/assets/62114128/2c0e9be0-d98f-414a-9129-4cbbc0341d54)

## Features

1. Firebase Authentication
   - Email based sign up/in
   - Google Sign in
2. Cloud Firestore
3. Firebase Cloud Storage
4. Firebase Messaging
5. Flavors for Development and Production environment
6. Provider State management before refactoring it to Bloc
7. Cashing data in shared_preferences
8. Image picker

# For building APK:

flutter build apk --flavor development -t lib/main_development.dart --target-platform=android-arm64
