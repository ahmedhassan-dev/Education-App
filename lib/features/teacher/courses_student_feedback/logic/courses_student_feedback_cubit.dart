import 'package:bloc/bloc.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:meta/meta.dart';

import 'package:education_app/features/teacher/courses_student_feedback/data/repos/courses_student_feedback_repo.dart';

part 'courses_student_feedback_state.dart';

class CoursesStudentFeedbackCubit extends Cubit<CoursesStudentFeedbackState> {
  CoursesStudentFeedbackRepository coursesStudentFeedbackRepository;
  CoursesStudentFeedbackCubit(
    this.coursesStudentFeedbackRepository,
  ) : super(CoursesStudentFeedbackInitial());

  late List<Courses> courses;
  late Courses currentCourse;

  getTeacherSortedCourses() async {
    coursesStudentFeedbackRepository.getTeacherSortedCourses().then((courses) {
      this.courses = courses;
      emit(CoursesLoaded(courses: courses));
    });
  }
}
