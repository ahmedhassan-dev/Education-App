part of 'fetch_problems_cubit.dart';

@immutable
sealed class FetchProblemsState {}

final class FetchProblemsLoading extends FetchProblemsState {}

class NeedReviewProblemsLoaded extends FetchProblemsState {
  final List<ProblemsEntity> needReviewProblems;
  NeedReviewProblemsLoaded({required this.needReviewProblems});
}

class ShowCurrentProblem extends FetchProblemsState {
  final ProblemsEntity problem;
  ShowCurrentProblem({required this.problem});
}

class NeedReviewProblemsFailure extends FetchProblemsState {
  final String errorMsg;
  NeedReviewProblemsFailure({required this.errorMsg});
}
