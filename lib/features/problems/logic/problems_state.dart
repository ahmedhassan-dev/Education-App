part of 'problems_cubit.dart';

sealed class ProblemsState {
  const ProblemsState();
}

final class ProblemsInitial extends ProblemsState {}

class Loading extends ProblemsState {}

class ImageLoaded extends ProblemsState {}

class NeedHelpVideosLoaded extends ProblemsState {}

class ProblemsLoaded extends ProblemsState {}

class NoImageSelected extends ProblemsState {}

class ErrorOccurred extends ProblemsState {
  final String errorMsg;

  ErrorOccurred({required this.errorMsg});
}

class DataLoaded extends ProblemsState {
  final List<Problems>? retrievedProblemList;
  final dynamic userData;
  final List<SolvedProblems>? retrievedSolutionList;

  DataLoaded(
      this.retrievedProblemList, this.userData, this.retrievedSolutionList);
}

// class UserDataLoaded extends ProblemsState {
//   final dynamic userData;

//   UserDataLoaded(this.userData);
// }

// class SolutionsLoaded extends ProblemsState {
//   final List<SolvedProblems>? retrievedSolutionList;

//   SolutionsLoaded(this.retrievedSolutionList);
// }

class NoProblemsAvailable extends ProblemsState {}
