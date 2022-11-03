import 'package:equatable/equatable.dart';
import 'package:oasis/model/auth/auth_token.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthInitialized extends AuthenticationEvent {}

class AuthenticationTokenChanged extends AuthenticationEvent {
  final AuthToken token;
  AuthenticationTokenChanged({required this.token});
}

class AuthLogoutRequested extends AuthenticationEvent {}
