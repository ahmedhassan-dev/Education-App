part of 'select_stage_and_subject_cubit.dart';

@immutable
sealed class SelectStageAndSubjectState {}

final class SelectStageAndSubjectInitial extends SelectStageAndSubjectState {}

class Loading extends SelectStageAndSubjectState {}

class SubjectEdited extends SelectStageAndSubjectState {}

class TeacherDataLoaded extends SelectStageAndSubjectState {}

class SubjectsSaved extends SelectStageAndSubjectState {}

class EducationalStagesSaved extends SelectStageAndSubjectState {}

class UserIsNotTeacher extends SelectStageAndSubjectState {}
