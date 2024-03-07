// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Courses _$CoursesFromJson(Map<String, dynamic> json) => Courses(
      imgUrl: json['imgUrl'] as String,
      subject: json['subject'] as String,
      description: json['description'] as String,
      authorEmail: json['authorEmail'] as String,
      authorName: json['authorName'] as String,
      stage: json['stage'] as String,
      topics: json['topics'] as List<dynamic>,
    );

Map<String, dynamic> _$CoursesToJson(Courses instance) => <String, dynamic>{
      'authorEmail': instance.authorEmail,
      'authorName': instance.authorName,
      'stage': instance.stage,
      'topics': instance.topics,
      'imgUrl': instance.imgUrl,
      'subject': instance.subject,
      'description': instance.description,
    };
