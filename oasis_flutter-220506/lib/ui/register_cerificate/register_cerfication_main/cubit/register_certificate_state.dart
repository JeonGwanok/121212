import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/user/certificate.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/ui/sign/sign_up/component/terms/terms_model.dart';

class RegisterCertificateState extends Equatable {
  final ScreenStatus status;
  final UserProfile userProfile;
  final Certificate certificate;

  RegisterCertificateState({
    this.status = ScreenStatus.initial,
    this.userProfile = UserProfile.empty,
    this.certificate = Certificate.empty,
  });

  RegisterCertificateState copyWith({
    ScreenStatus? status,
    UserProfile? userProfile,
    Certificate? certificate,
  }) {
    return RegisterCertificateState(
      status: status ?? this.status,
      userProfile: userProfile ?? this.userProfile,
      certificate: certificate ?? this.certificate,
    );
  }

  bool get enableButton {
    return certificate.graduationStatus != CertificateStatusType.none &&
        certificate.jobStatus != CertificateStatusType.none &&
        certificate.marriageStatus != CertificateStatusType.none;
  }

  @override
  List<Object?> get props => [
        status,
        userProfile,
        certificate,
      ];
}
