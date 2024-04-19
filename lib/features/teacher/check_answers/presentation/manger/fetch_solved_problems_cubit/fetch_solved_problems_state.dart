part of 'fetch_solved_problems_cubit.dart';

@immutable
sealed class FetchSolvedProblemsState {}

final class FetchSolvedProblemsInitial extends FetchSolvedProblemsState {}

class AnswerImageLoaded extends FetchSolvedProblemsState {}

class NeedReviewSolutionsLoaded extends FetchSolvedProblemsState {
  final List<NeedReviewSolutionsEntity> needReviewSolutions;
  NeedReviewSolutionsLoaded({required this.needReviewSolutions});
}

class NeedReviewSolutionsFailure extends FetchSolvedProblemsState {
  final String errorMsg;
  NeedReviewSolutionsFailure({required this.errorMsg});
}
