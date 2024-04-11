part of 'fetch_solved_problems_cubit.dart';

@immutable
sealed class FetchSolvedProblemsState {}

final class FetchSolvedProblemsInitial extends FetchSolvedProblemsState {}

class AnswerImageLoaded extends FetchSolvedProblemsState {}
