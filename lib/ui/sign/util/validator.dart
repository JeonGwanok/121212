import 'field_status.dart';

class Validator {
  static PhoneFieldStatus phoneValidator(String value) {
    if (value.isEmpty) {
      return PhoneFieldStatus.initial;
    }

    if (!RegExp(r'^01([0|1|6|7|8|9]?)?([0-9]{3,4})?([0-9]{4})$')
            .hasMatch(value) ||
        value.length < 11) {
      return PhoneFieldStatus.invalid;
    }

    return PhoneFieldStatus.valid;
  }

  static NickNameFieldStatus nickNameValidator(String value) {
    if (value.isEmpty) {
      return NickNameFieldStatus.initial;
    }

    if (!RegExp(r'^[a-zA-Z0-9ㄱ-ㅎ가-힣]+$').hasMatch(value) ||
        value.length < 2 ||
        (!(RegExp(r'(?=.*?[ㄱ-ㅎ가-힣])').hasMatch(value) ||
            RegExp(r'(?=.*?[A-Z])').hasMatch(value) ||
            RegExp(r'(?=.*?[a-z])').hasMatch(value)))) {
      return NickNameFieldStatus.invalid;
    }
    return NickNameFieldStatus.valid;
  }

  static NickNameFieldStatus nameNameValidator(String value) {
    if (value.isEmpty) {
      return NickNameFieldStatus.initial;
    }

    if (!RegExp(r'^[a-zA-Zㄱ-ㅎ가-힣]+$').hasMatch(value) || value.length < 2) {
      return NickNameFieldStatus.invalid;
    }
    return NickNameFieldStatus.success;
  }

  static SchoolFieldStatus schoolValidator(String value) {
    if (value.isEmpty) {
      return SchoolFieldStatus.initial;
    }

    if (!RegExp(r'^[a-zA-Zㄱ-ㅎ가-힣]+$').hasMatch(value) || value.length < 2) {
      return SchoolFieldStatus.invalid;
    }
    return SchoolFieldStatus.success;
  }

  static EmailFieldStatus emailValidator(String value) {
    if (value.isEmpty) {
      return EmailFieldStatus.initial;
    }
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
      return EmailFieldStatus.invalid;
    }
    return EmailFieldStatus.valid;
  }

  static PasswordFieldStatus passwordValidator(String value) {
    if (value.isEmpty) {
      return PasswordFieldStatus.initial;
    }
    if (!RegExp(r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[_!@#=\$%&*~^$`?/.,:;<>()-+|{}]).{8,20}$')
        .hasMatch(value)) {
      return PasswordFieldStatus.invalid;
    }
    return PasswordFieldStatus.success;
  }
}
