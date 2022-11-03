import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oasis/repository/auth_repository.dart';
import 'package:oasis/ui/sign/util/field_status.dart';
import 'package:oasis/ui/sign/util/sign_status.dart';
import 'package:oasis/ui/sign/util/validator.dart';

part 'password_reset_phone_state.dart';

class PasswordResetPhoneCubit extends Cubit<PasswordResetPhoneState> {
  final AuthRepository authRepository;
  PasswordResetPhoneCubit({required this.authRepository})
      : super(PasswordResetPhoneState());

  void changePhoneN(String email) {
    var emailStatus = Validator.phoneValidator(email);
    emit(state.copyWith(
      email: email,
      emailStatus: emailStatus,
    ));
  }

  // 아임포트로 성공했을떄.
  void verifyPhoneN() async {
    try {
      emit(state.copyWith(status: SignStatus.loading));
      var result = await authRepository.usernameDuplicationCheck(state.phoneN);
      PhoneFieldStatus status = PhoneFieldStatus.initial;
      if (result) {
        status = PhoneFieldStatus.alreadyInUse;
      } else {
        status = PhoneFieldStatus.userNotFound;
      }

      emit(state.copyWith(emailStatus: status, status: SignStatus.success));
    } catch (_) {
      // 인증에 실패하였습니다.
      emit(state.copyWith(emailStatus: PhoneFieldStatus.fail));
    }
  }
}
