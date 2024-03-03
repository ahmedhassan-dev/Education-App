// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solved_problems.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolvedProblems _$SolvedProblemsFromJson(Map<String, dynamic> json) =>
    SolvedProblems(
      id: json['id'] as String,
      answer: json['answer'] as String?,
      solvingTime: json['solvingTime'] as int,
      nextRepeat: json['nextRepeat'] as String,
      topics: json['topics'] as List<dynamic>,
      failureTime: json['failureTime'] as List<dynamic>,
      needHelp: json['needHelp'] as List<dynamic>,
      solvingDate: json['solvingDate'] as List<dynamic>,
      solutionImgURL: json['solutionImgURL'] as List<dynamic>? ?? const [],
    );

Map<String, dynamic> _$SolvedProblemsToJson(SolvedProblems instance) =>
    <String, dynamic>{
      'id': instance.id,
      'answer': instance.answer,
      'solvingTime': instance.solvingTime,
      'nextRepeat': instance.nextRepeat,
      'topics': instance.topics,
      'failureTime': instance.failureTime,
      'needHelp': instance.needHelp,
      'solvingDate': instance.solvingDate,
      'solutionImgURL': instance.solutionImgURL,
    };
