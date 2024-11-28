import 'package:json_annotation/json_annotation.dart';
part 'answer.g.dart';

@JsonSerializable()
class Answer {
  String? answer;
  String? solutionImgURL;
  String? teacherNotes;
  String status;
  bool seen;
  Answer(
      {this.answer,
      this.solutionImgURL,
      this.teacherNotes,
      this.status = "pending",
      this.seen = false});

  factory Answer.fromJson(Map<String, dynamic>? json) =>
      _$AnswerFromJson(json!);

  Map<String, dynamic> toJson() => _$AnswerToJson(this);
}
