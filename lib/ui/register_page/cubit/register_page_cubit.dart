import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/bloc/app/app_event.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/repository/user_repository.dart';

part 'register_page_state.dart';

class RegisterPageCubit extends Cubit<RegisterPageState> {
  final UserRepository userRepository;
  final int initialPage;
  final AppBloc appBloc;

  RegisterPageCubit({
    required this.initialPage,
    required this.appBloc,
    required this.userRepository,
  }) : super(RegisterPageState(page: initialPage));

  initialize() async {
    try {
      var user = await userRepository.getUser();
      emit(state.copyWith(user: user));
    } catch (_) {}
  }

  void prev() {
    var page = state.page;
    if (page != 0) {
      // 처음 페이지가 아니면
      emit(state.copyWith(page: page - 1));
    }
  }

  void next() async {
    var page = state.page;

    if (page == 5) {
      try {
        await userRepository.completeJoin("${state.user.customer?.id}");
        appBloc.add(AppInitialize());
      } catch (_) {}
    } else {
      if (page == 4) {
        try {
          await userRepository
              .completeCertificate("${state.user.customer?.id}");
        } catch (err) {}
      }

      emit(state.copyWith(
        page: min(page + 1, 5),
      ));
    }
  }
}
