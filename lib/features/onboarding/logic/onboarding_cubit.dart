import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:education_app/core/constants/api_path.dart';
import 'package:education_app/core/constants/constants.dart';
import 'package:education_app/core/functions/service_locator.dart';
import 'package:education_app/features/onboarding/data/models/publicinfo.dart';
import 'package:education_app/features/onboarding/data/repos/onboarding_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  late PublicInfo publicInfo;
  String? userType;
  List<String>? subjects;
  OnBoardingRepository onBoardingRepository;
  OnboardingCubit(this.onBoardingRepository) : super(LoadingInitData());
  StreamController firebaseAuthStreamer = StreamController();

  Future<void> getInitDataFromSharedPreferences() async {
    userType = getIt<SharedPreferences>().getString('userType');
    subjects = getIt<SharedPreferences>().getStringList('subjects');
    if (userType != null) {
      getIdToken();
      await _checkForUpdatesIfNotWeb();
    } else {
      emit(LoadSelectUserPage());
    }
  }

  void getIdToken() {
    firebaseAuthStreamer.addStream(
      FirebaseAuth.instance.authStateChanges(),
    );
    firebaseAuthStreamer.stream.listen((data) async {
      if (data == null) {
        AuthManager.idToken = null;
        return;
      }
      User? userData = data as User;
      AuthManager.idToken = await userData.getIdToken();
    });
  }

  Future<void> _checkForUpdatesIfNotWeb() async {
    if (AuthManager.isWeb) {
      emit(InitDataLoaded(userType: userType, subjects: subjects));
    } else {
      await _checkForUpdates(userType!);
    }
  }

  Future<void> _checkForUpdates(String userType) async {
    await _getPublicInfo(userType);
    if (_needUpdate(userType)) {
      emit(NeedUpdate());
    } else {
      emit(InitDataLoaded(userType: userType, subjects: subjects));
    }
  }

  bool _needUpdate(String userType) {
    return (publicInfo.appVersion != currentTeacherVersion &&
            userType == "Teacher") ||
        (publicInfo.appVersion != currentStudentVersion &&
            userType == "Student");
  }

  Future<void> _getPublicInfo(String userType) async {
    await onBoardingRepository
        .getPublicInfo(
            path: ApiPath.publicInfo(),
            docName: "${userType.toLowerCase()}Version")
        .then((publicInfo) {
      this.publicInfo = publicInfo;
    });
  }

  Future<void> downLoadNewVersion() async {
    final Uri url = Uri.parse(publicInfo.newVersionURL);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
