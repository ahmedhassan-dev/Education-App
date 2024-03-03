// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Teacher _$TeacherFromJson(Map<String, dynamic> json) => Teacher(
      uid: json['uid'] as String,
      userName: json['userName'] as String?,
      email: json['email'] as String?,
      phoneNum: json['phoneNum'] as String?,
      subjects: json['subjects'] as List<dynamic>? ?? const [],
      educationalStages:
          json['educationalStages'] as List<dynamic>? ?? const [],
      problemsAdded: (json['problemsAdded'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$TeacherToJson(Teacher instance) => <String, dynamic>{
      'uid': instance.uid,
      'userName': instance.userName,
      'email': instance.email,
      'phoneNum': instance.phoneNum,
      'subjects': instance.subjects,
      'educationalStages': instance.educationalStages,
      'problemsAdded': instance.problemsAdded,
    };
