import 'package:equatable/equatable.dart';
import 'package:oasis/model/user/user_profile.dart';

class Matching extends Equatable {
  final UserProfile? fromCustomer; //from_customer
  final bool? openStatus; //"open_status": true,
  final bool? proposeStatus; // "propose_status": true,
  final bool? autoReject; // "auto_reject": true,
  final int? matchingRate; //  "matching_rate": 0,
  final int? cardId; // "card_id": 0
  final DateTime? createdAt;

  const Matching({
    this.openStatus,
    this.fromCustomer,
    this.proposeStatus,
    this.autoReject,
    this.matchingRate,
    this.cardId,
    this.createdAt,
  });

  static const empty = Matching();

  factory Matching.fromJson(Map<String, dynamic> json) {
    return Matching(
      fromCustomer: json["from_customer"] != null
          ? UserProfile.fromJson(json["from_customer"])
          : null,
      openStatus: json["open_status"],
      proposeStatus: json["propose_status"],
      autoReject: json["auto_reject"],
      matchingRate: json["matching_rate"],
      cardId: json["card_id"],
      createdAt: json["create_dt"] != null
          ? DateTime.parse(json['create_dt'] as String).toLocal()
          : null,
    );
  }

  Matching copyWith({
    UserProfile? fromCustomer, //from_customer
    bool? openStatus,
    bool? proposeStatus, // "propose_status": true,
    bool? authReject, // "auto_reject": true,
    int? matchingRate, //  "matching_rate": 0,
    int? cardId, // "card_id": 0
    DateTime? createdAt,
  }) {
    return Matching(
      fromCustomer: fromCustomer ?? this.fromCustomer,
      openStatus: openStatus ?? this.openStatus,
      proposeStatus: proposeStatus ?? this.proposeStatus,
      autoReject: authReject ?? this.autoReject,
      matchingRate: matchingRate ?? this.matchingRate,
      cardId: cardId ?? this.cardId,
        createdAt: createdAt ?? this.createdAt
    );
  }

  @override
  List<Object?> get props => [
        fromCustomer,
        proposeStatus,
        openStatus,
        autoReject,
        matchingRate,
        cardId,
    createdAt,
      ];
}
