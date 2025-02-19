// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Courses _$CoursesFromJson(Map<String, dynamic> json) => Courses(
      problemsCount: (json['problemsCount'] as num?)?.toInt() ?? 0,
      accessType: json['accessType'] as String? ?? "public",
      id: json['id'] as String?,
      imgUrl: json['imgUrl'] as String,
      subject: json['subject'] as String,
      description: json['description'] as String,
      needReviewCounter: (json['needReviewCounter'] as num?)?.toInt() ?? 0,
      solutionsNeedingReview: (json['solutionsNeedingReview'] as List<dynamic>?)
              ?.map((e) => e as String)
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
      'problemsCount': instance.problemsCount,
      'accessType': instance.accessType,
      'imgUrl': instance.imgUrl,
      'subject': instance.subject,
      'description': instance.description,
      'needReviewCounter': instance.needReviewCounter,
      'solutionsNeedingReview': instance.solutionsNeedingReview,
    };
