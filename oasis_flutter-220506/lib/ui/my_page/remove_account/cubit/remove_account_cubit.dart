import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/my_page/remove_account/cubit/remove_account_state.dart';
import 'package:oasis/ui/sign/util/validator.dart';

class RemoveAccountCubit extends Cubit<RemoveAccountState> {
  final UserRepository userRepository;
  RemoveAccountCubit({
    required this.userRepository,
  }) : super(RemoveAccountState());

  initialize() async {
    emit(state.copyWith(status: RemoveAccountStatus.loading));
    var user = await userRepository.getUser();
    emit(
      state.copyWith(
        user: user,
        status: RemoveAccountStatus.loaded,
      ),
    );
  }

  changePasswordValue(String password) {
    var passwordStatus = Validator.passwordValidator(password);
    emit(state.copyWith(
        password: password, passwordFieldStatus: passwordStatus));
  }

  changeInconvenientValue(String inconvenient) {
    emit(state.copyWith(inconvenient: inconvenient));
  }

  changeDetailInconvenientValue(String inconvenient) {
    emit(state.copyWith(inconvenient: inconvenient));
  }

  deleteUser() async {
    try {
      emit(state.copyWith(status: RemoveAccountStatus.loading));
      await userRepository.deleteUser(
          "${state.user.customer!.id}", state.password, state.inconvenient + state.detailInconvenient);
      emit(state.copyWith(status: RemoveAccountStatus.deleteUser));
    } on ApiClientException catch (err) {
      if (err.detail == "Password Wrong") {
        emit(state.copyWith(status: RemoveAccountStatus.wrongPassword));
      } else {
        emit(state.copyWith(status: RemoveAccountStatus.fail));
      }
    }
  }
}
