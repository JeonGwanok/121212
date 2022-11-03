part of 'sign_in_cubit.dart';

class SignInState extends Equatable {
  final SignStatus status;

  final String phoneN;
  final String pw;
  final PhoneFieldStatus phoneStatus;
  final PasswordFieldStatus passwordStatus;

  final List<SignInOption> signInOptions;

  final DateTime? updatedAt;

  SignInState({
    this.status = SignStatus.initial,
    this.phoneN = "",
    this.pw = "",
    this.phoneStatus = PhoneFieldStatus.initial,
    this.passwordStatus = PasswordFieldStatus.initial,
    this.signInOptions = const [],
    this.updatedAt,
  });

  get validEmail =>
      phoneStatus == PhoneFieldStatus.valid ||
      phoneStatus == PhoneFieldStatus.initial;

  get validPassword =>
      passwordStatus == PasswordFieldStatus.success ||
      passwordStatus == PasswordFieldStatus.initial;

  get enabledButton =>
      phoneStatus == PhoneFieldStatus.valid &&
      passwordStatus == PasswordFieldStatus.success;

  SignInState copyWith({
    SignStatus? status,
    String? email,
    String? pw,
    PhoneFieldStatus? emailStatus,
    PasswordFieldStatus? pwStatus,
    List<SignInOption>? signInOptions,
    DateTime? updatedAt,
  }) {
    return SignInState(
      status: status ?? this.status,
      phoneN: email ?? this.phoneN,
      pw: pw ?? this.pw,
      phoneStatus: emailStatus ?? this.phoneStatus,
      passwordStatus: pwStatus ?? this.passwordStatus,
      signInOptions: signInOptions ?? this.signInOptions,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        status,
        phoneN,
        pw,
        phoneStatus,
        passwordStatus,
        signInOptions,
        updatedAt,
      ];
}
