import 'package:equatable/equatable.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/ui/sign/util/field_status.dart';

enum RemoveAccountStatus {
  initial,
  loaded,
  loading,
  fail,
  wrongPassword,
  deleteUser,
  success,
}

class RemoveAccountState extends Equatable {
  final RemoveAccountStatus status;
  final UserProfile user;
  final String password;
  final PasswordFieldStatus passwordFieldStatus;
  final String inconvenient;
final String detailInconvenient;
  RemoveAccountState({
    this.status = RemoveAccountStatus.initial,
    this.user = UserProfile.empty,
    this.password = "",
    this.detailInconvenient = "",
    this.inconvenient = "",
    this.passwordFieldStatus = PasswordFieldStatus.initial,
  });

  bool get enabled => passwordFieldStatus == PasswordFieldStatus.success && inconvenient.isNotEmpty;

  RemoveAccountState copyWith({
    RemoveAccountStatus? status,
    UserProfile? user,
    String? password,
    String? inconvenient,
    String? detailInconvenient,
    PasswordFieldStatus? passwordFieldStatus,
  }) {
    return RemoveAccountState(
      status: status ?? this.status,
      user: user ?? this.user,
      inconvenient: inconvenient ?? this.inconvenient,
      password: password ?? this.password,
      detailInconvenient: detailInconvenient?? this.detailInconvenient,
      passwordFieldStatus: passwordFieldStatus ?? this.passwordFieldStatus,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,detailInconvenient,
        password,
        inconvenient,
        passwordFieldStatus,
      ];
}
