// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'problems.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Problems _$ProblemsFromJson(Map<String, dynamic> json) => Problems(
      id: (json['id'] as num).toInt(),
      courseId: json['courseId'] as String?,
      title: json['title'] as String,
      problem: json['problem'] as String,
      scoreNum: (json['scoreNum'] as num).toInt(),
      solutions:
          (json['solutions'] as List<dynamic>).map((e) => e as String).toList(),
      stage: json['stage'] as String,
      authorEmail: json['authorEmail'] as String,
      authorName: json['authorName'] as String,
      time: (json['time'] as num).toInt(),
      needReview: json['needReview'] as bool,
      topics: json['topics'] as List<dynamic>,
      videos: json['videos'] as List<dynamic>,
    );

Map<String, dynamic> _$ProblemsToJson(Problems instance) => <String, dynamic>{
      'id': instance.id,
      'authorEmail': instance.authorEmail,
      'authorName': instance.authorName,
      'stage': instance.stage,
      'courseId': instance.courseId,
      'title': instance.title,
      'problem': instance.problem,
      'solutions': instance.solutions,
      'scoreNum': instance.scoreNum,
      'time': instance.time,
      'needReview': instance.needReview,
      'topics': instance.topics,
      'videos': instance.videos,
    };
