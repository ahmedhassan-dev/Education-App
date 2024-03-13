import 'package:bloc/bloc.dart';
import 'package:education_app/core/constants/api_path.dart';
import 'package:education_app/core/constants/constants.dart';
import 'package:education_app/features/onboarding/data/models/publicinfo.dart';
import 'package:education_app/features/onboarding/data/repos/onboarding_repo.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  late PublicInfo publicInfo;
  String? userType;
  List<String>? subjects;
  OnBoardingRepository onBoardingRepository;
  OnboardingCubit(this.onBoardingRepository) : super(LoadingInitData());

  Future<void> getInitDataFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString('userType');
    subjects = prefs.getStringList('subjects');
    if (userType != null) {
      await _checkForUpdates(userType!);
    } else {
      emit(LoadSelectUserPage());
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
