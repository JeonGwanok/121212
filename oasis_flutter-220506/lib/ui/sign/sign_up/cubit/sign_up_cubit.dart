import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oasis/model/user/customer/create_user.dart';
import 'package:oasis/model/user/customer/customer.dart';
import 'package:oasis/model/user/customer/signInfo.dart';
import 'package:oasis/repository/auth_repository.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/ui/register_user_info/common/base_info/gender_select.dart';
import 'package:oasis/ui/sign/sign_up/component/terms/terms_model.dart';
import 'package:oasis/ui/sign/util/field_status.dart';
import 'package:oasis/ui/sign/util/sign_status.dart';
import 'package:oasis/ui/sign/util/validator.dart';
import 'package:oasis/util/text_filter.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final CommonRepository commonRepository;
  final AuthRepository authRepository;
  SignUpCubit({
    required this.commonRepository,
    required this.authRepository,
  }) : super(SignUpState());

  initialize() async {
    var _terms = await commonRepository.getTerms();

    var signUpTerm = TermsModel(
      title: "회원가입 약관 동의",
      required: true,
      content: _terms.joinTerms ?? "",
    );

    var privacyTerm = TermsModel(
      title: "개인정보처리방침",
      required: true,
      content: _terms.informationProcessTerms ?? "",
    );

    // var locationTerm = TermsModel(
    //   title: "위치기반 서비스",
    //   required: true,
    //   content: _terms.locationServiceTerms ?? "",
    // );

    var religionTerm = TermsModel(
      title: "종교 정보 이용 동의",
      required: true,
      content: _terms.religionTerms ?? "",
    );

    var marketingTerm = TermsModel(
      title: "마케팅 활용 동의",
      content: _terms.marketingTerms ?? "",
    );

    var crimeTerm = TermsModel(
        content: _terms.crimeTerms ?? "",
        title: '성범죄 정보 제공 동의',
        required: true);

    emit(state.copyWith(terms: [
      signUpTerm,
      privacyTerm,
      // locationTerm,
      crimeTerm,
      religionTerm,
      marketingTerm,
    ]));
  }

  void prev() {
    var page = state.page;
    if (page != 0) {
      emit(state.copyWith(page: page - 1));
    }
  }

  void next() async {
    var page = state.page;
    if (!state.isLast) {
      if (page == 1) {
        var birthYear = DateTime.now().year -
            int.parse(
                ((state.birthday ?? "").isEmpty ? "0000" : state.birthday!)
                    .split("-")
                    .first) +
            1;

        if (birthYear < 20) {
          emit(state.copyWith(status: SignStatus.disableBirth));
          Future.delayed(Duration.zero, () {
            emit(state.copyWith(status: SignStatus.loaded));
          });
        } else {
          emit(state.copyWith(page: page + 1));
        }
      } else {
        emit(state.copyWith(page: page + 1));
      }
    }
  }

  void changeTerms(List<TermsModel> terms) {
    emit(state.copyWith(selectedTerms: terms));
  }

  void changePhoneN(String phoneN) {
    var phoneStatus = Validator.phoneValidator(phoneN);
    emit(state.copyWith(phoneN: phoneN, phoneStatus: phoneStatus));
  }

  void verifyPhoneN(String impUid) async {
    try {
      // pass 호출
      // 이미 등록되어있는지부터 확인
      var result = await authRepository.usernameDuplicationCheck(state.phoneN);
      var iamprotResult = await commonRepository.getIamportInfo(impUid);

      emit(state.copyWith(
          name: iamprotResult.name,
          birthday: iamprotResult.birthday,
          gender: iamprotResult.gender,
          phoneStatus: result
              ? PhoneFieldStatus.alreadyInUse
              : PhoneFieldStatus.success));
    } catch (_) {
      emit(state.copyWith(phoneStatus: PhoneFieldStatus.invalid));
    }
  }

  void changeEmail(String email) {
    var emailStatus = Validator.emailValidator(email);
    emit(state.copyWith(email: email, emailStatus: emailStatus));
  }

  Future<bool> verifyEmail() async {
    try {
      var result = await authRepository.emailDuplicationCheck(state.email);
      emit(state.copyWith(
          emailStatus: result
              ? EmailFieldStatus.alreadyInUse
              : EmailFieldStatus.success));
      return !result;
    } catch (_) {
      emit(state.copyWith(emailStatus: EmailFieldStatus.fail));
    }
    return false;
  }

  void changeNickName(String nickName) {
    if (nickName.isEmpty) {
      emit(state.copyWith(
          nickName: nickName, nickNameStatus: NickNameFieldStatus.initial));
    } else {
      emit(state.copyWith(
          nickName: nickName,
          nickNameStatus: Validator.nickNameValidator(nickName)));
    }
  }

  void checkNickName() async {
    try {
      var hasSlang = false;
      for (var item in textFilter) {
        if (state.nickName.contains(item)) {
          hasSlang = true;
          break;
        }
      }

      if (hasSlang) {
        emit(state.copyWith(nickNameStatus: NickNameFieldStatus.hasSlang));
      } else {
        var result =
            await authRepository.nicknameDuplicationCheck(state.nickName);
        emit(state.copyWith(
            nickNameStatus: result
                ? NickNameFieldStatus.alreadyUse
                : NickNameFieldStatus.success));
      }
    } catch (_) {
      // 이미 등록되어있는 유저
      emit(state.copyWith(nickNameStatus: NickNameFieldStatus.fail));
    }
  }

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
      repasswordStatus: repwStatus,
    ));
  }

  void changeRepassword(String password) {
    emit(state.copyWith(
        repw: password,
        repasswordStatus: password == state.password
            ? RepasswordFieldStatus.success
            : RepasswordFieldStatus.unMatched));
  }

  void changeRecommendId(String recommendId) {
    emit(state.copyWith(recommendId: recommendId));
  }

  void signUp() async {
    emit(state.copyWith(status: SignStatus.loading));
    try {
      // api 호출 : 회원가입 - 하면서 추천인 코드 맞는지도 유효한지도 확인해야함
      await authRepository.signUp(
        CreateUser(
          user: SignInfo(
            username: state.phoneN,
            password: state.password,
          ),
          customer: Customer(
            recommandCode: state.recommendId,
            name: state.name,
            birth: state.birthday,
            gender: state.gender,
            email: state.email.isNotEmpty ? state.email : null,
            nickName: state.nickName,
            religionAgree: state.selectedTerms
                .where((e) => e.title == "종교 정보 이용 동의")
                .toList()
                .isNotEmpty,
            marketingAgree: state.selectedTerms
                .where((e) => e.title == "마케팅 활용 동의")
                .toList()
                .isNotEmpty,
            crimeStatus: true,
          ),
        ),
      );
      emit(state.copyWith(status: SignStatus.success));
    } catch (err) {
      emit(state.copyWith(
        status: SignStatus.fail,
        phoneStatus: PhoneFieldStatus.fail,
        repasswordStatus: RepasswordFieldStatus.fail,
        passwordStatus: PasswordFieldStatus.fail,
      ));
    }
  }
}
