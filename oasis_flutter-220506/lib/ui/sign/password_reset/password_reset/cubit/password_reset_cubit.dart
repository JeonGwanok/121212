import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/auth_repository.dart';
import 'package:oasis/ui/sign/sign_in/enum/sign_in_option.dart';
import 'package:oasis/ui/sign/util/field_status.dart';
import 'package:oasis/ui/sign/util/sign_status.dart';
import 'package:oasis/ui/sign/util/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'password_reset_state.dart';

class PasswordResetCubit extends Cubit<PasswordResetState> {
  final String username;

  final AuthRepository authRepository;
  PasswordResetCubit({required this.username, required this.authRepository})
      : super(PasswordResetState());

  void changePassword(String password) {
    var pwStatus = Validator.passwordValidator(password);
    var repwStatus = RepasswordFieldStatus.initial;

    if (state.rePassword == "" && password == "") {
      pwStatus = PasswordFieldStatus.initial;
      repwStatus = RepasswordFieldStatus.initial;
    } else if (state.rePassword != "") {
      repwStatus = password == state.rePassword
          ? RepasswordFieldStatus.success
          : RepasswordFieldStatus.unMatched;
    } else {
      repwStatus = RepasswordFieldStatus.fail;
    }

    emit(state.copyWith(
      password: password,
      passwordStatus: pwStatus,
      repwStatus: repwStatus,
    ));
  }

  void changeRepassword(String password) {
    emit(state.copyWith(
        rePassword: password,
        repwStatus: password == state.password
            ? RepasswordFieldStatus.success
            : RepasswordFieldStatus.unMatched));
  }

  void resetPassword() async {
    emit(state.copyWith(status: ScreenStatus.loading));
    try {
      await authRepository.resetPassword(
        password: state.password,
        username: username,
      );
      emit(state.copyWith(status: ScreenStatus.success));
    } catch (err) {
      emit(state.copyWith(
        status: ScreenStatus.fail,
        updatedAt: DateTime.now(),
        repwStatus: RepasswordFieldStatus.fail,
        passwordStatus: PasswordFieldStatus.fail,
      ));
    }
  }
}
