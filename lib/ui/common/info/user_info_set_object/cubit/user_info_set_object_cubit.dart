import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/model/common/citys.dart';
import 'package:oasis/model/common/hobby.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/ui/common/info/user_info_set_object/cubit/user_info_set_object_state.dart';

class UserInfoSetObjectCubit extends Cubit<UserInfoSetObjectState> {
  final CommonRepository commonRepository;
  final int? cityId;
  final int? countryId;
  final String? myHobbies;

  UserInfoSetObjectCubit({required this.commonRepository, required this.cityId, required this.countryId, required this.myHobbies,})
      : super(UserInfoSetObjectState());

  initialize() async {
    try {
      var cities = await commonRepository.getCitys();
      City? selectedCity;
      if (cityId != null) {
        var _city = cities
            .where((element) => element.id == cityId!)
            .toList();
        if (_city.isNotEmpty) {
          selectedCity = _city.first;
        }
      }

      List<Country> countries = [];
      Country? selectedCountry;
      if (selectedCity != null && countryId != null) {
        try {
          countries = await commonRepository.getCountry("$cityId");
          if (countries.isNotEmpty) {
            var _country = countries
                .where((element) => countryId == element.id)
                .toList();
            if (_country.isNotEmpty) {
              selectedCountry = _country.first;
            }
          }
        } catch (err) {}
      }

      var hobbies = await commonRepository.getHobby();
      List<Hobby>? selectedHobbies;
      if ((myHobbies ?? "").isNotEmpty) {
        List<String> selectedHobbiesIds =
        myHobbies!.split(",").toList();
        var _hobbies = hobbies.where((element) {
          if (selectedHobbiesIds.contains("${element.id}")) {
            return true;
          } else {
            return false;
          }
        }).toList();
        if (_hobbies.isNotEmpty) {
          selectedHobbies = _hobbies;
        }
      }

      emit(state.copyWith(city: selectedCity, country: selectedCountry, hobbies: selectedHobbies));

    } catch (err) {}
  }
}
