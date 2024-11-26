part of 'fetch_student_data_cubit.dart';

@immutable
sealed class FetchStudentDataState {}

final class FetchStudentDataInitial extends FetchStudentDataState {}

class AnswerImageLoaded extends FetchStudentDataState {}

class StudentDataLoaded extends FetchStudentDataState {
  final Student student;
  StudentDataLoaded({required this.student});
}

class StudentDataFailure extends FetchStudentDataState {
  final String errorMsg;
  StudentDataFailure({required this.errorMsg});
}
