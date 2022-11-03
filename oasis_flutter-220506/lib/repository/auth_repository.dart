import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/model/auth/auth_token.dart';
import 'package:oasis/model/user/customer/create_user.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthExceptionType {
  AUTH_FAILED,
  AUTH_INACTIVE,
  USR_ALREADY_EXISTED,
  USR_NOT_EXISTED,
  INTERNAL_SERVER,
  INTERNAL_DB,
  PARTNER,
  UNKNOWN
}

class AuthRepository {
  final ApiProvider _apiClient;

  SharedPreferences? _prefs;
  AuthRepository({required ApiProvider apiClient}) : _apiClient = apiClient;

  AuthToken _token = AuthToken.empty;

  // 새로운 토큰이 add 되면 bloc(ui)쪽에 새로운 토큰을 뿌려줌.
  final _controller = StreamController<AuthToken>();

  Stream<AuthToken> get token async* {
    yield* _controller.stream;
  }

  // 현재 사용 가능한 토큰을 뽑아내는 함수
  // access 만료 되었으면 재발급
  Future<AuthToken> get currentToken async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }

    var sharedToken = _prefs!.getString("token");
    if (_token == AuthToken.empty) {
      if (sharedToken != null && sharedToken != "") {
        _token = AuthToken(token: sharedToken);
      }
    }

    if (_token.expired) {
      print("TOKEN_EXPIRED");
      await _prefs!.remove("token");
      return await _refresh(_token);
    }
    return _token;
  }

  // 토큰 업데이트 상태를 controller 를 이용하여 bloc에 뿌려줌
  _updateToken(AuthToken token) async {
    _token = token.copyWith();
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }

    var sharedToken = _prefs!.getString("token");
    await _prefs!.remove("token");
    if (_token != AuthToken.empty) {
      await _prefs!.setString("token", _token.token ?? "");
    }
    _controller.add(token);
  }

  Future<AuthToken> _refresh(AuthToken token) async {
    AuthToken? result;
    try {
      var response = await _apiClient.refresh(token.token ?? "");
      result = AuthToken.fromJson(response);
    } on ApiClientException catch (ex) {
      debugPrint("exception: $ex");
    }

    if (result == null) {
      _updateToken(AuthToken.empty);
      return AuthToken.empty;
    }

    _updateToken(result);
    return result;
  }

  // 로그인 관련 =======================

  Future<bool> emailDuplicationCheck(String email) async {
    try {
    var result =  await _apiClient.emailDuplicationCheck(email);
      return result;
    } catch (_) {
      return false;
    }
  }

  Future<bool> nicknameDuplicationCheck(String nickName) async {
    try {
     var result = await _apiClient.nicknameDuplicationCheck(nickName);
      return result;
    } catch (_) {
      return false;
    }
  }

  Future<bool> usernameDuplicationCheck(String phoneN) async {
    try {
      var result = await _apiClient.usernameDuplicationCheck(phoneN);
      return result;
    } catch (_) {
      return false;
    }
  }

  Future<void> resetPassword({required String username, required String password,}) async {
    try {
      await _apiClient.resetPassword(username: username, password: password);
    } on ApiClientException catch (ex) {
      print('err: resetPassword');
    } on Exception {
      throw AuthExceptionType.UNKNOWN;
    }
  }


  Future<void> signUp(CreateUser user) async {
    try {
      await _apiClient.createCustomer(user: user.toJson());
      var token = await _apiClient.createToken(
          username: user.user!.username!, password: user.user!.password!);
      var authToken = AuthToken.fromJson(token);
      _updateToken(authToken);
    } on ApiClientException catch (ex) {
      print('사인업 이슈 $ex');
    } on Exception {
      throw AuthExceptionType.UNKNOWN;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      var result =
          await _apiClient.createToken(username: email, password: password);
      var authToken = AuthToken.fromJson(result);
      _updateToken(authToken);
    } on ApiClientException catch (ex) {
      throw ex;
    } on Exception {
      throw AuthExceptionType.UNKNOWN;
    }
  }

  Future<void> logOut() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }

    await _prefs!.remove("signIn");
    await _prefs!.remove("autoSignIn");

    await _prefs!.remove("token");
    _updateToken(AuthToken.empty);
  }
  void dispose() => _controller.close();
}
