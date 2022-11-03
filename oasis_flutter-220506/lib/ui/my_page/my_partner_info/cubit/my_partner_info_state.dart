import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/common/citys.dart';
import 'package:oasis/model/user/user_profile.dart';

class MyPartnerInfoState extends Equatable {
  final ScreenStatus status;
  final UserProfile user;

  final List<City> cities;

  final List<City> selectedCities;
  final List<City> selectedOfficeCities;

  final String? marriage;
  final bool? children;
  final String? religion;
  final String? academic;

  final double startAge;
  final double endAge;

  final double startHeight;
  final double endHeight;

  MyPartnerInfoState({
    this.status = ScreenStatus.initial,
    this.user = UserProfile.empty,
    this.selectedOfficeCities = const [],
    this.selectedCities = const [],
    this.cities = const [],
    this.children,
    this.marriage,
    this.religion,
    this.academic,
    this.startAge = 25,
    this.endAge = 65,
    this.startHeight = 120,
    this.endHeight = 200,
  });

  bool get enable {
    return selectedOfficeCities.isNotEmpty &&
        selectedCities.isNotEmpty &&
        marriage != null &&
        children != null &&
        religion != null &&
        academic != null;
  }

  MyPartnerInfoState copyWith({
    ScreenStatus? status,
    UserProfile? user,
    List<City>? cities,
    bool? children,
    List<City>? selectedCities,
    List<City>? selectedOfficeCities,
    String? marriage,
    String? religion,
    String? academic,
    double? startAge,
    double? endAge,
    double? startHeight,
    double? endHeight,
  }) {
    return MyPartnerInfoState(
      status: status ?? this.status,
      user: user ?? this.user,
      children: children ?? this.children,
      cities: cities ?? this.cities,
      selectedCities: selectedCities ?? this.selectedCities,
      selectedOfficeCities: selectedOfficeCities ?? this.selectedOfficeCities,
      marriage: marriage ?? this.marriage,
      religion: religion ?? this.religion,
      academic: academic ?? this.academic,
      startAge: startAge ?? this.startAge,
      endAge: endAge ?? this.endAge,
      startHeight: startHeight ?? this.startHeight,
      endHeight: endHeight ?? this.endHeight,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        selectedOfficeCities,
        selectedCities,
        cities,
        marriage,
        religion,
        children,
        academic,
        startAge,
        endAge,
        startHeight,
        endHeight,
      ];
}
