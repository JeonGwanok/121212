part of 'password_reset_phone_cubit.dart';

class PasswordResetPhoneState extends Equatable {
  final SignStatus status;

  final String phoneN;
  final PhoneFieldStatus phoneStatus;

  final DateTime? updatedAt;

  PasswordResetPhoneState({
    this.status = SignStatus.initial,
    this.phoneN = "",
    this.phoneStatus = PhoneFieldStatus.initial,
    this.updatedAt,
  });

  get validEmail =>
      phoneStatus == PhoneFieldStatus.valid ||
      phoneStatus == PhoneFieldStatus.initial;

  PasswordResetPhoneState copyWith({
    SignStatus? status,
    String? email,
    String? pw,
    PhoneFieldStatus? emailStatus,
    DateTime? updatedAt,
  }) {
    return PasswordResetPhoneState(
      status: status ?? this.status,
      phoneN: email ?? this.phoneN,
      phoneStatus: emailStatus ?? this.phoneStatus,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        status,
        phoneN,
        phoneStatus,
        updatedAt,
      ];
}
