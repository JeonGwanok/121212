import 'package:equatable/equatable.dart';
import 'package:oasis/ui/register_user_info/common/base_info/gender_select.dart';

class Customer extends Equatable {
  final int? id;
  final String? email;
  final String? username;
  final String? nickName; //nick_name
  final bool? religionAgree; // religion_agree,
  final bool? marketingAgree; // marketing_agree,
  final String? name;
  final Gender? gender;
  final String? birth; // 2021-11-13
  final bool? essentialStatus;
  final bool? certificateStatus;
  final bool? joinStatus;
  final bool? choiceStatus;
  final bool? paymentStatus;
  final bool? mbtiStatus;
  final bool? propensityStatus;
  final bool? identityStatus;
  final bool? crimeStatus;
  final String? membership;
  final String? recommandCode;
  final DateTime? membership_end_date;
  final bool? is_event;

  final bool? receiveProposeStatus; // "receive_propose_status": true,
  final String? mbti; // "mbti": "string",
  final String? loveType; // "love_type": "string",
  final int? meetingRemainCount; // "meeting_remain_count": 0,
  final int? meetingTotalCount; //meeting_total_count
  final String? nowStatus; // "now_status": "string",
  final String? deviceToken; // "device_token": "string",
  final String? deviceOS; // "device_os": "string"
  final DateTime? lastMeeting;

  const Customer({
    this.id,
    this.email,
    this.nickName,
    this.username,
    this.religionAgree,
    this.marketingAgree,
    this.certificateStatus,
    this.joinStatus,
    this.name,
    this.gender,
    this.birth,
    this.essentialStatus,
    this.choiceStatus,
    this.paymentStatus,
    this.mbtiStatus,
    this.propensityStatus,
    this.identityStatus,
    this.crimeStatus,
    this.membership,
    this.receiveProposeStatus,
    this.mbti,
    this.loveType,
    this.meetingRemainCount,
    this.meetingTotalCount,
    this.nowStatus,
    this.deviceToken,
    this.deviceOS,
    this.recommandCode,
    this.lastMeeting,
    this.membership_end_date,
    this.is_event,
  });

  int get age {
    if ((birth ?? "").isNotEmpty) {
      var birthYear = DateTime.now().year -
          int.parse((birth ?? "2022").substring(0, 4)) +
          1;
      return birthYear;
    }
    return 0;
  }

  static const empty = Customer();

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json["id"],
      email: json["email"],
      username: json["username"],
      nickName: json["nick_name"],
      religionAgree: json["religion_agree"],
      marketingAgree: json["marketing_agree"],
      name: json["name"] ?? "",
      gender: json["gender"] != null ? genderStringToKey(json["gender"]) : null,
      certificateStatus: json["certificate_status"],
      joinStatus: json["join_status"],
      birth: json["birth"] ?? "",
      essentialStatus: json["essential_status"],
      choiceStatus: json["choice_status"],
      paymentStatus: json["payment_status"],
      mbtiStatus: json["mbti_status"],
      propensityStatus: json["propensity_status"],
      identityStatus: json["identity_status"],
      crimeStatus: json["crime_status"],
      membership: json["membership"],
      receiveProposeStatus: json["receive_propose_status"],
      mbti: json["mbti"],
      loveType: json["love_type"],
      meetingRemainCount: json["meeting_remain_count"],
      meetingTotalCount: json["meeting_total_count"],
      nowStatus: json["now_status"],
      deviceToken: json["device_token"],
      deviceOS: json["device_os"],
      is_event: json["is_event"],
      recommandCode: json["recommand_code"],
      lastMeeting: json["last_meeting"] != null
          ? DateTime.parse(json['last_meeting'] as String).toLocal()
          : null,
      membership_end_date: json["membership_end_date"] != null
          ? DateTime.parse(json['membership_end_date'] as String).toLocal()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "is_event": is_event,
      "email": email,
      "nick_name": nickName,
      "join_status": joinStatus,
      "religion_agree": religionAgree,
      "marketing_agree": religionAgree,
      "name": name,
      "gender": gender != null ? gender!.title : null,
      "birth": birth,
      "essential_status": essentialStatus,
      "choice_status": choiceStatus,
      "mbti_status": mbtiStatus,
      "payment_status": paymentStatus,
      "propensity_status": propensityStatus,
      "identity_status": identityStatus,
      "crime_status": crimeStatus,
      "membership": membership,
      "certificate_status": certificateStatus,
      "receive_propose_status": receiveProposeStatus,
      "mbti": mbti,
      "love_type": loveType,
      "meeting_remain_count": meetingRemainCount,
      "now_status": nowStatus,
      "device_token": deviceToken,
      "device_os": deviceOS,
      "meeting_total_count": meetingTotalCount,
      "recommand_code": recommandCode,
      "membership_end_date": membership_end_date,
    };
  }

  Customer copyWith({
    int? id,
    String? username,
    bool? is_event,
    String? email,
    String? nickName,
    bool? joinStatus,
    bool? religionAgree,
    bool? marketingAgree,
    String? name,
    bool? certificateStatus,
    Gender? gender,
    String? birth,
    bool? essentialStatus,
    bool? choiceStatus,
    bool? paymentStatus,
    bool? mbtiStatus,
    bool? propensityStatus,
    bool? identityStatus,
    bool? crimeStatus,
    String? membership,
    bool? receiveProposeStatus,
    String? mbti,
    String? love_type,
    int? meetingRemainCount,
    String? nowStatus,
    String? deviceToken,
    String? deviceOS,
    int? meetingTotalCount,
    String? recommandCode,
    DateTime? last_meeting,
    DateTime? membership_end_date,
  }) {
    return Customer(
      id: id ?? this.id,
      is_event: is_event ?? this.is_event,
      certificateStatus: certificateStatus ?? this.certificateStatus,
      username: username ?? this.username,
      email: email ?? this.email,
      nickName: nickName ?? this.nickName,
      religionAgree: religionAgree ?? this.religionAgree,
      marketingAgree: marketingAgree ?? this.marketingAgree,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birth: birth ?? this.birth,
      essentialStatus: essentialStatus ?? this.essentialStatus,
      choiceStatus: choiceStatus ?? this.choiceStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      mbtiStatus: mbtiStatus ?? this.mbtiStatus,
      propensityStatus: propensityStatus ?? this.propensityStatus,
      identityStatus: identityStatus ?? this.identityStatus,
      crimeStatus: crimeStatus ?? this.crimeStatus,
      membership: membership ?? this.membership,
      receiveProposeStatus: receiveProposeStatus ?? this.receiveProposeStatus,
      mbti: mbti ?? this.mbti,
      loveType: love_type ?? this.loveType,
      meetingRemainCount: meetingRemainCount ?? this.meetingRemainCount,
      nowStatus: nowStatus ?? this.nowStatus,
      deviceToken: deviceToken ?? this.deviceToken,
      deviceOS: deviceOS ?? this.deviceOS,
      meetingTotalCount: meetingTotalCount ?? this.meetingTotalCount,
      recommandCode: recommandCode ?? this.recommandCode,
      joinStatus: joinStatus ?? this.joinStatus,
      lastMeeting: last_meeting ?? this.lastMeeting,
      membership_end_date: membership_end_date ?? this.membership_end_date,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        joinStatus,
        email,
        nickName,
        religionAgree,
        marketingAgree,
        name,
        gender,
        birth,
        essentialStatus,
        choiceStatus,
        paymentStatus,
        mbtiStatus,
        propensityStatus,
        identityStatus,
        crimeStatus,
        receiveProposeStatus,
        mbti,
        certificateStatus,
        loveType,
        meetingRemainCount,
        nowStatus,
        deviceToken,
        deviceOS,
        meetingTotalCount,
        recommandCode,
        is_event,
        lastMeeting,
        membership_end_date,
      ];
}
