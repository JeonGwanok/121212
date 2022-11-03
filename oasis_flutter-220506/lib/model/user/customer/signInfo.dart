import 'package:equatable/equatable.dart';

class SignInfo extends Equatable {
  final String? username;
  final String? password;

  const SignInfo({this.username, this.password});

  static const empty = SignInfo();

  factory SignInfo.fromJson(Map<String, dynamic> json) {
    return SignInfo(
      username: json["username"],
      password: json["password"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
    };
  }

  SignInfo copyWith({
    String? username,
    String? password,
  }) {
    return SignInfo(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [username, password];
}
