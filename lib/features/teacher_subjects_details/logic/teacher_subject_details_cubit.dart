import 'package:bloc/bloc.dart';
import 'package:education_app/core/constants/api_path.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/teacher_subjects_details/data/repos/subject_courses_repo.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'teacher_subject_details_state.dart';

class TeacherSubjectDetailsCubit extends Cubit<TeacherSubjectDetailsState> {
  List<Courses> courses = [];
  String? email;
  SubjectCoursesRepository subjectCoursesRepository;
  TeacherSubjectDetailsCubit(this.subjectCoursesRepository)
      : super(TeacherSubjectDetailsInitial());

  getEmailFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      email = prefs.getString('email');
    } catch (e) {
      emit(ErrorOccurred(errorMsg: e.toString()));
    }
  }

  getSubjectCourses({required String subject}) async {
    await getEmailFromSharedPreferences();
    subjectCoursesRepository
        .getSubjectCourses(
            path: ApiPath.courses(), subject: subject, authorEmail: email!)
        .then((courses) {
      emit(CoursesLoaded(courses));
      this.courses = courses;
    });
  }
}
