import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/model/auth/auth_token.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/repository/auth_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  StreamSubscription<AuthToken>? _userSubscription;

  AuthenticationBloc(
      {required AuthRepository authRepository,
      required UserRepository userRepository})
      : _authRepository = authRepository,
        _userRepository = userRepository,
        super(const AuthenticationState.unknown()) {
    _userSubscription = _authRepository.token.listen(
      (token) => add(AuthenticationTokenChanged(token: token)),
    );
    add(AuthInitialized());
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthInitialized) {
      yield* _mapAuthInitializedToState(event);
    } else if (event is AuthenticationTokenChanged) {
      yield* _mapAuthenticationUserChangedToState(event);
    } else if (event is AuthLogoutRequested) {
      yield* _mapLogoutRequestedToState(event);
    }
  }

  Stream<AuthenticationState> _mapAuthInitializedToState(
      AuthInitialized event) async* {
    var token = await _authRepository.currentToken;
    if (token == AuthToken.empty) {
      await Future.delayed(Duration(milliseconds: 2500));
      yield AuthenticationState.unauthenticated();
    } else {
      try {
        UserProfile user = await _userRepository.getUser(token: token);
        await Future.delayed(Duration(seconds: 2));
        yield AuthenticationState.authenticated(user, token);
      } on ApiClientException catch (err) {
        yield AuthenticationState.unauthenticated();
      }
    }
  }

  Stream<AuthenticationState> _mapLogoutRequestedToState(
      AuthLogoutRequested event) async* {
    await _authRepository.logOut();
  }

  Stream<AuthenticationState> _mapAuthenticationUserChangedToState(
      AuthenticationTokenChanged event) async* {
    if (event.token == AuthToken.empty) {
      yield AuthenticationState.unauthenticated();
    } else if (event.token != AuthToken.empty) {
      var user = await _userRepository.getUser(token: event.token);
      yield AuthenticationState.authenticated(user, event.token);
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
