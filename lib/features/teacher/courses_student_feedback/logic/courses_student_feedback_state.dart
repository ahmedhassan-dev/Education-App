part of 'courses_student_feedback_cubit.dart';

@immutable
sealed class CoursesStudentFeedbackState {}

final class CoursesStudentFeedbackInitial extends CoursesStudentFeedbackState {}

final class DataLoaded extends CoursesStudentFeedbackState {}

final class ErrorOccurred extends CoursesStudentFeedbackState {
  final String errorMsg;

  ErrorOccurred({required this.errorMsg});
}
