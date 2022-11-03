import 'package:equatable/equatable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


class AuthToken extends Equatable {
  final String? token;
  const AuthToken({this.token});

  static const empty = AuthToken();

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      token: json['token'],
    );
  }

  Map<String, dynamic> get decoded {
    if (token == null) return {};
    return JwtDecoder.decode(token!);
  }

  bool get expired {
    int? exp = decoded["exp"];
    if (exp == null) return false;
    var expireDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    return DateTime.now().isAfter(expireDate);
  }

  String? get email {
    return decoded["email"];
  }

  int? get userId {
    return decoded["user_id"];
  }

  AuthToken copyWith({String? token}) {
    return AuthToken(token: token ?? this.token);
  }

  Map<String, dynamic> toJson() {
    return {"token": token};
  }

  @override
  List<Object?> get props => [token];
}
