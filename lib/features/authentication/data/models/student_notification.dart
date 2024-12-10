import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/helpers/extensions.dart';

class NotificationModel {
  final String id;
  final String studentId;
  final String courseId;
  final String courseSubject;
  final String? notificationType; // e.g., "submission", "feedback", "reminder"
  final List<String>? validSolvedProblemsId;
  final List<String>? wrongSolvedProblemsId;
  int score;
  final DateTime? lastUpdate;
  final bool sent;

  NotificationModel({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.courseSubject,
    required this.notificationType,
    this.validSolvedProblemsId,
    this.wrongSolvedProblemsId,
    this.score = 0,
    this.lastUpdate,
    this.sent = false,
  });

  bool isNewClass() {
    return (validSolvedProblemsId.isNullOrEmpty() &&
        wrongSolvedProblemsId.isNullOrEmpty());
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      studentId: json['studentId'],
      courseId: json['courseId'],
      courseSubject: json['courseSubject'],
      notificationType: json['notificationType'],
      validSolvedProblemsId: List<String>.from(json['validSolvedProblemsId']),
      wrongSolvedProblemsId: List<String>.from(json['wrongSolvedProblemsId']),
      score: json['score'],
      lastUpdate: (json['lastUpdate'] as Timestamp).toDate().toLocal(),
      sent: json['sent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'courseId': courseId,
      'courseSubject': courseSubject,
      'notificationType': notificationType ?? "submission",
      'validSolvedProblemsId': validSolvedProblemsId,
      'wrongSolvedProblemsId': wrongSolvedProblemsId,
      'score': score,
      'lastUpdate': Timestamp.fromDate(lastUpdate ?? DateTime.now().toUtc()),
      'sent': sent,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? studentId,
    String? courseId,
    String? courseSubject,
    String? notificationType,
    List<String>? validSolvedProblemsId,
    List<String>? wrongSolvedProblemsId,
    int? score,
    DateTime? lastUpdate,
    bool? sent,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      courseId: courseId ?? this.courseId,
      courseSubject: courseSubject ?? this.courseSubject,
      notificationType: notificationType ?? this.notificationType,
      validSolvedProblemsId:
          validSolvedProblemsId ?? this.validSolvedProblemsId,
      wrongSolvedProblemsId:
          wrongSolvedProblemsId ?? this.wrongSolvedProblemsId,
      score: score ?? this.score,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      sent: sent ?? this.sent,
    );
  }
}
