import 'package:equatable/equatable.dart';

class City extends Equatable {
  final int? id;
  final String? name;

  City({this.id, this.name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json["id"] ,
      name: json["name"],
    );
  }


  @override
  List<Object?> get props => [id, name];
}

class Country extends Equatable {
  final int? id;
  final String? name;

  Country({this.id, this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json["id"] ,
      name: json["name"],
    );
  }

  @override
  List<Object?> get props => [id, name];
}
