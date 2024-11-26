// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Answer _$AnswerFromJson(Map<String, dynamic> json) => Answer(
      answer: json['answer'] as String?,
      solutionImgURL: json['solutionImgURL'] as String?,
      status: json['status'] as String? ?? "pending",
      seen: json['seen'] as bool? ?? false,
    );

Map<String, dynamic> _$AnswerToJson(Answer instance) => <String, dynamic>{
      'answer': instance.answer,
      'solutionImgURL': instance.solutionImgURL,
      'status': instance.status,
      'seen': instance.seen,
    };
