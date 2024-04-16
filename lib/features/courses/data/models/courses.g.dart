// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Courses _$CoursesFromJson(Map<String, dynamic> json) => Courses(
      id: json['id'] as String?,
      imgUrl: json['imgUrl'] as String,
      subject: json['subject'] as String,
      description: json['description'] as String,
      needReviewCounter: json['needReviewCounter'] as int? ?? 0,
      needReviewSolutionsList:
          (json['needReviewSolutionsList'] as List<dynamic>?)
                  ?.map((e) => e as int)
                  .toList() ??
              const [],
      authorEmail: json['authorEmail'] as String,
      authorName: json['authorName'] as String,
      stage: json['stage'] as String,
      topics: json['topics'] as List<dynamic>,
    );

Map<String, dynamic> _$CoursesToJson(Courses instance) => <String, dynamic>{
      'id': instance.id,
      'authorEmail': instance.authorEmail,
      'authorName': instance.authorName,
      'stage': instance.stage,
      'topics': instance.topics,
      'imgUrl': instance.imgUrl,
      'subject': instance.subject,
      'description': instance.description,
      'needReviewCounter': instance.needReviewCounter,
      'needReviewSolutionsList': instance.needReviewSolutionsList,
    };
