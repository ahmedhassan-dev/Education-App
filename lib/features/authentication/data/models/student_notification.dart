class NotificationModel {
  final String id;
  final String studentId;
  final String courseId;
  final String courseTitle;
  final String notificationType; // e.g., "submission", "feedback", "reminder"
  final List<String> validSolvedProblemsId;
  final List<String> wrongSolvedProblemsId;
  final int score;
  final DateTime timestamp;
  final bool sent;

  NotificationModel({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.courseTitle,
    required this.notificationType,
    required this.validSolvedProblemsId,
    required this.wrongSolvedProblemsId,
    required this.score,
    required this.timestamp,
    required this.sent,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      studentId: json['studentId'],
      courseId: json['courseId'],
      courseTitle: json['courseTitle'],
      notificationType: json['notificationType'],
      validSolvedProblemsId: List<String>.from(json['validSolvedProblemsId']),
      wrongSolvedProblemsId: List<String>.from(json['wrongSolvedProblemsId']),
      score: json['score'],
      timestamp: DateTime.parse(json['timestamp']),
      sent: json['sent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'notificationType': notificationType,
      'validSolvedProblemsId': validSolvedProblemsId,
      'wrongSolvedProblemsId': wrongSolvedProblemsId,
      'score': score,
      'timestamp': timestamp.toIso8601String(),
      'sent': sent,
    };
  }
}
