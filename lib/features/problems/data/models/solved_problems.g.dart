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
      answer: (json['answer'] as List<dynamic>?)
              ?.map((e) => e as String?)
              .toList() ??
          const [],
      solvingTime:
          (json['solvingTime'] as List<dynamic>).map((e) => e as int).toList(),
      nextRepeat: json['nextRepeat'] as String,
      needReview: json['needReview'] as bool? ?? false,
      teacherNotes: (json['teacherNotes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      topics: json['topics'] as List<dynamic>,
      failureTime: json['failureTime'] as List<dynamic>,
      needHelp: json['needHelp'] as List<dynamic>,
      solvingDate: json['solvingDate'] as List<dynamic>,
      solutionImgURL: json['solutionImgURL'] as List<dynamic>? ?? const [],
    );

Map<String, dynamic> _$SolvedProblemsToJson(SolvedProblems instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'courseId': instance.courseId,
      'answer': instance.answer,
      'solvingTime': instance.solvingTime,
      'nextRepeat': instance.nextRepeat,
      'needReview': instance.needReview,
      'teacherNotes': instance.teacherNotes,
      'topics': instance.topics,
      'failureTime': instance.failureTime,
      'needHelp': instance.needHelp,
      'solvingDate': instance.solvingDate,
      'solutionImgURL': instance.solutionImgURL,
    };
