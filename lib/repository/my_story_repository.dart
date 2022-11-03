import 'dart:io';

import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/enum/my_story/my_story.dart';
import 'package:oasis/model/my_story/my_story.dart';
import 'package:oasis/model/my_story/my_story_response.dart';

import 'auth_repository.dart';

class MyStoryRepository {
  final ApiProvider _apiClient;
  final AuthRepository _authRepository;

  MyStoryRepository({
    required ApiProvider apiClient,
    required AuthRepository authRepository,
  })  : _apiClient = apiClient,
        _authRepository = authRepository;

  /// 마이스토리 목록
  Future<MyStoryResponse?> getMyStorys({
    required String customerId,
    required int page,
    required MyStoryType type,
    required String? searchType,
    required String? searchText,
  }) async {
    MyStoryResponse? result;
    try {
      var token = await _authRepository.currentToken;
      switch (type) {
        case MyStoryType.daily:
          var response = await _apiClient.getMyStorys(
            token.token!,
            customerId: customerId,
            page: page,
          );
          result = MyStoryResponse.fromJson(response);
          break;
        case MyStoryType.love:
          var response = await _apiClient.getLoveMyStorys(
            token.token!,
            customerId: customerId,
            page: page,
            searchType: searchType,
            searchText: searchText,
          );
          result = MyStoryResponse.fromJson(response);
          break;
        case MyStoryType.marry:
          var response = await _apiClient.getMarryMyStorys(
            token.token!,
            customerId: customerId,
            page: page,
            searchText: searchText,
            searchType: searchType,
          );
          result = MyStoryResponse.fromJson(response);
          break;
      }
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('$err: getMyStorys');
    }
    return result;
  }

  /// 마이스토리 목록
  Future<MyStoryResponse?> getAllMyStorys({
    required int page,
  }) async {
    MyStoryResponse? result;
    try {
      var token = await _authRepository.currentToken;
      var response = await _apiClient.getAllMyStorys(
        token.token!,
        page: page,
      );
      result = MyStoryResponse.fromJson(response);
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('$err: getAllMyStorys');
    }
    return result;
  }

  /// 마이스토리 한개
  Future<MyStory?> getMyStory(
      {required String myStoryId, required MyStoryType type}) async {
    MyStory? result;
    try {
      var token = await _authRepository.currentToken;
      var response = await _apiClient.getMyStory(
        token.token!,
        type: type.key,
        myStoryId: myStoryId,
      );
      result = MyStory.fromJson(response);
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('$err: getMyStory');
    }
    return result;
  }

  /// 이전 마이스토리 한개
  Future<MyStory?> getPreviousMyStory(
      {required String myStoryId, required MyStoryType type}) async {
    MyStory? result;
    try {
      var token = await _authRepository.currentToken;
      var response = await _apiClient.getPreviousMyStory(
        token.token!,
        type: type.key,
        myStoryId: myStoryId,
      );
      result = MyStory.fromJson(response);
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: getPreviousMyStory');
    }
    return result;
  }

  /// 다음 마이스토리 한개
  Future<MyStory?> getNextMyStory(
      {required String myStoryId, required MyStoryType type}) async {
    MyStory? result;
    try {
      var token = await _authRepository.currentToken;
      var response = await _apiClient.getNextMyStory(
        token.token!,
        type: type.key,
        myStoryId: myStoryId,
      );
      result = MyStory.fromJson(response);
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: getNextMyStory');
    }
    return result;
  }

  /// 마이스토리 삭제
  Future<void> deleteMyStory({required String myStoryId}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.deleteMyStory(
        token.token!,
        myStoryId: myStoryId,
      );
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: deleteMyStory');
    }
  }

  /// 마이스토리 좋아요, 싫어요
  Future<void> likeDislikeMyStory(
      {required String myStoryId, required bool isLike}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.likeDislikeMyStory(
        token.token!,
        myStoryId: myStoryId,
        isLike: isLike,
      );
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: getPreviousMyStory');
    }
  }

  /// 마이스토리 좋아요, 싫어요 취소
  Future<void> cancelLikeDislikeMyStory(
      {required String myStoryId, required bool isLike}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.cancelLikeDislikeMyStory(
        token.token!,
        myStoryId: myStoryId,
        isLike: isLike,
      );
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: cancelLikeDislikeMyStory');
    }
  }

  /// 마이스토리 댓글
  Future<void> commentMyStory(
      {required String myStoryId, required String comment}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.commentMyStory(
        token.token!,
        myStoryId: myStoryId,
        comment: comment,
      );
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: commentMyStory');
    }
  }

  /// 마이스토리 댓글 삭제
  Future<void> deleteCommentMyStory(
      {required String customerId, required String commentId}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.deleteCommentMyStory(
        token.token!,
        commentId: commentId,
      );
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: deleteCommentMyStory');
    }
  }

  Future<void> uploadMyStory(
      {File? image1,
      File? image2,
      File? image3,
      File? image4,
      File? image5,
      required MyStoryType type,
      required String payload,
      required int customerId}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.uploadMyStory(
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
      print('err: uploadMyStory');
    }
  }

  /// 마이스토리 신고
  Future<void> reportMysStory({required String myStoryId}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.reportMyStory(
        token.token!,
        myStoryId: myStoryId,
      );
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: reportMyStory');
    }
  }

  Future<void> updateMyStory(
      {File? image1,
      File? image2,
      File? image3,
      File? image4,
      File? image5,
      required String payload,
      required int myStoryId}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.updateMyStory(
        token.token!,
        image1: (image1?.path ?? "").isNotEmpty ? image1 : null,
        image2: (image2?.path ?? "").isNotEmpty ? image2 : null,
        image3: (image3?.path ?? "").isNotEmpty ? image3 : null,
        image4: (image4?.path ?? "").isNotEmpty ? image4 : null,
        image5: (image5?.path ?? "").isNotEmpty ? image5 : null,
        payload: payload,
        myStoryId: myStoryId,
      );
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: updateMyStory');
    }
  }

  Future<void> deleteImage({required int imageId}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.deleteMyStoryImage(token.token!, imageId: "$imageId");
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: deleteImage');
    }
  }
}
