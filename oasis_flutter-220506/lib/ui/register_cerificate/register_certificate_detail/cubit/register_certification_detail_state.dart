import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/user/certificate.dart';
import 'package:oasis/model/user/user_profile.dart';

class RegisterCertificationDetailState extends Equatable {
  final ScreenStatus status;
  final UserProfile userProfile;
  final Certificate certificate;

  final String? imageUrl;
  final File? file;

  RegisterCertificationDetailState({
    this.status = ScreenStatus.initial,
    this.userProfile = UserProfile.empty,
    this.certificate = Certificate.empty,
    this.imageUrl,
    this.file,
  });

  RegisterCertificationDetailState copyWith({
    ScreenStatus? status,
    UserProfile? userProfile,
    Certificate? certificate,
    String? imageUrl,
    File? file,
  }) {
    return RegisterCertificationDetailState(
      status: status ?? this.status,
      userProfile: userProfile ?? this.userProfile,
      certificate: certificate ?? this.certificate,
      imageUrl: imageUrl ?? this.imageUrl,
      file: file ?? this.file,
    );
  }

  @override
  List<Object?> get props => [
        status,
        userProfile,
        certificate,
        imageUrl,
        file,
      ];
}
