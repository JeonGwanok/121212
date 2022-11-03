import 'dart:io';

import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/model/auth/auth_token.dart';
import 'package:oasis/model/opti/answer.dart';
import 'package:oasis/model/opti/compare_tendency.dart';
import 'package:oasis/model/opti/tendencies.dart';
import 'package:oasis/model/user/certificate.dart';
import 'package:oasis/model/user/customer/customer.dart';
import 'package:oasis/model/user/cut_phone.dart';
import 'package:oasis/model/user/opti/user_mbti_detail.dart';
import 'package:oasis/model/user/opti/user_mbti_main.dart';
import 'package:oasis/model/user/profile/profile.dart';
import 'package:oasis/model/user/purchase_history.dart';
import 'package:oasis/model/user/user_profile.dart';

import 'auth_repository.dart';

class UserRepository {
  final ApiProvider _apiClient;
  final AuthRepository _authRepository;

  UserRepository({
    required ApiProvider apiClient,
    required AuthRepository authRepository,
  })  : _apiClient = apiClient,
        _authRepository = authRepository;

  Future<UserProfile> getUser({
    AuthToken? token,
  }) async {
    var _token = token ?? await _authRepository.currentToken;
    if (_token.expired) {
      _token = await _authRepository.currentToken;
    }
    try {
      var result = await _apiClient.getCustomer(_token.token ?? "");
      var user = UserProfile.fromJson(result);
      return user;
    } catch (err) {
      return UserProfile.empty;
    }
  }

  Future<void> deleteUser(
      String customerId, String password, String inconvenient) async {
    var token = await _authRepository.currentToken;
    try {
      await _apiClient.deleteCustomer(
          token: token.token!,
          customerId: customerId,
          password: password,
          inconvenient: inconvenient);
    } on ApiClientException catch (err) {
      throw err;
    }
  }

  Future<void> completeCertificate(String customerId) async {
    var token = await _authRepository.currentToken;
    try {
      await _apiClient.completeCertificate(
        token.token!,
        customerId: customerId,
      );
    } on ApiClientException catch (err) {
      throw err;
    }
  }

  Future<void> completeJoin(String customerId) async {
    var token = await _authRepository.currentToken;
    try {
      await _apiClient.completeJoin(
        token.token!,
        customerId: customerId,
      );
    } on ApiClientException catch (err) {
      throw err;
    }
  }

  // 내 성별 등등..
  Future<UserProfile> editCustomer(Customer customer) async {
    var token = await _authRepository.currentToken;
    if (token != AuthToken.empty) {
      try {
        await _apiClient.editCustomer(
            token, "${customer.id}", customer.toJson());
      } catch (err) {}
    }
    return UserProfile.empty;
  }

  // 내 이상형 등등..
  Future<UserProfile> editProfile(Profile profile) async {
    var token = await _authRepository.currentToken;
    if (token != AuthToken.empty) {
      try {
        await _apiClient.editProfile(token, profile.toJson());
      } catch (err) {}
    }
    return UserProfile.empty;
  }

  // 내 이상형 등등..
  Future<void> updateDeviceInfo({
    required String customerId,
    required String deviceToken,
    required String deviceOS,
  }) async {
    var token = await _authRepository.currentToken;
    if (token != AuthToken.empty) {
      try {
        await _apiClient.updateDeviceInfo(
          token,
          customerId: customerId,
          deviceToken: deviceToken,
          deviceOS: deviceOS,
        );
      } catch (err) {
        print("err: updateDeviceInfo");
      }
    }
  }

  // 대표 이미지
  Future<UserProfile> uploadImage(
      String profileImageId, String imageId, File file) async {
    var token = await _authRepository.currentToken;
    if (token != AuthToken.empty) {
      try {
        var result = await _apiClient.uploadImage(
            profileImageId, token.token!, imageId, file);
        var user = UserProfile.fromJson(result);
        return user;
      } catch (err) {
        print('다시 시도해주세요');
      }
    }
    return UserProfile.empty;
  }

  Future<void> deleteImage(
    String profileImageId,
    String imageId,
  ) async {
    var token = await _authRepository.currentToken;
    if (token != AuthToken.empty) {
      try {
        await _apiClient.deleteImage(
          profileImageId,
          token.token!,
          imageId,
        );
      } catch (err) {
        print('$err 다시 시도해주세요');
      }
    }
  }

  // mbti 등록
  Future<void> uploadMBTI(
    String customerId,
    String customerMBTI,
    List<OBTIAnswer> preMBTI,
    List<OBTIAnswer> mainMBTI,
  ) async {
    var token = await _authRepository.currentToken;
    if (token != AuthToken.empty) {
      try {
        await _apiClient.uploadMbti(token.token!,
            customerId: customerId,
            customerMBTI: customerMBTI,
            body: {
              "pre_mbti": preMBTI.map((e) => e.toJson()).toList(),
              "main_mbti": mainMBTI.map((e) => e.toJson()).toList(),
            });
      } catch (err) {
        print('err : uploadMBTI $err 다시 시도해주세요');
      }
    }
  }

  // mbti 등록
  Future<void> uploadTendency(
    String customerId,
    List<Tendency> answers,
  ) async {
    var token = await _authRepository.currentToken;
    if (token != AuthToken.empty) {
      try {
        await _apiClient.uploadTendency(
          token.token!,
          customerId: customerId,
          body: answers.map((e) => e.toJson()).toList(),
        );
      } catch (err) {
        print('err : uploadTendency $err 다시 시도해주세요');
      }
    }
  }

  // 인증서류 가져오기
  Future<Certificate> getCertificate(String customerId) async {
    try {
      var token = await _authRepository.currentToken;
      var result = await _apiClient.getCertificate(token.token!, customerId);
      var terms = Certificate.fromJson(result);
      return terms;
    } on ApiClientException catch (err) {
      throw err;
    }
  }

  Future<Certificate> uploadCertificate(
      String type, String customerId, File file) async {
    // 졸업, 직업, 혼인
    var token = await _authRepository.currentToken;
    if (token != AuthToken.empty) {
      try {
        var result = await _apiClient.uploadCertificate(
            type, token.token!, customerId, file);
        var user = Certificate.fromJson(result);
        return user;
      } catch (err) {
        print('다시 시도해주세요');
      }
    }
    return Certificate.empty;
  }

  // /// user mbti main
  /// 커뮤니티 서브 목록 조회
  Future<UserMBTIMain?> getUserMBTIMain({
    required int? customerId,
  }) async {
    UserMBTIMain? result;
    try {
      var token = await _authRepository.currentToken;
      var response = await _apiClient.getUserMBTIMain(
        token.token!,
        customerId: "$customerId",
      );
      result = UserMBTIMain.fromJson(response);
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('$err: getUserMBTIMain');
    }
    return result;
  }

  // /// user mbti detail
  Future<UserMBTIDetail?> getUserMBTIDetail({
    required int? customerId,
  }) async {
    UserMBTIDetail? result;
    try {
      var token = await _authRepository.currentToken;
      var response = await _apiClient.getUserMBTIDetail(
        token.token!,
        customerId: "$customerId",
      );
      result = UserMBTIDetail.fromJson(response);
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('$err: getUserMBTIDetail');
    }
    return result;
  }

  // /// change origin Mbti
  Future<void> changeOriginMBTI({
    required int? customerId,
    required String? customerMbti,
  }) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.changeOriginMBTI(
        token.token!,
        customerMbti: customerMbti,
        customerId: "$customerId",
      );
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('$err: changeOriginMBTI');
    }
  }

  Future<CompareTendency?> compareTendency({
    required int? customerId,
  }) async {
    CompareTendency? result;
    try {
      var token = await _authRepository.currentToken;
      var response = await _apiClient.compareTendency(
        token.token!,
        customerId: "$customerId",
      );
      result = CompareTendency.fromJson(response);
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('$err: compareTendency');
    }
    return result;
  }

  // 구매하기
  Future<void> updatePurchase({
    required String customerId,
    required String kind,
    required int price,
  }) async {
    var token = await _authRepository.currentToken;
    if (token != AuthToken.empty) {
      try {
        await _apiClient.updatePurchase(
          token.token!,
          customerId: customerId,
          kind: kind,
          price: price,
        );
      } catch (err) {
        print('err: updatePurchase');
      }
    }
  }

  // 구매 내역
  Future<PurchaseHistory> getPurchaseHistory({
    required String customerId,
  }) async {
    PurchaseHistory result = PurchaseHistory.empty;
    var token = await _authRepository.currentToken;
    if (token != AuthToken.empty) {
      try {
        var response = await _apiClient.getPurchaseHistory(
          token.token!,
          customerId,
        );

        result = PurchaseHistory.fromJson(response);
      } catch (err) {
        print('err: getPurchaseHistory');
      }
    }
    return result;
  }

  // 차단 된 번호 목록 가져오기
  Future<List<CutPhone>> getCutPhones({required String customerId}) async {
    List<CutPhone> result = [];
    var token = await _authRepository.currentToken;
    if (token != AuthToken.empty) {
      try {
        var response =
            await _apiClient.getCutPhones(token.token!, customerId: customerId);
        result = response.map((e) => CutPhone.fromJson(e)).toList();
        return result;
      } catch (err) {
        print('err: getCutPhones');
      }
    }
    return [];
  }

  // 번호 차단하기
  Future<void> uploadCutPhones(
      {required String customerId,
      required CutPhoneType kind,
      required List<CutPhone> items}) async {
    var token = await _authRepository.currentToken;
    if (token != AuthToken.empty) {
      try {
        await _apiClient.uploadCutPhones(
          token.token!,
          customerId: customerId,
          kind: kind.key,
          items: items.map((e) => e.toJson()).toList(),
        );
      } catch (err) {
        print('err: uploadCutPhones');
      }
    }
  }

  Future<void> blockUser({required String customerId}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.blockUser(
        token.token!,
        customerId: customerId,
      );
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: blockUser');
    }
  }

  // 번호 차단 삭제
  Future<void> deleteCutPhones(
      {required String customerId, required List<CutPhone> items}) async {
    var token = await _authRepository.currentToken;
    if (token != AuthToken.empty) {
      try {
        await _apiClient.deleteCutPhones(
          token.token!,
          customerId: customerId,
          items: items.map((e) => e.id).toList(),
        );
      } catch (err) {
        print('err: deleteCutPhones');
      }
    }
  }

  Future<void> profileEditRequestToManager(String customerId) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.getCertificate(token.token!, customerId);
    } on ApiClientException catch (err) {
      throw err.type;
    }
  }
}
