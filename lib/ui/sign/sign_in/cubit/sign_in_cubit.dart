import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/repository/auth_repository.dart';
import 'package:oasis/ui/sign/sign_in/enum/sign_in_option.dart';
import 'package:oasis/ui/sign/util/field_status.dart';
import 'package:oasis/ui/sign/util/sign_status.dart';
import 'package:oasis/ui/sign/util/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final AuthRepository authRepository;
  SignInCubit({required this.authRepository}) : super(SignInState());

  late SharedPreferences _prefs;

  void initialize() async {
    _prefs = await SharedPreferences.getInstance();
    var phoneN = _prefs.getString("signId") ?? "";
    List<SignInOption> options = [];
    if (phoneN != "") {
      options.add(SignInOption.saveId);
    }

    var emailStatus = Validator.phoneValidator(phoneN);

    emit(state.copyWith(
        signInOptions: options,
        email: phoneN,
        emailStatus: emailStatus,
        status: SignStatus.loaded));
  }

  void changeOption(SignInOption item) {
    List<SignInOption> options = [...state.signInOptions];
    if (state.signInOptions.contains(item)) {
      options.remove(item);
    } else {
      options.add(item);
    }
    emit(state.copyWith(signInOptions: options));
  }

  void changePhoneN(String email) {
    var emailStatus = Validator.phoneValidator(email);
    emit(
        state.copyWith(email: email, emailStatus: emailStatus, pwStatus: null));
  }

  void changePassword(String password) {
    var passwordStatus = Validator.passwordValidator(password);
    emit(state.copyWith(
        pw: password, pwStatus: passwordStatus, emailStatus: null));
  }

  void login() async {
    emit(state.copyWith(status: SignStatus.loading));

    if (state.signInOptions.contains(SignInOption.autoLogin)) {
      _prefs.setBool("autoSignIn", true);
    }

    if (state.signInOptions.contains(SignInOption.saveId)) {
      _prefs.setString("signId", state.phoneN);
    }

    try {
      // api 호출
      await authRepository.signIn(state.phoneN, state.pw);
      emit(state.copyWith(
        status: SignStatus.success,
      ));
    } on ApiClientException catch (err) {
      if (err.statusCode == 404) {
        if (err.detail == "No Username") {
          emit(state.copyWith(
            status: SignStatus.fail,
            emailStatus: PhoneFieldStatus.userNotFound,
            updatedAt: DateTime.now(),
            // pwStatus: PasswordFieldStatus.s,
          ));
        }
        if (err.detail == "Password Wrong") {
          emit(state.copyWith(
            status: SignStatus.fail,
            updatedAt: DateTime.now(),
            // emailStatus: PhoneFieldStatus.fail,
            pwStatus: PasswordFieldStatus.wrong,
          ));
        }
      } else {
        emit(state.copyWith(
          status: SignStatus.fail,
          emailStatus: PhoneFieldStatus.fail,
          pwStatus: PasswordFieldStatus.fail,
          updatedAt: DateTime.now(),
        ));
      }
    }
  }
}
