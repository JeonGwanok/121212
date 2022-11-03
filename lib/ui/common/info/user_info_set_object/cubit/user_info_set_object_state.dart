import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/common/citys.dart';
import 'package:oasis/model/common/hobby.dart';

class UserInfoSetObjectState extends Equatable {
  final ScreenStatus status;
  final City? city;
  final Country? country;
  final List<Hobby> hobbies;

  UserInfoSetObjectState({
    this.status = ScreenStatus.initial,
    this.city,
    this.country,
    this.hobbies = const [],
  });

  UserInfoSetObjectState copyWith({
    ScreenStatus? status,
    City? city,
    Country? country,
    List<Hobby>? hobbies,
  }) {
    return UserInfoSetObjectState(
      status: status ?? this.status,
      city: city ?? this.city,
      country: country ?? this.country,
      hobbies: hobbies ?? this.hobbies,
    );
  }

  @override
  List<Object?> get props => [
        status,
        country,
        city,
        hobbies,
      ];
}
