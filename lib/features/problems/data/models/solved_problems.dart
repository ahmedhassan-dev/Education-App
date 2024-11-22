import 'package:education_app/features/problems/data/models/answer.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/solved_problems_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'solved_problems.g.dart';

@JsonSerializable()
class SolvedProblems extends NeedReviewSolutionsEntity {
  final String id;
  final String uid;
  final String? courseId;
  final List<Answer> answers;
  final List<int> solvingTime;
  final String nextRepeat;
  final bool needReview;
  final List<String> teacherNotes;
  final List<dynamic> topics;
  final List<dynamic> failureTime;
  final List<dynamic> needHelp;
  final List<dynamic> solvingDate;

  SolvedProblems({
    required this.id,
    required this.uid,
    required this.courseId,
    this.answers = const [],
    required this.solvingTime,
    required this.nextRepeat,
    this.needReview = false,
    this.teacherNotes = const [],
    required this.topics,
    required this.failureTime,
    required this.needHelp,
    required this.solvingDate,
  }) : super(
            solvedProblemid: id,
            studentID: uid,
            studentAnswer: answers,
            studentSolvingTime: solvingTime,
            problemNextRepeat: nextRepeat,
            isNeedingReview: needReview);

  String getStudentEmail() {
    int dashIndex = id.indexOf('-');
    if (dashIndex == -1) {
      return "";
    }
    return id.substring(dashIndex + 1);
  }

  factory SolvedProblems.fromJson(Map<String, dynamic>? json) =>
      _$SolvedProblemsFromJson(json!);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'uid': uid,
        'courseId': courseId,
        'answers': answers.map((e) => e.toJson()).toList(),
        'solvingTime': solvingTime,
        'nextRepeat': nextRepeat,
        'needReview': needReview,
        'teacherNotes': teacherNotes,
        'topics': topics,
        'failureTime': failureTime,
        'needHelp': needHelp,
        'solvingDate': solvingDate,
      };

  SolvedProblems copyWith(
      {String? id,
      String? uid,
      String? courseId,
      List<Answer>? answers,
      List<int>? solvingTime,
      String? nextRepeat,
      bool? needReview,
      List<dynamic>? topics,
      List<dynamic>? failureTime,
      List<dynamic>? needHelp,
      List<dynamic>? solvingDate}) {
    return SolvedProblems(
        id: id ?? this.id,
        uid: uid ?? this.uid,
        courseId: courseId ?? this.courseId,
        answers: answers ?? this.answers,
        solvingTime: solvingTime ?? this.solvingTime,
        nextRepeat: nextRepeat ?? this.nextRepeat,
        needReview: needReview ?? this.needReview,
        topics: topics ?? this.topics,
        failureTime: failureTime ?? this.failureTime,
        needHelp: needHelp ?? this.needHelp,
        solvingDate: solvingDate ?? this.solvingDate);
  }
}
