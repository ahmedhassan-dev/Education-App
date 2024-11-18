import 'package:json_annotation/json_annotation.dart';
part 'answer.g.dart';

@JsonSerializable()
class Answer {
  String? answer;
  String? solutionImgURL;
  String status;
  Answer({this.answer, this.solutionImgURL, this.status = "pending"});

  factory Answer.fromJson(Map<String, dynamic>? json) =>
      _$AnswerFromJson(json!);

  Map<String, dynamic> toJson() => _$AnswerToJson(this);
}
