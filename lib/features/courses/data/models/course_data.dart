class CourseData {
  final String? id;
  final String authorEmail;
  final String authorName;
  final String stage;
  final List<dynamic> topics;
  CourseData(
      {required this.id,
      required this.authorEmail,
      required this.authorName,
      required this.stage,
      required this.topics});
}
