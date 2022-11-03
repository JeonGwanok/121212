import 'package:equatable/equatable.dart';

class Hobby extends Equatable {
  final int? id;
  final String? name;

  Hobby({this.id, this.name});

  factory Hobby.fromJson(Map<String, dynamic> json) {
    return Hobby(
      id: json["id"],
      name: json["name"],
    );
  }

  @override
  List<Object?> get props => [id, name];
}
