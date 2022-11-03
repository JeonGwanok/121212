import 'package:equatable/equatable.dart';

class LastMatching extends Equatable {
  final DateTime? createdAt; // "create_dt": "2022-01-03",
  final int? cardId; // "card_id": 0
  final int? loverId; // "lover_id": 0,
  final String? status; // "status": "string"

  const LastMatching({
    this.createdAt,
    this.cardId,
    this.loverId,
    this.status,
  });

  static const empty = LastMatching();

  factory LastMatching.fromJson(Map<String, dynamic> json) {
    return LastMatching(
      createdAt: json["create_dt"] != null
          ? DateTime.parse(json["create_dt"] as String).toLocal()
          : null,
      cardId: json["card_id"],
      loverId: json["lover_id"],
      status: json["status"],
    );
  }

  LastMatching copyWith({
    DateTime? createdAt,
    int? cardId,
    int? loverId,
    String? status,
  }) {
    return LastMatching(
      createdAt: createdAt ?? this.createdAt,
      cardId: cardId ?? this.cardId,
      loverId: loverId ?? this.loverId,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        createdAt,
        cardId,
        loverId,
        status,
      ];
}
