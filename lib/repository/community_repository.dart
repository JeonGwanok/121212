import 'dart:io';

import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/enum/community/community.dart';
import 'package:oasis/model/community/community.dart';
import 'package:oasis/model/community/community_main/community_main.dart';
import 'package:oasis/model/community/community_main/date.dart';
import 'package:oasis/model/community/community_main/love.dart';
import 'package:oasis/model/community/community_main/marry.dart';
import 'package:oasis/model/community/community_main/stylist.dart';

import 'auth_repository.dart';

class CommunityRepository {
  final ApiProvider _apiClient;
  final AuthRepository _authRepository;

  CommunityRepository({
    required ApiProvider apiClient,
    required AuthRepository authRepository,
  })  : _apiClient = apiClient,
        _authRepository = authRepository;

  /// 커뮤니티 메인 목록
  Future<CommunityMain?> getCommunityMain({
    required CommunityType type,
    required String? searchType,
    required String? searchText,
    int? customerId,
  }) async {
    CommunityMain? result;
    try {
      var token = await _authRepository.currentToken;
      var response = await _apiClient.getCommunityMain(
        token.token!,
        customerId: customerId,
        searchType: searchType,
        searchText: searchText,
        mainCommunityType: type.url,
      );
      switch (type) {
        case CommunityType.stylist:
          result = CommunityStylist.fromJson(response);
          break;
        case CommunityType.date:
          result = CommunityDate.fromJson(response);
          break;
        case CommunityType.love:
          result = CommunityLove.fromJson(response);
          break;
        case CommunityType.marry:
          result = CommunityMarry.fromJson(response);
          break;
      }
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('$err: getCommunityMain');
    }
    return result;
  }

  /// 커뮤니티 서브 목록 조회
  Future<CommunityResponse?> getCommunitySub({
    required CommunitySubType type,
    required int page,
    required String? searchType,
    required String? searchText,
    int? customerId,
  }) async {
    CommunityResponse? result;
    try {
      var token = await _authRepository.currentToken;
      var response = await _apiClient.getCommunitySub(
        token.token!,
        searchType: searchType,
        searchText: searchText,
        subCommunityType: type.url(
            customerPath:
                "${customerId != null ? "/customer/$customerId" : ""}"),
        customerId: customerId,
        page: page,
      );
      result = CommunityResponse.fromJson(response);
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('$err: getCommunitySub');
    }
    return result;
  }

  /// 커뮤니티 한개
  Future<CommunityDetail?> getCommunity({
    required CommunitySubType type,
    required String communityId,
  }) async {
    CommunityDetail? result;
    try {
      var token = await _authRepository.currentToken;
      var response = await _apiClient.getCommunity(
        token.token!,
        subCommunityType: type.url(),
        communityId: communityId,
      );
      result = CommunityDetail.fromJson(response);
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('$err: getCommunity');
    }
    return result;
  }

  /// 이전 커뮤니티 한개
  Future<CommunityDetail?> getPreviousCommunity({
    required CommunitySubType type,
    required String communityId,
    int? customerId,
  }) async {
    CommunityDetail? result;
    try {
      var token = await _authRepository.currentToken;
      var response = await _apiClient.getPreviousCommunity(
        token.token!,
        customerId: customerId,
        subCommunityType: type.url(),
        communityId: communityId,
      );
      result = CommunityDetail.fromJson(response);
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: getPreviousCommunity');
    }
    return result;
  }

  /// 다음 커뮤니티 한개
  Future<CommunityDetail?> getNextCommunity({
    required CommunitySubType type,
    required String communityId,
    int? customerId,
  }) async {
    CommunityDetail? result;
    try {
      var token = await _authRepository.currentToken;
      var response = await _apiClient.getNextCommunity(
        token.token!,
        subCommunityType: type.url(),
        customerId: customerId,
        communityId: communityId,
      );
      result = CommunityDetail.fromJson(response);
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: getNextCommunity');
    }
    return result;
  }

  /// 커뮤니티 좋아요, 싫어요
  Future<void> likeDislikeCommunity(
      {required String communityId, required bool isLike}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.likeDislikeCommunity(
        token.token!,
        communityId: communityId,
        isLike: isLike,
      );
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: likeDislikeCommunity');
    }
  }

  /// 커뮤니티 좋아요, 싫어요 취소
  Future<void> cancelLikeDislikeCommunity(
      {required String communityId, required bool isLike}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.cancelLikeDislikeCommunity(
        token.token!,
        communityId: communityId,
        isLike: isLike,
      );
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: cancelLikeDislikeCommunity');
    }
  }

  /// 커뮤니티 댓글
  Future<void> commentCommunity(
      {required String communityId, required String comment}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.commentCommunity(
        token.token!,
        communityId: communityId,
        comment: comment,
      );
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: commentCommunity');
    }
  }

  /// 커뮤니티 댓글 삭제
  Future<void> deleteCommentCommunity({required String commentId}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.deleteCommentCommunity(
        token.token!,
        commentId: commentId,
      );
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: deleteCommentCommunity');
    }
  }

  /// 커뮤니티 삭제
  Future<void> deleteCommunity({required String communityId}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.deleteCommunity(
        token.token!,
        communityId: communityId,
      );
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: deleteCommunity');
    }
  }

  /// 커뮤니티 신고
  Future<void> reportCommunity({required String communityId}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.reportCommunity(
        token.token!,
        communityId: communityId,
      );
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: reportCommunity');
    }
  }

  Future<void> uploadCommunity(
      {File? image1,
      File? image2,
      File? image3,
      File? image4,
      File? image5,
      required CommunitySubType type,
      required String payload,
      required int customerId}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.uploadCommunity(
        token.token!,
        image1: image1,
        image2: image2,
        image3: image3,
        image4: image4,
        image5: image5,
        type: type,
        payload: payload,
        customerId: customerId,
      );
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: uploadCommunity');
    }
  }

  Future<void> updateCommunity(
      {File? image1,
      File? image2,
      File? image3,
      File? image4,
      File? image5,
      required CommunitySubType type,
      required String payload,
      required int communityId}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.updateCommunity(
        token.token!,
        image1: (image1?.path ?? "").isNotEmpty ? image1 : null,
        image2: (image2?.path ?? "").isNotEmpty ? image2 : null,
        image3: (image3?.path ?? "").isNotEmpty ? image3 : null,
        image4: (image4?.path ?? "").isNotEmpty ? image4 : null,
        image5: (image5?.path ?? "").isNotEmpty ? image5 : null,
        type: type,
        payload: payload,
        communityId: communityId,
      );
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: updateCommunity');
    }
  }

  Future<void> deleteImage({required int imageId}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.deleteCommunityImage(token.token!, imageId: "$imageId");
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: deleteImage');
    }
  }

  /// 커뮤니티 댓글 신고
  Future<void> reportCommunityComment(
      {required String commentId, required String content}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.reportCommunityComment(
        token.token!,
        commentId: commentId,
        content: content,
      );
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: reportCommunityComment');
    }
  }
}
