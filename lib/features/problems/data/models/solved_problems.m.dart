// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solved_problems.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolvedProblems _$SolvedProblemsFromJson(Map<String, dynamic> json) =>
    SolvedProblems(
      id: json['id'] as String,
      uid: json['uid'] as String,
      courseId: json['courseId'] as String?,
      answers: (json['answers'] as List<dynamic>?)
              ?.map((e) => Answer.fromJson(e as Map<String, dynamic>?))
              .toList() ??
          const [],
      solvingTime: (json['solvingTime'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      nextRepeat: json['nextRepeat'] as String,
      needReview: json['needReview'] as bool? ?? false,
      topics: json['topics'] as List<dynamic>,
      failureTime: json['failureTime'] as List<dynamic>,
      needHelp: json['needHelp'] as List<dynamic>,
      solvingDate: json['solvingDate'] as List<dynamic>,
    );
