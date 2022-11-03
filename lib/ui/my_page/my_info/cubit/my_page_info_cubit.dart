import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/sign/sign_up/component/terms/terms_model.dart';

import 'my_page_info_state.dart';

class MyPageInfoCubit extends Cubit<MyPageInfoState> {
  final UserRepository userRepository;
  final CommonRepository commonRepository;

  MyPageInfoCubit({
    required this.userRepository,
    required this.commonRepository,
  }) : super(MyPageInfoState());

  initialize() async {
    try {
      var user = await userRepository.getUser();

      var _terms = await commonRepository.getTerms();

      var signUpTerm = TermsModel(
        title: "이용 약관",
        required: true,
        content: _terms.joinTerms ?? "",
      );

      var privacyTerm = TermsModel(
        title: "개인정보 처리방침",
        required: true,
        content: _terms.informationProcessTerms ?? "",
      );

      // var locationTerm = TermsModel(
      //   title: "위치기반서비스 이용약관",
      //   required: true,
      //   content: _terms.locationServiceTerms ?? "",
      // );

      emit(state.copyWith(
        user: user,
        terms: [signUpTerm, privacyTerm, /*locationTerm,*/],
        status: ScreenStatus.success,
      ));
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }
}
