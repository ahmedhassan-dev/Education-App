// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  getTeacherSortedCourses({required String subject}) async {
    coursesStudentFeedbackRepository.getTeacherSortedCourses().then((courses) {
      emit(CoursesLoaded(courses: courses));
    });
  }
}
