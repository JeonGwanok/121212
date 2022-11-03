import 'package:equatable/equatable.dart';
import 'package:oasis/ui/register_user_info/common/base_info/gender_select.dart';

class IamportResult extends Equatable {
  final String? birthday; // "numbering": 0,
  final String? name; // "example": 0,
  final Gender? gender;

 const IamportResult({
    this.birthday,
    this.name,
    this.gender,
  });

  static const empty = IamportResult();

  factory IamportResult.fromJson(Map<String, dynamic> json) {
    return IamportResult(
      birthday: json["birthday"] ?? "",
      name: json["name"] ?? "",
      gender: json["gender"] == "female" ? Gender.female : Gender.male,
    );
  }

  @override
  List<Object?> get props => [
        birthday,
        name,
        gender,
      ];
}
