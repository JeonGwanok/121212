import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/bloc/app/app_event.dart';
import 'package:oasis/bloc/app/app_state.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/user/certificate.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/register_cerificate/register_cerfication_main/cubit/register_certificate_state.dart';

class RegisterCertificateCubit extends Cubit<RegisterCertificateState> {
  final AppBloc appBloc;
  final UserRepository userRepository;
  final CommonRepository commonRepository;
  RegisterCertificateCubit({
    required this.appBloc,
    required this.userRepository,
    required this.commonRepository,
  }) : super(RegisterCertificateState());

  initialize() async {
    try {
      var user = await userRepository.getUser();
      var certificate =
          await userRepository.getCertificate("${user.customer!.id!}");

      emit(
        state.copyWith(
          userProfile: user,
          certificate: certificate,
        ),
      );
    } catch (err) {
      emit(state.copyWith(
        status: ScreenStatus.fail,
      ));
    }
  }

  updateCertificate(Certificate certificate) {
    emit(state.copyWith(certificate: certificate));
  }

  update() async {
    emit(state.copyWith(status: ScreenStatus.loading));
    try {
      if (appBloc.state is AppLoaded) {
        appBloc.add(AppUpdate());
      }
      emit(state.copyWith(status: ScreenStatus.success));
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }
}
