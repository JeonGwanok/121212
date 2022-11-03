import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:oasis/model/user/user_profile.dart';

class MeetingResponse extends Equatable {
  final UserProfile? myInfo;
  final UserProfile? loverInfo;
  final Meeting? meeting; // meeting
  final String? weather;
  final String? storyWrite; // story_write
  final List<Schedule>? schedule;
  final bool? sendStatus; // 내가 보낸 프로포즈이면 true

  MeetingResponse({
    this.myInfo,
    this.loverInfo,
    this.meeting,
    this.weather,
    this.storyWrite,
    this.schedule,
    this.sendStatus,
  });

  factory MeetingResponse.fromJson(Map<String, dynamic> json) {
    return MeetingResponse(
      myInfo: json["my_info"] != null
          ? UserProfile.fromJson(json["my_info"])
          : null,
      loverInfo: json["lover_info"] != null
          ? UserProfile.fromJson(json["lover_info"])
          : null,
      meeting:
          json["meeting"] != null ? Meeting.fromJson(json["meeting"]) : null,
      storyWrite: json["story_write"],
      weather: json["weather"],
      schedule: ((json["schedule"] ?? []) as List<dynamic>)
          .map((e) => Schedule.fromJson(e))
          .toList(),
      sendStatus: json["send_status"],
    );
  }

  @override
  List<Object?> get props => [
        myInfo,
        loverInfo,
        meeting,
        storyWrite,
        schedule,
        weather,
        sendStatus,
      ];
}

class Meeting extends Equatable {
  final int? id; // "id": 0,
  final int? propose; // "propose": 0,
  final DateTime? date; // "date": "2022-01-05" 만나기로 한 날,
  final DateTime? create_dt; //매칭 확정 날짜
  final String? time; // "time": "string",
  final String? location; // "location": "string",
  final bool? meetingStatus; // "meeting_status": true,
  final bool? scheduleState; //schedule_state
  final String? latlngX; // "latlng_x": "string",
  final String? latlngY; // "latlng_y": "string",
  final String? buildingName; // "building_name": "string"

  const Meeting({
    this.id,
    this.propose,
    this.date,
    this.create_dt,
    this.time,
    this.location,
    this.meetingStatus,
    this.scheduleState,
    this.latlngX,
    this.latlngY,
    this.buildingName,
  });

  DateTime? get utcDate {
    if (date == null || time == null) {
      return null;
    }
    return DateTime.parse(
        "${DateFormat("yyyy-MM-dd").format(date ?? DateTime.now())} ${time ?? "00:00:00"}");
  }

  static const empty = Meeting();

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json["id"],
      propose: json["propose"],
      date: json["date"] != null
          ? DateTime.parse(json["date"] as String).toLocal()
          : null,
      time: json["time"],
      location: json["location"],
      meetingStatus: json["meeting_status"],
      scheduleState: json["schedule_state"],
      latlngX: json["latlng_x"],
      latlngY: json["latlng_y"],
      buildingName: json["building_name"],
        create_dt: json["create_dt"] != null
            ? DateTime.parse(json["create_dt"] as String).toLocal()
            : null,
    );
  }

  Meeting copyWith({
    int? id,
    int? propose,
    DateTime? date,
    String? time,
    String? location,
    bool? meetingStatus,
    bool? scheduleState,
    String? latlngX,
    String? latlngY,
    String? buildingName,
    DateTime? create_dt,
  }) {
    return Meeting(
      id: id ?? this.id,
      propose: propose ?? this.propose,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      meetingStatus: meetingStatus ?? this.meetingStatus,
      scheduleState: scheduleState ?? this.scheduleState,
      latlngX: latlngX ?? this.latlngX,
      latlngY: latlngY ?? this.latlngY,
      buildingName: buildingName ?? this.buildingName,
        create_dt: create_dt ?? this.create_dt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        propose,
        date,
        time,
        location,
        meetingStatus,
        scheduleState,
        latlngX,
        latlngY,
        buildingName,
    create_dt,
      ];
}

class Schedule extends Equatable {
  final int? id; //"id": 0,
  final DateTime? date; //"date": "2022-01-05",
  final String? time; //"time": "string"

  Schedule({
    this.id,
    this.date,
    this.time,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json["id"],
      date: json["date"] != null
          ? DateTime.parse(json["date"] as String).toLocal()
          : null,
      time: json["time"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "date": DateFormat("yyyy-MM-dd").format(date ?? DateTime.now()),
      "time": time,
    };
  }

  @override
  List<Object?> get props => [id, date, time];
}
