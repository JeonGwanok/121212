import 'package:equatable/equatable.dart';

enum CertificateStatusType {
  none,
  wait,
  back,
  complete,
}

extension CertificateStatusTypeExtension on CertificateStatusType {
  String? get key {
    switch (this) {
      case CertificateStatusType.none:
        return null;
      case CertificateStatusType.wait:
        return "WAIT";
      case CertificateStatusType.back:
        return "BACK";
      case CertificateStatusType.complete:
        return "COMPLETE";
    }
  }

  String get statusTitle {
    switch (this) {
      case CertificateStatusType.none:
        return "미인증";
      case CertificateStatusType.wait:
        return "인증 대기중";
      case CertificateStatusType.back:
        return "인증 반려";
      case CertificateStatusType.complete:
        return "인증 완료";
    }
  }

  bool get enableButton {
    switch (this) {
      case CertificateStatusType.none:
        return true;
      case CertificateStatusType.wait:
        return false;
      case CertificateStatusType.back:
        return true;
      case CertificateStatusType.complete:
        return false;
    }
  }
}

CertificateStatusType certificateStatusTypeToType(String? title) {
  switch (title) {
    case "COMPLETE":
      return CertificateStatusType.complete;
    case "BACK":
      return CertificateStatusType.back;
    case "WAIT":
      return CertificateStatusType.wait;
  }
  return CertificateStatusType.none;
}

class Certificate extends Equatable {
  final bool? graduation;
  final bool? marriage;
  final bool? job;
  final CertificateStatusType graduationStatus; //graduation_staus
  final CertificateStatusType marriageStatus; //marriage_staus
  final CertificateStatusType jobStatus; //job_staus
  final List<CertificateFile>? files;

  const Certificate({
    this.graduation,
    this.marriage,
    this.job,
    this.graduationStatus = CertificateStatusType.none, //graduation_staus
    this.marriageStatus = CertificateStatusType.none, //marriage_staus
    this.jobStatus = CertificateStatusType.none, //job_staus
    this.files,
  });

  static const empty = Certificate();

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      graduation: json["graduation"],
      marriage: json["marriage"],
      job: json["job"],
      graduationStatus: certificateStatusTypeToType(json["graduation_status"]),
      marriageStatus: certificateStatusTypeToType(json["marriage_status"]),
      jobStatus: certificateStatusTypeToType(json["job_status"]),
      files: ((json["files"] ?? []) as List<dynamic>)
          .map((e) => CertificateFile.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "graduation": graduation,
      "marriage": marriage,
      "job": job,
      "graduation_status": graduationStatus.key,
      "marriage_status": marriageStatus.key,
      "job_status": jobStatus.key,
      "files": files,
    };
  }

  Certificate copyWith({
    bool? graduation,
    bool? marriage,
    bool? job,
    CertificateStatusType? graduationStaus,
    CertificateStatusType? marriageStaus,
    CertificateStatusType? jobStaus,
    List<CertificateFile>? files,
  }) {
    return Certificate(
      graduation: graduation ?? this.graduation,
      marriage: marriage ?? this.marriage,
      job: job ?? this.job,
      graduationStatus: graduationStaus ?? this.graduationStatus,
      marriageStatus: marriageStaus ?? this.marriageStatus,
      jobStatus: jobStaus ?? this.jobStatus,
      files: files ?? this.files,
    );
  }

  @override
  List<Object?> get props => [
        graduation,
        marriage,
        job,
        graduationStatus,
        marriageStatus,
        jobStatus,
        files,
      ];
}

class CertificateFile extends Equatable {
  final int? id;
  final String? certificateFile; // certificate_file
  final String? typeName; // type_name
  final CertificateStatusType status;

  const CertificateFile({
    this.id,
    this.certificateFile,
    this.typeName,
    this.status = CertificateStatusType.none,
  });

  static const empty = CertificateFile();

  factory CertificateFile.fromJson(Map<String, dynamic> json) {
    return CertificateFile(
      id: json["id"],
      certificateFile: json["certificate_file"],
      typeName: json["type_name"],
      status: certificateStatusTypeToType(json["status"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "certificate_file": certificateFile,
      "type_name": typeName,
      "status": status.key,
    };
  }

  CertificateFile copyWith({
    int? id,
    String? certificateFile,
    String? typeName,
    CertificateStatusType? status,
  }) {
    return CertificateFile(
      id: id ?? this.id,
      certificateFile: certificateFile ?? this.certificateFile,
      typeName: typeName ?? this.typeName,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id, certificateFile, typeName, status];
}
