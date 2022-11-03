import 'package:equatable/equatable.dart';
import 'package:oasis/model/user/user_profile.dart';

enum ProposeStatus {
  intial, // 열여보지 않음
  accept, // 수락 됨
  autoRejected, // 프로포즈 자동거절
  endLove, // 연애 종료
  processLove, // 연애중
  afterMeeting, // 만남 후기 대기
  waitMeeting, // 만남 대기
  endMeeting, //만남 종료
  processMeetingSchedule, // 만남 일정 선택중

  cancelMeeting, // 만남 취소

  opened,
  rejected,
}

class Propose extends Equatable {
  final DateTime? createdAt; // "create_dt": "2021-12-23T05:04:54.036Z",
  final int? proposeId; //  "propose_id": 0,
  final bool? meetingStatus; //"meeting_status": true,
  final bool? openStatus; //"open_status": true,
  final bool? autoReject; // "auto_reject": true,
  final int? matchingRate; //"matching_rate": 0,
  final UserProfile? fromCustomer; //"from_customer":
  final UserProfile? toCustomer; // "to_customer"
  final String? currentStatus;

  const Propose({
    this.createdAt,
    this.proposeId,
    this.meetingStatus,
    this.openStatus,
    this.autoReject,
    this.matchingRate,
    this.fromCustomer,
    this.toCustomer,
    this.currentStatus,
  });

  static const empty = Propose();

  factory Propose.fromJson(Map<String, dynamic> json) {
    return Propose(
      createdAt: json['create_dt'] != null
          ? DateTime.parse(json['create_dt'] as String).toLocal()
          : null,
      openStatus: json["open_status"],
      proposeId: json["propose_id"],
      meetingStatus: json["meeting_status"],
      autoReject: json["auto_reject"],
      matchingRate: json["matching_rate"],
      fromCustomer: json["from_customer"] != null
          ? UserProfile.fromJson(json["from_customer"])
          : null,
      toCustomer: json["to_customer"] != null
          ? UserProfile.fromJson(json["to_customer"])
          : null,
      currentStatus: json["status"],
    );
  }

  ProposeStatus get status {
    // meetingStatus : 카드 수락했는지 거절했는지
    // openStatus : 카드 열어봤는지 안열어봤는지

    switch (currentStatus) {
      case "프로포즈 대기": // 미팅 전이면
        if (meetingStatus != null && meetingStatus!) {
          return ProposeStatus.accept;
        } else if (meetingStatus != null && !meetingStatus!) {
          return ProposeStatus.rejected;
        } else {
          if (openStatus ?? false) {
            return ProposeStatus.opened;
          } else {
            return ProposeStatus.intial;
          }
        }
      case "프로포즈 자동거절":
        return ProposeStatus.autoRejected;

      case "연애 종료":
        return ProposeStatus.endLove;
      case "연애중":
        return ProposeStatus.processLove;
      case "만남 후기 대기":
        return ProposeStatus.afterMeeting;
      case "만남대기":
        return ProposeStatus.waitMeeting;
      case "만남 종료":
        return ProposeStatus.endMeeting;
      case "만남 일정 선택중":
        return ProposeStatus.processMeetingSchedule;
    }

    return ProposeStatus.intial;
  }

  Propose copyWith({
    DateTime? createdAt,
    int? proposeId,
    bool? openStatus,
    bool? meetingStatus,
    bool? autoReject,
    int? matchingRate,
    UserProfile? fromCustomer,
    UserProfile? toCustomer,
    String? currentStatus,
  }) {
    return Propose(
      createdAt: createdAt ?? this.createdAt,
      proposeId: proposeId ?? this.proposeId,
      openStatus: openStatus ?? this.openStatus,
      meetingStatus: meetingStatus ?? this.meetingStatus,
      autoReject: autoReject ?? this.autoReject,
      matchingRate: matchingRate ?? this.matchingRate,
      fromCustomer: fromCustomer ?? this.fromCustomer,
      toCustomer: toCustomer ?? this.toCustomer,
      currentStatus: currentStatus ?? this.currentStatus,
    );
  }

  @override
  List<Object?> get props => [
        createdAt,
        proposeId,
        openStatus,
        meetingStatus,
        autoReject,
        matchingRate,
        fromCustomer,
        toCustomer,
        currentStatus,
      ];
}
