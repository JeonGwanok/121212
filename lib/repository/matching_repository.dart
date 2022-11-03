import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/enum/community/community.dart';
import 'package:oasis/model/community/community.dart';
import 'package:oasis/model/matching/ai_matching.dart';
import 'package:oasis/model/matching/last_matching.dart';
import 'package:oasis/model/matching/matchings.dart';
import 'package:oasis/model/matching/meeting.dart';
import 'package:oasis/model/matching/meeting_story.dart';
import 'package:oasis/model/matching/propose.dart';

import 'auth_repository.dart';

class MatchingRepository {
  final ApiProvider _apiClient;
  final AuthRepository _authRepository;

  MatchingRepository({
    required ApiProvider apiClient,
    required AuthRepository authRepository,
  })  : _apiClient = apiClient,
        _authRepository = authRepository;

// matching - 매칭, 프로포즈 관련
  /// 제안 된 matching
  Future<List<Matching>?> getMatchings({required String customerId}) async {
    List<Matching>? result;
    try {
      var token = await _authRepository.currentToken;
      var response = await _apiClient.getMatchings(token.token!, customerId);
      result = response.map((e) => Matching.fromJson(e)).toList();
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: getMatchings');
    }
    return result;
  }

  /// matching 1장
  Future<Matching?> getMatching({required String cardId}) async {
    Matching? result;
    try {
      var token = await _authRepository.currentToken;
      var response = await _apiClient.getMatchingCard(token.token!, cardId);
      result = Matching.fromJson(response);
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: getMatching');
    }
    return result;
  }

  Future<List<LastMatching>?> getLastMatching(
      {required String customerId}) async {
    List<LastMatching>? result;
    try {
      var token = await _authRepository.currentToken;
      var response = await _apiClient.getLastMatching(token.token!, customerId);
      result = response.map((e) => LastMatching.fromJson(e)).toList();
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: LastMatching');
    }
    return result;
  }

  // 제안 된 matching을 열어보거나 프로포즈 보낼때 사용
  Future<void> acceptMatching(
      {required String cardId, bool? openStatus, bool? proposeStatus}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.acceptMatching(
        token.token!,
        cardId,
        openStatus,
        proposeStatus,
      );
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: acceptMatching');
    }
  }

  /// 받은 프로포즈
  Future<List<Propose>?> getProposes({required String customerId}) async {
    List<Propose>? result;
    try {
      var token = await _authRepository.currentToken;
      var response = await _apiClient.getProposes(token.token!, customerId);
      result = response.map((e) => Propose.fromJson(e)).toList();
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: getProposes');
    }
    return result;
  }

  /// 내가 보낸 프로포즈
  Future<List<Propose>> getSentProposes({required String customerId}) async {
    List<Propose> result = [];
    try {
      var token = await _authRepository.currentToken;
      var response = await _apiClient.getSentProposes(token.token!, customerId);
      result = response.map((e) => Propose.fromJson(e)).toList();
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: getSentProposes');
    }
    return result;
  }

  /// 프로포즈 열기
  Future<void> openProposes({required String proposeId}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.openProposes(token.token!, proposeId);
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: openProposes');
    }
  }

  /// 받은 프로포즈 상세
  Future<Propose?> getPropose({required String proposeId}) async {
    Propose? result;
    try {
      var token = await _authRepository.currentToken;
      var response = await _apiClient.getPropose(token.token!, proposeId);
      result = Propose.fromJson(response);
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: getPropose');
    }
    return result;
  }

  /// 내가 보낸 프로포즈 상세
  Future<Propose?> getMyPropose({required String proposeId}) async {
    Propose? result;
    try {
      var token = await _authRepository.currentToken;
      var response = await _apiClient.getMyPropose(token.token!, proposeId);
      result = Propose.fromJson(response);
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: getMyPropose');
    }
    return result;
  }

  /// 프로포즈 수락 or 거절
  Future<void> acceptPropose(
      {required String proposeId, required bool accepted}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.acceptPropose(token.token!, proposeId, accepted);
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: acceptPropose');
    }
  }

  /// 헤어지기
  Future<void> breakUp({required String meetingId}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.breakUp(token.token!, meetingId: meetingId);
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: breakUp');
    }
  }

  /// 이상형 찾는중
  Future<List<AiMatching>?> getAiMatchings({required String customerId}) async {
    List<AiMatching>? result;
    try {
      var token = await _authRepository.currentToken;
      var response = await _apiClient.getAiMatchings(token.token!, customerId);
      result = response.map((e) => AiMatching.fromJson(e)).toList();
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: getAiMatchings');
    }
    return result;
  }

  /// 추천
  Future<List<CommunityResponseItem>?> getRecommend(
      {required String meetingId, required CommunityType type}) async {
    List<CommunityResponseItem>? result;
    try {
      var token = await _authRepository.currentToken;
      if (type == CommunityType.stylist) {
        var response =
            await _apiClient.getRecommendStylist(token.token!, meetingId);
        result =
            response.map((e) => CommunityResponseItem.fromJson(e)).toList();
      } else {
        var response =
            await _apiClient.getRecommendDate(token.token!, meetingId);
        result =
            response.map((e) => CommunityResponseItem.fromJson(e)).toList();
      }
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: getRecommendStylist');
    }
    return result;
  }

  /// 미팅 정보 가져오기
  Future<MeetingResponse?> getMeetingInfo({required String customerId}) async {
    MeetingResponse? result;
    try {
      var token = await _authRepository.currentToken;
      var response = await _apiClient.getMeetingInfo(token.token!, customerId);
      result = MeetingResponse.fromJson(response);
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: getMeetingInfo');
    }
    return result;
  }

  Future<void> updateSchedule(
      {required String meetingId, required List<Schedule> schedules}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.updateSchedule(
          token.token!, meetingId, schedules.map((e) => e.toJson()).toList());
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: updateSchedule');
    }
  }

  Future<void> uploadMeetingStory(
      {required String meetingId, required MeetingStory meetingStory}) async {
    try {
      var token = await _authRepository.currentToken;
      await _apiClient.uploadMeetingStory(
        token.token!,
        meetingId: meetingId,
        body: meetingStory.toJson(),
      );
    } on ApiClientException catch (err) {
      throw err;
    } catch (err) {
      print('err: uploadMeetingStory');
    }
  }
}
