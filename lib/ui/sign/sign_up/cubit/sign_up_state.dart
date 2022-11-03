part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  final SignStatus status;

  final List<TermsModel> terms; // 목록
  final List<TermsModel> selectedTerms;
  final String phoneN;
  final String email;
  final String password;
  final String rePassword;
  final String nickName;
  final String recommendId;


  final String? birthday;
  final String name;
  final Gender gender;

  final NickNameFieldStatus nickNameStatus;

  final EmailFieldStatus emailStatus;
  final PhoneFieldStatus phoneStatus;
  final PasswordFieldStatus passwordStatus;
  final RepasswordFieldStatus repwStatus;

  final int page;

  SignUpState({
    this.status = SignStatus.initial,
    this.phoneN = "",
    this.terms = const [],
    this.selectedTerms = const [],
    this.email = "",
    this.password = "",
    this.rePassword = "",
    this.nickName = "",
    this.recommendId = "",
    this.nickNameStatus = NickNameFieldStatus.initial,
    this.emailStatus = EmailFieldStatus.initial,
    this.phoneStatus = PhoneFieldStatus.initial,
    this.passwordStatus = PasswordFieldStatus.initial,
    this.repwStatus = RepasswordFieldStatus.initial,
    this.page = 0,
    this.birthday,
    this.gender = Gender.female,
    this.name = "",
  });

  bool get isLast => page == 5;

  bool get enableButton {
    if (page == 0) {
      for (var i = 0; i < terms.length; i++) {
        if (terms[i].required) {
          if (!this.selectedTerms.contains(terms[i])) {
            return false;
          }
        }
      }
      return true;
    } else if (page == 1) {
      // 휴대폰
      return phoneStatus == PhoneFieldStatus.success;
    } else if (page == 2) {
      return emailStatus == EmailFieldStatus.success;
    } else if (page == 3) {
      // 닉네임
      return nickNameStatus == NickNameFieldStatus.success;
    } else if (page == 4) {
      // 비밀번호
      return passwordStatus == PasswordFieldStatus.success &&
          repwStatus == RepasswordFieldStatus.success;
    } else if (page == 5) {
      // 추천인 코드
      return true;
    }
    return false;
  }

  SignUpState copyWith({
    SignStatus? status,
    List<TermsModel>? selectedTerms,
    List<TermsModel>? terms,
    String? email,
    String? phoneN,
    String? password,
    String? repw,
    String? nickName,
    EmailFieldStatus? emailStatus,
    PhoneFieldStatus? phoneStatus,
    PasswordFieldStatus? passwordStatus,
    RepasswordFieldStatus? repasswordStatus,
    int? page,
    NickNameFieldStatus? nickNameStatus,
    String? recommendId,
    String? birthday,
    String? name,
    Gender? gender,
  }) {
    return SignUpState(
      status: status ?? this.status,
      phoneN: phoneN ?? this.phoneN,
      selectedTerms: selectedTerms ?? this.selectedTerms,
      terms: terms ?? this.terms,
      email: email ?? this.email,
      password: password ?? this.password,
      rePassword: repw ?? this.rePassword,
      nickName: nickName ?? this.nickName,
      emailStatus: emailStatus ?? this.emailStatus,
      phoneStatus: phoneStatus ?? this.phoneStatus,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      repwStatus: repasswordStatus ?? this.repwStatus,
      page: page ?? this.page,
      nickNameStatus: nickNameStatus ?? this.nickNameStatus,
      recommendId: recommendId ?? this.recommendId,
        birthday: birthday ?? this.birthday,
        name: name ?? this.name,
        gender: gender ?? this.gender,
    );
  }

  @override
  List<Object?> get props => [
        status,
        phoneN,
        terms,
        selectedTerms,
        email,
        nickName,
        password,
        recommendId,
        rePassword,
        emailStatus,
        passwordStatus,
        phoneStatus,
        repwStatus,
        page,
        nickNameStatus,
    birthday,name,gender,

      ];
}
