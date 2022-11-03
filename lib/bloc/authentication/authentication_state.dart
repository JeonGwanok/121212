import 'package:equatable/equatable.dart';
import 'package:oasis/model/auth/auth_token.dart';
import 'package:oasis/model/user/user_profile.dart';

enum AuthenticationStatus {
  authenticated,
  unknown,
  guest,
  unauthenticated,
}

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final AuthToken? authToken;
  final UserProfile? user;

  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.authToken = AuthToken.empty,
    this.user,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  const AuthenticationState.authenticated(UserProfile user,AuthToken token)
      : this._(
            status: AuthenticationStatus.authenticated,
            user: user,authToken: token);

  const AuthenticationState.guest()
      : this._(status: AuthenticationStatus.guest);

  @override
  List<Object?> get props => [status, user, authToken];

  @override
  String toString() {
    return "AuthenticationState status $status, user $user";
  }
}
