import 'package:equatable/equatable.dart';

class PurchaseHistory extends Equatable {
  final String? membership;
  final int? meetingTotalCount;
  final int? meetingRemainCount;
  final List<Payment> payment;

  const PurchaseHistory({
    this.membership,
    this.meetingTotalCount,
    this.meetingRemainCount,
    this.payment = const [],
  });

  static const empty = PurchaseHistory();

  factory PurchaseHistory.fromJson(Map<String, dynamic> json) {
    return PurchaseHistory(
        membership: json["membership"],
        meetingTotalCount: json["meeting_total_count"],
        meetingRemainCount: json["meeting_remain_count"],
        payment: (json["payment"] ?? []).isNotEmpty
            ? (json["payment"] as List<dynamic>)
                .map((e) => Payment.fromJson(e))
                .toList()
            : []);
  }

  @override
  List<Object?> get props => [
        membership,
        meetingTotalCount,
        meetingRemainCount,
        payment,
      ];
}

class Payment extends Equatable {
  final DateTime? createdAt;
  final String? kindDisplay;

  Payment({this.createdAt, this.kindDisplay});

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      kindDisplay: json["kind_display"],
      createdAt: json["create_dt"] != null
          ? DateTime.parse(json['create_dt'] as String).toLocal()
          : null,
    );
  }

  @override
  List<Object?> get props => [
        createdAt,
        kindDisplay,
      ];
}
