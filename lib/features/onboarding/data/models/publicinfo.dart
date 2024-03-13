import 'package:json_annotation/json_annotation.dart';
part 'publicinfo.g.dart';

@JsonSerializable()
class PublicInfo {
  final String appVersion;
  final String newVersionURL;
  PublicInfo({required this.appVersion, required this.newVersionURL});

  factory PublicInfo.fromJson(Map<String, dynamic>? json) =>
      _$PublicInfoFromJson(json!);

  Map<String, dynamic> toJson() => _$PublicInfoToJson(this);
}
