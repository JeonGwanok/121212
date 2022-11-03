part of 'api_client.dart';

enum ExceptionType {
  // TODO: 기본 exception (임시)
  auth_failed,
  auth_inactive,
  param_bad,
  token_bad,
  usr_already_existed,
  usr_not_existed,
  internal_server,
  internal_db,
  sms_code_does_not_match_exception,
  sms_code_expired_exception,
  unknown
}

ExceptionType _strToType(String? errCode) {
  ExceptionType result;
  switch (errCode) {
    case "PARAM_BAD":
      result = ExceptionType.param_bad;
      break;
    case "AUTH_FAILED":
      result = ExceptionType.auth_failed;
      break;
    case "AUTH_INACTIVE":
      result = ExceptionType.auth_inactive;
      break;
    case "TOKEN_BAD":
      result = ExceptionType.token_bad;
      break;
    case "USR_ALREADY_EXISTED":
      result = ExceptionType.usr_already_existed;
      break;
    case "USR_NOT_EXISTED":
      result = ExceptionType.usr_not_existed;
      break;
    case "INTERNAL_SERVER":
      result = ExceptionType.internal_server;
      break;
    case "INTERNAL_DB":
      result = ExceptionType.internal_db;
      break;
    case "SMS_CODE_DOES_NOT_MATCH":
      result = ExceptionType.sms_code_does_not_match_exception;
      break;
    case "SmsCodeExpiredException":
      result = ExceptionType.sms_code_expired_exception;
      break;
    default:
      result = ExceptionType.unknown;
      break;
  }

  return result;
}

class ApiClientException implements Exception {
  int? statusCode;
  Map<String, dynamic>? body;

  String? value(String key) => body!.containsKey(key) ? body![key] : null;
  ApiClientException({this.statusCode, this.body});

  bool? get success => body?["success"];
  String get detail => body?["detail"] ?? "";
  ExceptionType get type => _strToType(value("detail"));

  @override
  String toString() => "[$statusCode] $body";
}
