import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/common/citys.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';

import 'register_partner_info_state.dart';

class RegisterPartnerInfoCubit extends Cubit<RegisterPartnerInfoState> {
  final UserRepository userRepository;
  final CommonRepository commonRepository;

  RegisterPartnerInfoCubit({
    required this.userRepository,
    required this.commonRepository,
  }) : super(RegisterPartnerInfoState());

  initialize() async {
    var user = await userRepository.getUser();
    var cities = await commonRepository.getCitys();

    List<City>? selectedCity;
    if (user.profile?.loverResidenceCity1Id != null ||
        user.profile?.loverResidenceCity2Id != null) {
      var _citys = cities
          .where((element) =>
              element.id == user.profile?.loverResidenceCity1Id ||
              element.id == user.profile?.loverResidenceCity2Id)
          .toList();
      if (_citys.isNotEmpty) {
        selectedCity = _citys;
      }
    }

    List<City>? selectedWorkerCity;
    if (user.profile?.loverWorkCity1Id != null ||
        user.profile?.loverWorkCity2Id != null) {
      var _citys = cities
          .where((element) =>
              element.id == user.profile?.loverWorkCity1Id ||
              element.id == user.profile?.loverWorkCity2Id)
          .toList();
      if (_citys.isNotEmpty) {
        selectedWorkerCity = _citys;
      }
    }

    emit(state.copyWith(
      user: user,
      selectedOfficeCities: selectedWorkerCity,
      selectedCities: selectedCity,
      marriage: user.profile?.loverMarriage,
      religion: user.profile?.loverReligion,
      children: user.profile?.loverChildren,
      academic: user.profile?.loverAcademic,
      startAge: user.profile?.loverAgeStart != null ? user.profile!.loverAgeStart! * 1.0 : null,
      endAge: user.profile?.loverAgeEnd != null ? user.profile!.loverAgeEnd! * 1.0 : null,
      startHeight: user.profile?.loverHeightStart != null ? user.profile!.loverHeightStart! * 1.0 : null,
      endHeight: user.profile?.loverHeightEnd != null ? user.profile!.loverHeightEnd! * 1.0 : null,
      cities: cities,
      status: ScreenStatus.loaded,
    ));
  }

  changeScreenStatus() {
    emit(state.copyWith(status: ScreenStatus.loaded));
  }

  enterValue({
    List<City>? selectedCities,
    List<City>? selectedOfficeCities,
    String? marriage,
    String? religion,
    String? academic,
    double? startAge,
    double? endAge,
    bool? children,
    double? startHeight,
    double? endHeight,
  }) {
    emit(state.copyWith(
      selectedCities: selectedCities,
      selectedOfficeCities: selectedOfficeCities,
      marriage: marriage,
      religion: religion,
      academic: academic,
      startAge: startAge,
      endAge: endAge,
      children: children,
      startHeight: startHeight,
      endHeight: endHeight,
    ));
  }

  update() async {
    try {
      var user = state.user.copyWith(
          profile: state.user.profile!.copyWith(
              loverResidenceCity1Id: state.selectedCities.isNotEmpty
                  ? state.selectedCities.first.id
                  : null,
              loverResidenceCity2Id: state.selectedCities.length >= 2
                  ? state.selectedCities[1].id
                  : null,
              loverWorkCity1Id: state.selectedOfficeCities.isNotEmpty
                  ? state.selectedOfficeCities.first.id
                  : null,
              loverWorkCity2Id: state.selectedOfficeCities.length >= 2
                  ? state.selectedOfficeCities[1].id
                  : null,
              loverAgeStart: state.startAge.ceil(),
              loverAgeEnd: state.endAge.ceil(),
              loverHeightStart: state.startHeight.ceil(),
              loverHeightEnd: state.endHeight.ceil(),
              loverMarriage: state.marriage,
              loverChildren: state.children,
              loverReligion: state.religion,
              loverAcademic: state.academic));
      await userRepository.editProfile(user.profile!);

      emit(state.copyWith(
          user: user, status: ScreenStatus.success, updateAt: DateTime.now()));
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }
}
