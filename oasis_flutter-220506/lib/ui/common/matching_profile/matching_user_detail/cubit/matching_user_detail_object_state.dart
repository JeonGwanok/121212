import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/user/certificate.dart';

class MatchingUserDetailObjectState extends Equatable {
  final ScreenStatus status;
  final Certificate certificate;

  MatchingUserDetailObjectState({
    this.status = ScreenStatus.success,
    this.certificate = Certificate.empty,
  });

  MatchingUserDetailObjectState copyWith({
    ScreenStatus? status,
    Certificate? certificate,
  }) {
    return MatchingUserDetailObjectState(
      status: status ?? this.status,
      certificate: certificate ?? this.certificate,
    );
  }

  @override
  List<Object?> get props => [
        status,
        certificate,
      ];
}
