part of 'check_answer_cubit.dart';

@immutable
sealed class CheckAnswerState {}

final class CheckAnswerInitial extends CheckAnswerState {}

class AnswerUpdated extends CheckAnswerState {}

class UpdatingAnswer extends CheckAnswerState {}

class AllSolutionsChecked extends CheckAnswerState {}

class CheckAnswerFailure extends CheckAnswerState {
  final String errorMsg;
  CheckAnswerFailure({required this.errorMsg});
}
