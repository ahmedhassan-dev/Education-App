part of 'add_new_problem_cubit.dart';

@immutable
sealed class AddNewProblemState {}

final class TeacherInitial extends AddNewProblemState {}

class Loading extends AddNewProblemState {}

class LoadingModalBottomSheetData extends AddNewProblemState {}

class ModalBottomSheetProblemsLoaded extends AddNewProblemState {
  final List<Problems> problemsList;
  ModalBottomSheetProblemsLoaded({required this.problemsList});
}

class ErrorOccurred extends AddNewProblemState {
  final String errorMsg;

  ErrorOccurred({required this.errorMsg});
}

class TeacherDataUpdated extends AddNewProblemState {}

class UserDataRetrieved extends AddNewProblemState {}

class ProblemStored extends AddNewProblemState {}
