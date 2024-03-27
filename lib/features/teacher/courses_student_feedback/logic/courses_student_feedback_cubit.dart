import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'courses_student_feedback_state.dart';

class CoursesStudentFeedbackCubit extends Cubit<CoursesStudentFeedbackState> {
  CoursesStudentFeedbackCubit() : super(CoursesStudentFeedbackInitial());
}
