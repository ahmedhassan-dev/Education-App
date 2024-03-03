// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Courses _$CoursesFromJson(Map<String, dynamic> json) => Courses(
      imgUrl: json['imgUrl'] as String,
      subject: json['subject'] as String,
      author: json['author'] as String,
      stage: json['stage'] as String,
      topics: json['topics'] as List<dynamic>,
    );

Map<String, dynamic> _$CoursesToJson(Courses instance) => <String, dynamic>{
      'author': instance.author,
      'stage': instance.stage,
      'topics': instance.topics,
      'imgUrl': instance.imgUrl,
      'subject': instance.subject,
    };
