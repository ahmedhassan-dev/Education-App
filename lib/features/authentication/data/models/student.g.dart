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
      totalScore: (json['totalScore'] as num?)?.toInt() ?? 0,
      userScores: (json['userScores'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      lastProblemIdx: (json['lastProblemIdx'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, Map<String, int>.from(e as Map)),
          ) ??
          const {},
      lastProblemTime: (json['lastProblemTime'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, Map<String, String>.from(e as Map)),
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
