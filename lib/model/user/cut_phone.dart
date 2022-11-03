import 'package:equatable/equatable.dart';

enum CutPhoneType { contract, direct }

extension CutPhoneTypeExtension on CutPhoneType {
  String get key {
    switch (this) {
      case CutPhoneType.contract:
        return "CONTACT";
      case CutPhoneType.direct:
        return "DIRECT";
    }
  }
}

CutPhoneType getCutPhoneTypeValue(String key) {
  switch (key) {
    case "CONTACT":
      return CutPhoneType.contract;
    case "DIRECT":
      return CutPhoneType.direct;
  }
  return CutPhoneType.direct;
}

class CutPhone extends Equatable {
  final int? id; // "id": 0,
  final String? name; // "name": "string",
  final CutPhoneType? kind;
  final String? phoneNumber; // "phone_number": "string"

  CutPhone({
    this.id,
    this.name,
    this.kind,
    this.phoneNumber,
  });

  factory CutPhone.fromJson(Map<String, dynamic> json) {
    return CutPhone(
      id: json["id"],
      name: json["name"],
      kind: getCutPhoneTypeValue(json["kind"]),
      phoneNumber: json["phone_number"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone_number": phoneNumber,
    };
  }

  @override
  List<Object?> get props => [
        id,
        kind,
        name,
        phoneNumber,
      ];
}
