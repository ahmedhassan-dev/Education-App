part of 'teacher_cubit.dart';

@immutable
sealed class TeacherState {}

final class TeacherInitial extends TeacherState {}

class Loading extends TeacherState {}

class LoadingModalBottomSheetData extends TeacherState {}

class ModalBottomSheetProblemsLoaded extends TeacherState {
  final List<Problems> problemsList;
  ModalBottomSheetProblemsLoaded({required this.problemsList});
}

class ErrorOccurred extends TeacherState {
  final String errorMsg;

  ErrorOccurred({required this.errorMsg});
}

class SubjectEdited extends TeacherState {}

class TeacherDataUpdated extends TeacherState {}

class UserDataRetrieved extends TeacherState {}

class TeacherDataLoaded extends TeacherState {}

class ProblemStored extends TeacherState {}
