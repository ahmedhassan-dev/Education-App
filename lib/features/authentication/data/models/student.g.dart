// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
      uid: json['uid'] as String,
      userName: json['userName'] as String?,
      email: json['email'] as String?,
      phoneNum: json['phoneNum'] as String?,
      totalScore: json['totalScore'] as int? ?? 0,
      userScores: (json['userScores'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as int),
          ) ??
          const {},
      lastProblemIdx: (json['lastProblemIdx'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as int),
          ) ??
          const {},
      lastProblemTime: (json['lastProblemTime'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'uid': instance.uid,
      'userName': instance.userName,
      'email': instance.email,
      'phoneNum': instance.phoneNum,
      'totalScore': instance.totalScore,
      'userScores': instance.userScores,
      'lastProblemIdx': instance.lastProblemIdx,
      'lastProblemTime': instance.lastProblemTime,
    };
