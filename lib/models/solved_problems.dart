import 'package:cloud_firestore/cloud_firestore.dart';

class SolvedProblems {
  final String id;
  final String problemId;
  final String answer;
  final int solvingTime;
  final DateTime nextRepeat;
  final List<String> topics;
  final List<DateTime> failureCount;
  final List<DateTime> needHelp;
  final List<DateTime> solvingDate;
  SolvedProblems({
    required this.id,
    required this.problemId,
    this.answer = "Enter your answer",
    required this.solvingTime,
    required this.nextRepeat,
    required this.topics,
    required this.failureCount,
    required this.needHelp,
    required this.solvingDate,
  });
  Map<String, dynamic> toMap() {
    return {
      'problemId': problemId,
      'id': id,
      'answer': answer,
      'solvingTime': solvingTime,
      'nextRepeat': nextRepeat,
      'topics': topics,
      'failureCount': failureCount,
      'needHelp': needHelp,
      'solvingDate': solvingDate,
    };
  }

  SolvedProblems.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        problemId = doc.data()!["problemId"],
        answer = doc.data()!["answer"],
        solvingTime = doc.data()!["solvingTime"],
        nextRepeat = doc.data()!["nextRepeat"],
        topics = doc.data()?["topics"].cast<String>(),
        failureCount = doc.data()?["failureCount"].cast<DateTime>(),
        needHelp = doc.data()?["needHelp"].cast<DateTime>(),
        solvingDate = doc.data()?["solvingDate"].cast<DateTime>();
}
