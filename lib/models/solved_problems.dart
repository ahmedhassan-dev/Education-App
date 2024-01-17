import 'package:cloud_firestore/cloud_firestore.dart';

class SolvedProblems {
  final String id;
  final String answer;
  final int solvingTime;
  final DateTime nextRepeat;
  final List<String> topics;
  final List<DateTime> failureTime;
  final List<DateTime> needHelp;
  final List<DateTime> solvingDate;
  SolvedProblems({
    required this.id,
    this.answer = "Enter your answer",
    required this.solvingTime,
    required this.nextRepeat,
    required this.topics,
    required this.failureTime,
    required this.needHelp,
    required this.solvingDate,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'answer': answer,
      'solvingTime': solvingTime,
      'nextRepeat': nextRepeat,
      'topics': topics,
      'failureTime': failureTime,
      'needHelp': needHelp,
      'solvingDate': solvingDate,
    };
  }

  SolvedProblems.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        answer = doc.data()!["answer"],
        solvingTime = doc.data()!["solvingTime"],
        nextRepeat = doc.data()!["nextRepeat"],
        topics = doc.data()?["topics"].cast<String>(),
        failureTime = doc.data()?["failureTime"].cast<DateTime>(),
        needHelp = doc.data()?["needHelp"].cast<DateTime>(),
        solvingDate = doc.data()?["solvingDate"].cast<DateTime>();
}
