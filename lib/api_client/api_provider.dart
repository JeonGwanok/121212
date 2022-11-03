part of 'api_client.dart';

class ApiProvider {
  final http.Client _httpClient = http.Client();
  final String _baseUrl;
  // auth
  final String _tokenUri = "/api/token";

  final String _users = "/api/users";

  // customer
  final String _customer = "/api/users/customer";
  final String _matching = "/api/matching";
  final String _mystory = "/api/mystory";
  final String _community = "/api/community";
  final String _payment = "/api/payment/customer";

  final String _common = "/api/common";

  ApiProvider({required String baseUrl}) : _baseUrl = baseUrl;

  // api base
  Map<String, String> _headers({String? token}) {
    Map<String, String> headers = {};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<http.Response> _get(String uri, {String? token}) async {
    final url = Uri.parse(Uri.encodeFull("$_baseUrl$uri"));
    return await _httpClient.get(url, headers: _headers(token: token));
  }

  Future<http.Response> _post(String uri,
      {dynamic? body, String? token}) async {
    final url = Uri.parse(Uri.encodeFull("$_baseUrl$uri"));
    return await _httpClient.post(
      url,
      headers: _headers(token: token),
      body: jsonEncode(body ?? {}),
    );
  }

  Future<http.Response> _put(
    String uri, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final url = Uri.parse(Uri.encodeFull("$_baseUrl$uri"));
    return await _httpClient.put(
      url,
      headers: _headers(token: token),
      body: jsonEncode(body ?? {}),
    );
  }

  Future<http.Response> _patch(
    String uri, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final url = Uri.parse("$_baseUrl$uri");
    return await _httpClient.patch(
      url,
      headers: _headers(token: token),
      body: jsonEncode(body ?? {}),
    );
  }

  Future<http.Response> _delete(
    String uri, {
    dynamic? body,
    String? token,
  }) async {
    final url = Uri.parse("$_baseUrl$uri");
    return await _httpClient.delete(
      url,
      headers: _headers(token: token),
      body: jsonEncode(body ?? {}),
    );
  }

  void _checkResponse(http.Response response) {
    final statusCode = response.statusCode;
    if (statusCode != 200 && statusCode != 201 && statusCode != 204) {
      final body = json.decode(response.body);
      debugPrint("API Exception $body");
      throw ApiClientException(statusCode: statusCode, body: body);
    }
  }

  //============
  // auth
  Future<Map<String, dynamic>> createToken(
      {required String username, required String password}) async {
    final url = "$_tokenUri?username=$username&password=$password";
    var response = await _post(url, body: {});
    _checkResponse(response);

    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  Future<Map<String, dynamic>> refresh(String token) async {
    final url = "$_tokenUri/refresh";
    var body = {"token": token};
    final response = await _post(url, body: body);

    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  // import
  Future<Map<String, dynamic>> getIamportInfo(String impUid) async {
    final url =
        "/api/iamport/token?secret_key=9X9R5X4JREKMHOEIKRYOKY7V80AFN4Y1";
    final tokenResponse = await _post(url);
    _checkResponse(tokenResponse);
    var token = jsonDecode(utf8.decode(tokenResponse.bodyBytes));
    var accessToken = token["response"]["access_token"];

    final iamResponse = await _httpClient.get(
        Uri.parse(
            Uri.encodeFull("https://api.iamport.kr/certifications/$impUid")),
        headers: {"Authorization": accessToken});
    var result = jsonDecode(utf8.decode(iamResponse.bodyBytes));
    return result;
  }

  // users
  /// 휴대폰 번호
  Future<bool> usernameDuplicationCheck(String phoneN) async {
    final url = "$_users/username/$phoneN?username=$phoneN";
    final response = await _get(url);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    if (result["duplication_check"] != null) {
      return result["duplication_check"];
    }
    return false;
  }

  // mbti

  /// user mbti main
  Future<Map<String, dynamic>> getUserMBTIMain(String token,
      {String? customerId}) async {
    final url = "$_customer/$customerId/mbti/main?customer_id=$customerId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// user mbti detail
  Future<Map<String, dynamic>> getUserMBTIDetail(String token,
      {String? customerId}) async {
    final url = "$_customer/$customerId/mbti/detail?customer_id=$customerId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// compare mbti
  Future<Map<String, dynamic>> compareTendency(String token,
      {String? customerId}) async {
    final url = "$_customer/$customerId/tendency/compare?lover_id=$customerId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// change origin Mbti
  Future<void> changeOriginMBTI(
    String token, {
    required String customerId,
    required String? customerMbti,
  }) async {
    final url =
        "$_customer/$customerId/mbti/change?customer_id=$customerId&customer_mbti=$customerMbti";
    final response = await _put(url, token: token);
    _checkResponse(response);
  }

  // customer - 유저 정보 중복 체크 관련
  Future<bool> emailDuplicationCheck(String email) async {
    final url = "$_customer/email/$email?email=$email";
    final response = await _get(url);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    if (result["duplication_check"] != null) {
      return result["duplication_check"];
    }
    return false;
  }

  /// 닉네임 중복체크
  Future<bool> nicknameDuplicationCheck(String nickname) async {
    final url = "$_customer/nick/name/$nickname?nick_name=$nickname";
    final response = await _get(url);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    if (result["duplication_check"] != null) {
      return result["duplication_check"];
    }
    return false;
  }

  // customer - 유저 정보 관련
  Future<void> createCustomer({required Map<String, dynamic> user}) async {
    final url = "$_customer";
    var response = await _post(url, body: user);
    _checkResponse(response);
  }

  Future<void> resetPassword(
      {required String username, required String password}) async {
    final url = "$_customer/password?username=$username&password=$password";
    var response = await _put(url);
    _checkResponse(response);
  }

  Future<Map<String, dynamic>> getCustomer(String token) async {
    final url = "$_customer";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  // 회원가입 페이지를 봤는지 확인
  Future<void> completeJoin(String token, {required String customerId}) async {
    final url = "$_customer/$customerId/join/status?customer_id=$customerId";
    final response = await _post(url, token: token);
    _checkResponse(response);
  }

  // 서류인증 페이지를 한번이상 봤는지 확인
  Future<void> completeCertificate(String token,
      {required String customerId}) async {
    final url =
        "$_customer/$customerId/certificate/status/update?customer_id=$customerId";
    final response = await _post(url, token: token);
    _checkResponse(response);
  }

  Future<void> deleteCustomer({
    required String token,
    required String customerId,
    required String password,
    required String inconvenient,
  }) async {
    final url = "$_customer/$customerId?customer_id=$customerId";
    final response = await _delete(url,
        body: {"password": password, "inconvenient": inconvenient},
        token: token);
    _checkResponse(response);
  }

  Future<Map<String, dynamic>> getCertificate(
      String token, String customerId) async {
    final url = "$_customer/$customerId/certificate?customer_id=$customerId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  // 구매
  Future<void> updatePurchase(
    String token, {
    required String customerId,
    required String kind,
    required int price,
  }) async {
    final url = "$_payment/$customerId/in/app?customer_id=$customerId";
    final response = await _post(url,
        body: {
          "kind": kind,
          "price": price,
        },
        token: token);
    _checkResponse(response);
  }

  // 구매내역
  Future<Map<String, dynamic>> getPurchaseHistory(
      String token, String customerId) async {
    final url = "$_payment/$customerId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 사용자 차단
  Future<void> blockUser(
    String token, {
    required String customerId,
  }) async {
    final url = "$_customer/$customerId/cut/off?customer_id=$customerId";
    final response = await _post(url, token: token);
    _checkResponse(response);
  }

  // 메니저에게 프로필 사진 수정 요청하기
  Future<void> profileEditRequestToManager(
      String token, String customerId) async {
    final url = "$_customer/$customerId/update/request";
    final response = await _post(url, token: token);
    _checkResponse(response);
  }

  Future<Map<String, dynamic>> uploadImage(
      String profileImageType, String token, String imageId, File image) async {
    final url = Uri.parse(Uri.encodeFull(
        "$_baseUrl$_customer/profile/image/$imageId/$profileImageType"));
    var request = MultipartRequest("POST", url);
    request.headers['Authorization'] = 'Bearer $token';
    var picture = http.MultipartFile.fromBytes(
        'file', await image.readAsBytes(),
        filename: 'profile.png');
    request.files.add(picture);
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return json.decode(respStr);
    } else {
      final body = json.decode(respStr);
      print("API Exception $body");
      throw ApiClientException(statusCode: response.statusCode, body: body);
    }
  }

  Future<void> deleteImage(
      String profileImageType, String token, String imageId) async {
    final url =
        "$_customer/profile/image/$imageId/$profileImageType?image_id=$imageId";
    final response = await _delete(url, token: token);
    _checkResponse(response);
  }

  Future<Map<String, dynamic>> uploadCertificate(
      String type, String token, String customerId, File image) async {
    final url = Uri.parse(Uri.encodeFull(
        "$_baseUrl$_customer/$customerId/certificate?customer_id=$customerId&type_name=$type"));
    var request = MultipartRequest("POST", url);
    request.headers['Authorization'] = 'Bearer $token';
    var picture = http.MultipartFile.fromBytes(
        'files', await image.readAsBytes(),
        filename: 'certificate.png');
    request.files.add(picture);
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return json.decode(respStr);
    } else {
      final body = json.decode(respStr);
      print("API Exception $body");
      throw ApiClientException(statusCode: response.statusCode, body: body);
    }
  }

  /// 이름, 성별 등등
  Future<Map<String, dynamic>> editCustomer(
      AuthToken token, String customerId, Map<String, dynamic> profile) async {
    final url = "$_customer/$customerId";
    final response = await _put(url, body: profile, token: token.token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  // 내 특징 이상형 등등..
  Future<Map<String, dynamic>> editProfile(
      AuthToken token, Map<String, dynamic> profile) async {
    final url = "$_customer/profile/${profile["id"]}";
    final response = await _put(url, body: profile, token: token.token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  // 디바이스 정보 등록
  Future<void> updateDeviceInfo(
    AuthToken token, {
    required String customerId,
    required String deviceToken,
    required String deviceOS,
  }) async {
    final url = "$_customer/$customerId/device?customer_id=$customerId";
    final response = await _put(url,
        body: {"device_token": deviceToken, "device_os": deviceOS},
        token: token.token);
    _checkResponse(response);
  }

  // mbti 등록
  Future<void> uploadMbti(
    String token, {
    required String customerId,
    required String customerMBTI,
    required Map<String, dynamic> body,
  }) async {
    final url =
        "$_customer/$customerId/mbti?customer_id=$customerId&customer_mbti=$customerMBTI";
    final response = await _post(url, body: body, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  // tendencies 등록
  Future<void> uploadTendency(
    String token, {
    required String customerId,
    required List<dynamic> body,
  }) async {
    final url = "$_customer/$customerId/tendency?customer_id=$customerId";
    final response = await _post(url, body: body, token: token);
    _checkResponse(response);
  }

  // 차단 된 번호 목록 가져오기
  Future<List<dynamic>> getCutPhones(String token,
      {required String customerId}) async {
    final url =
        "$_customer/$customerId/meeting/cut/off?customer_id=$customerId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  // 번호 차단하기
  Future<void> uploadCutPhones(
    String token, {
    required String customerId,
    required String kind,
    required List<dynamic> items,
  }) async {
    final url =
        "$_customer/$customerId/meeting/cut/off?customer_id=$customerId&kind=$kind";
    final response = await _post(url, body: items, token: token);
    _checkResponse(response);
  }

  // 번호 차단 삭제
  Future<void> deleteCutPhones(
    String token, {
    required String customerId,
    required List<dynamic> items,
  }) async {
    final url =
        "$_customer/$customerId/meeting/cut/off?customer_id=$customerId";
    final response = await _delete(url, body: items, token: token);
    _checkResponse(response);
  }

  // matching - 매칭, 프로포즈 관련
  /// 제안 된 matching
  Future<List<dynamic>> getMatchings(String token, String customerId) async {
    final url =
        "$_matching/card/to_customer/$customerId?customer_id=$customerId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 이전에 제안 됐던 matching
  Future<List<dynamic>> getLastMatching(String token, String customerId) async {
    final url =
        "$_matching/card/previous/to_customer/$customerId?customer_id=$customerId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  // 매칭 카드 한장
  Future<Map<String, dynamic>> getMatchingCard(
      String token, String cardId) async {
    final url = "$_matching/card/$cardId?card_id=$cardId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  // 제안 된 matching을 열어보거나 프로포즈 보낼때 사용
  Future<void> acceptMatching(String token, String cardId, bool? openStatus,
      bool? proposeStatus) async {
    final url = "$_matching/card/$cardId?card_id=$cardId";
    final response = await _put(url,
        body: {"open_status": openStatus, "propose_status": proposeStatus},
        token: token);
    _checkResponse(response);
  }

  /// 받은 프로포즈
  Future<List<dynamic>> getProposes(String token, String customerId) async {
    final url =
        "$_matching/propose/to_customer/$customerId?customer_id=$customerId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 내가 보낸 프로포즈
  Future<List<dynamic>> getSentProposes(String token, String customerId) async {
    final url =
        "$_matching/propose/from_customer/$customerId?customer_id=$customerId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 프로포즈 열어봄
  Future<void> openProposes(String token, String proposeId) async {
    final url =
        "$_matching/propose/receive/$proposeId/open?propose_id=$proposeId";
    final response = await _put(url, token: token);
    _checkResponse(response);
  }

  /// 받은 프로포즈 상세
  Future<Map<String, dynamic>> getPropose(
      String token, String proposeId) async {
    final url = "$_matching/propose/receive/$proposeId?propose_id=$proposeId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 내가 보낸 프로포즈 상세
  Future<Map<String, dynamic>> getMyPropose(
      String token, String proposeId) async {
    final url = "$_matching/propose/receive/$proposeId?propose_id=$proposeId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 프로포즈 수락 or 거절
  Future<void> acceptPropose(
      String token, String proposeId, bool accepted) async {
    final url =
        "$_matching/propose/receive/$proposeId?propose_id=$proposeId&meeting_status=$accepted";
    final response = await _put(url, token: token);
    _checkResponse(response);
  }

  /// 이상형 찾는중
  Future<List<dynamic>> getAiMatchings(String token, String customerId) async {
    final url =
        "$_matching/customer/$customerId/ai/lover?customer_id=$customerId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 미팅정보 가져오기
  Future<Map<String, dynamic>> getMeetingInfo(
      String token, String customerId) async {
    final url =
        "$_matching/customer/$customerId/meeting?customer_id=$customerId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 스케줄 추가하기
  Future<void> updateSchedule(
      String token, String meetingId, List<dynamic> body) async {
    final url = Uri.parse(Uri.encodeFull(
        "$_baseUrl$_matching/meeting/$meetingId/schedule?meeting_id=$meetingId"));
    final response = await _httpClient.post(
      url,
      headers: _headers(token: token),
      body: jsonEncode(body),
    );

    _checkResponse(response);
  }

  /// 만남 후 이야기
  Future<void> uploadMeetingStory(
    String token, {
    required String meetingId,
    required Map<String, dynamic> body,
  }) async {
    final url = "$_matching/meeting/$meetingId/story?meeting_id=$meetingId";
    final response = await _post(url, body: body, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 헤어지기
  Future<void> breakUp(
    String token, {
    required String meetingId,
  }) async {
    final url = "$_matching/meeting/$meetingId/break/up?meeting_id=$meetingId";
    final response = await _post(url, token: token);
    _checkResponse(response);
  }

  /// 추천 코디
  Future<List<dynamic>> getRecommendStylist(
      String token, String meetingId) async {
    final url =
        "$_matching/meeting/$meetingId/recommand/stylist?meeting_id=$meetingId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 추천 맛집
  Future<List<dynamic>> getRecommendDate(String token, String meetingId) async {
    final url =
        "$_matching/meeting/$meetingId/recommand/date/list?meeting_id=$meetingId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  // 마이스토리
  /// 마이스토리 여러개 목록 가져오기 (본인것만)
  Future<Map<String, dynamic>> getMyStorys(
    String token, {
    required String customerId,
    required int page,
  }) async {
    final url =
        "$_mystory/daily/share/customer/$customerId?customer_id=$customerId&page=$page";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 마이스토리 여러개 목록 가져오기 (유저 모두의 것)
  Future<Map<String, dynamic>> getAllMyStorys(
    String token, {
    required int page,
  }) async {
    final url = "$_mystory/daily/share?page=$page";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 연애이야기 목록
  Future<Map<String, dynamic>> getLoveMyStorys(
    String token, {
    required String customerId,
    required String? searchType,
    required String? searchText,
    required int page,
  }) async {
    final url =
        "$_mystory/loves?page=$page${searchType != null && searchText != null ? "&search_type=$searchType" : ""}${searchText != null ? "&search_text=$searchText" : ""}";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 결혼이야기 목록
  Future<Map<String, dynamic>> getMarryMyStorys(
    String token, {
    required String customerId,
    required String? searchType,
    required String? searchText,
    required int page,
  }) async {
    final url =
        "$_mystory/marrys?page=$page${searchType != null && searchText != null ? "&search_type=$searchType" : ""}${searchText != null ? "&search_text=$searchText" : ""}";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 마이스토리 한개
  Future<Map<String, dynamic>> getMyStory(
    String token, {
    required String type, // daily, love, marry
    required String myStoryId,
  }) async {
    final url = "$_mystory/$type/$myStoryId?mystory_id=$myStoryId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 이전 마이스토리 한개
  Future<Map<String, dynamic>> getPreviousMyStory(
    String token, {
    required String type, // daily, love, marry
    required String myStoryId,
  }) async {
    final url = "$_mystory/$type/$myStoryId/previous?mystory_id=$myStoryId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 다음 마이스토리 한개
  Future<Map<String, dynamic>> getNextMyStory(
    String token, {
    required String type, // daily, love, marry
    required String myStoryId,
  }) async {
    final url = "$_mystory/$type/$myStoryId/next?mystory_id=$myStoryId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 마이스토리 삭제
  Future<void> deleteMyStory(
    String token, {
    required String myStoryId,
  }) async {
    final url = "$_mystory/$myStoryId?mystory_id=$myStoryId";
    final response = await _delete(url, token: token);
    _checkResponse(response);
  }

  /// 마이스토리 좋아요, 싫어요
  Future<void> likeDislikeMyStory(
    String token, {
    required bool isLike,
    required String myStoryId,
  }) async {
    final url =
        "$_mystory/$myStoryId/like/dislike?mystory_id=$myStoryId&kind=${isLike ? "like" : "dislike"}";
    final response = await _post(url, token: token);
    _checkResponse(response);
  }

  /// 마이스토리 좋아요, 싫어요 취소
  Future<void> cancelLikeDislikeMyStory(
    String token, {
    required bool isLike,
    required String myStoryId,
  }) async {
    final url =
        "$_mystory/$myStoryId/like/dislike?mystory_id=$myStoryId&kind=${isLike ? "like" : "dislike"}";
    final response = await _delete(url, token: token);
    _checkResponse(response);
  }

  /// 마이스토리 댓글
  Future<void> commentMyStory(
    String token, {
    required String myStoryId,
    required String comment,
  }) async {
    final url =
        "$_mystory/$myStoryId/comment?mystory_id=$myStoryId&comment=$comment";
    final response = await _post(url, token: token);
    _checkResponse(response);
  }

  /// 마이스토리 댓글 삭제
  Future<void> deleteCommentMyStory(
    String token, {
    required String commentId,
  }) async {
    final url = "$_mystory/$commentId/comment?comment_id=$commentId";
    final response = await _delete(url, token: token);
    _checkResponse(response);
  }

  /// 마이스토리 신고
  Future<void> reportMyStory(
    String token, {
    required String myStoryId,
  }) async {
    final url = "$_mystory/$myStoryId/report?mystory_id=$myStoryId";
    final response = await _post(url, token: token);
    _checkResponse(response);
  }

  /// 마이스토리 신고
  Future<void> reportMyStoryComment(
    String token, {
    required String commentId,
    required String content,
  }) async {
    final url =
        "$_mystory/comment/$commentId/report?comment_id=$commentId&content=$content";
    final response = await _post(url, token: token);
    _checkResponse(response);
  }

  // 마이스토리 추가
  Future<Map<String, dynamic>> uploadMyStory(
    String token, {
    File? image1,
    File? image2,
    File? image3,
    File? image4,
    File? image5,
    required MyStoryType type,
    required String payload,
    required int customerId,
  }) async {
    final url = Uri.parse(Uri.encodeFull(
        "$_baseUrl$_mystory/${type.key}/customer/$customerId?customer_id=$customerId"));
    var request = MultipartRequest("POST", url);
    request.headers['Authorization'] = 'Bearer $token';

    if (image1 != null) {
      var picture1 = http.MultipartFile.fromBytes(
          'files', await image1.readAsBytes(),
          filename: 'image1.png');
      request.files.add(picture1);
    }

    if (image2 != null) {
      var picture2 = http.MultipartFile.fromBytes(
          'files', await image2.readAsBytes(),
          filename: 'image2.png');
      request.files.add(picture2);
    }

    if (image3 != null) {
      var picture2 = http.MultipartFile.fromBytes(
          'files', await image3.readAsBytes(),
          filename: 'image3.png');
      request.files.add(picture2);
    }

    if (image4 != null) {
      var picture2 = http.MultipartFile.fromBytes(
          'files', await image4.readAsBytes(),
          filename: 'image4.png');
      request.files.add(picture2);
    }

    if (image5 != null) {
      var picture2 = http.MultipartFile.fromBytes(
          'files', await image5.readAsBytes(),
          filename: 'image5.png');
      request.files.add(picture2);
    }

    request.fields["payload"] = payload;
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return json.decode(respStr);
    } else {
      final body = json.decode(respStr);
      print("API Exception $body");
      throw ApiClientException(statusCode: response.statusCode, body: body);
    }
  }

  /// 커뮤니티 이미지 삭제
  Future<void> deleteMyStoryImage(
    String token, {
    required String imageId,
  }) async {
    final url = "$_mystory/image/$imageId?image=image_id$imageId";
    final response = await _delete(url, token: token);
    _checkResponse(response);
  }

  // 마이스토리 추가
  Future<void> updateMyStory(
    String token, {
    File? image1,
    File? image2,
    File? image3,
    File? image4,
    File? image5,
    required String payload,
    required int myStoryId,
  }) async {
    final url = Uri.parse(Uri.encodeFull(
        "$_baseUrl$_mystory/$myStoryId/update?mystory_id=$myStoryId"));
    var request = MultipartRequest("POST", url);
    request.headers['Authorization'] = 'Bearer $token';

    if (image5 != null) {
      var picture2 = http.MultipartFile.fromBytes(
          'files', await image5.readAsBytes(),
          filename: 'image5.png');
      request.files.add(picture2);
    }

    if (image4 != null) {
      var picture2 = http.MultipartFile.fromBytes(
          'files', await image4.readAsBytes(),
          filename: 'image4.png');
      request.files.add(picture2);
    }

    if (image3 != null) {
      var picture2 = http.MultipartFile.fromBytes(
          'files', await image3.readAsBytes(),
          filename: 'image3.png');
      request.files.add(picture2);
    }

    if (image2 != null) {
      var picture2 = http.MultipartFile.fromBytes(
          'files', await image2.readAsBytes(),
          filename: 'image2.png');
      request.files.add(picture2);
    }

    if (image1 != null) {
      var picture1 = http.MultipartFile.fromBytes(
          'files', await image1.readAsBytes(),
          filename: 'image1.png');
      request.files.add(picture1);
    }

    request.fields["payload"] = payload;
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return json.decode(respStr);
    } else {
      final body = json.decode(respStr);
      print("API Exception $body");
      throw ApiClientException(statusCode: response.statusCode, body: body);
    }
  }

  // 커뮤니티
  /// 큰 커뮤니티 사진들 get (main)
  Future<Map<String, dynamic>> getCommunityMain(
    String token, {
    required String mainCommunityType,
    required String? searchType,
    required String? searchText,
    int? customerId,
  }) async {
    final url =
        "$_community/$mainCommunityType${customerId != null ? "/customer/$customerId" : ""}/main?${customerId != null ? "customer_id=$customerId&" : ""}${searchType != null && searchText != null ? "&search_type=$searchType" : ""}${searchText != null ? "&search_text=$searchText" : ""}";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 작은 get
  Future<Map<String, dynamic>> getCommunitySub(String token,
      {required String subCommunityType,
      required String? searchType,
      required String? searchText,
      required int page,
      int? customerId,
      df}) async {
    final url =
        "$_community/$subCommunityType?${customerId != null ? "customer_id=$customerId" : ""}page=$page${searchType != null && searchText != null ? "&search_type=$searchType" : ""}${searchText != null ? "&search_text=$searchText" : ""}";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 게시글 한개 get
  Future<Map<String, dynamic>> getCommunity(
    String token, {
    required String subCommunityType,
    required String communityId,
  }) async {
    final url =
        "$_community/${subCommunityType.split("/").first}/$communityId?community_id=$communityId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 이전 커뮤니티 한개
  Future<Map<String, dynamic>> getPreviousCommunity(
    String token, {
    required String subCommunityType,
    required String communityId,
    int? customerId,
  }) async {
    final url =
        "$_community/${subCommunityType.split("/").first}/$communityId${customerId != null ? "/customer/$customerId" : ""}/previous?${customerId != null ? "customer_id=$customerId&" : ""}community_id=$communityId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 다음 커뮤니티 한개
  Future<Map<String, dynamic>> getNextCommunity(
    String token, {
    required String subCommunityType,
    required String communityId,
    int? customerId,
  }) async {
    final url =
        "$_community/${subCommunityType.split("/").first}/$communityId${customerId != null ? "/customer/$customerId" : ""}/next?${customerId != null ? "customer_id=$customerId&" : ""}community_id=$communityId";
    final response = await _get(url, token: token);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 커뮤니티 좋아요, 싫어요
  Future<void> likeDislikeCommunity(
    String token, {
    required bool isLike,
    required String communityId,
  }) async {
    final url =
        "$_community/$communityId/like/dislike?community_id=$communityId&kind=${isLike ? "like" : "dislike"}";
    final response = await _post(url, token: token);
    _checkResponse(response);
  }

  /// 커뮤니티 좋아요, 싫어요 취소
  Future<void> cancelLikeDislikeCommunity(
    String token, {
    required bool isLike,
    required String communityId,
  }) async {
    final url =
        "$_community/$communityId/like/dislike?mystory_id=$communityId&kind=${isLike ? "like" : "dislike"}";
    final response = await _delete(url, token: token);
    _checkResponse(response);
  }

  /// 커뮤니티 댓글
  Future<void> commentCommunity(
    String token, {
    required String communityId,
    required String comment,
  }) async {
    final url =
        "$_community/$communityId/comment?community_id=$communityId&comment=$comment";
    final response = await _post(url, token: token);
    _checkResponse(response);
  }

  /// 커뮤니티 댓글 삭제
  Future<void> deleteCommentCommunity(
    String token, {
    required String commentId,
  }) async {
    final url = "$_community/comment/$commentId?comment_id=$commentId";
    final response = await _delete(url, token: token);
    _checkResponse(response);
  }

  /// 커뮤니티 삭제
  Future<void> deleteCommunity(
    String token, {
    required String communityId,
  }) async {
    final url = "$_community/$communityId?community_id=$communityId";
    final response = await _delete(url, token: token);
    _checkResponse(response);
  }

  /// 커뮤니티 신고
  Future<void> reportCommunity(
    String token, {
    required String communityId,
  }) async {
    final url = "$_community/$communityId/report?community_id=$communityId";
    final response = await _post(url, token: token);
    _checkResponse(response);
  }

  /// 커뮤니티 댓글 신고
  Future<void> reportCommunityComment(
    String token, {
    required String commentId,
    required String content,
  }) async {
    final url =
        "$_community/comment/$commentId/report?comment_id=$commentId&content=$content";
    final response = await _post(url, token: token);
    _checkResponse(response);
  }

  Future<Map<String, dynamic>> uploadCommunity(
    String token, {
    File? image1,
    File? image2,
    File? image3,
    File? image4,
    File? image5,
    required CommunitySubType type,
    required String payload,
    required int customerId,
  }) async {
    final url = Uri.parse(Uri.encodeFull(
        "$_baseUrl$_community/${type.url().split("/").first}/customer/$customerId?customer_id=$customerId"));
    var request = MultipartRequest("POST", url);
    request.headers['Authorization'] = 'Bearer $token';

    if (image1 != null) {
      var picture1 = http.MultipartFile.fromBytes(
          'files', await image1.readAsBytes(),
          filename: 'image1.png');
      request.files.add(picture1);
    }

    if (image2 != null) {
      var picture2 = http.MultipartFile.fromBytes(
          'files', await image2.readAsBytes(),
          filename: 'image2.png');
      request.files.add(picture2);
    }

    if (image3 != null) {
      var picture3 = http.MultipartFile.fromBytes(
          'files', await image3.readAsBytes(),
          filename: 'image3.png');
      request.files.add(picture3);
    }

    if (image4 != null) {
      var picture4 = http.MultipartFile.fromBytes(
          'files', await image4.readAsBytes(),
          filename: 'image4.png');
      request.files.add(picture4);
    }

    if (image5 != null) {
      var picture5 = http.MultipartFile.fromBytes(
          'files', await image5.readAsBytes(),
          filename: 'image5.png');
      request.files.add(picture5);
    }
    request.fields["payload"] = payload;

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return json.decode(respStr);
    } else {
      final body = json.decode(respStr);
      print("API Exception $body");
      throw ApiClientException(statusCode: response.statusCode, body: body);
    }
  }

  Future<Map<String, dynamic>> updateCommunity(
    String token, {
    File? image1,
    File? image2,
    File? image3,
    File? image4,
    File? image5,
    required CommunitySubType type,
    required String payload,
    required int communityId,
  }) async {
    final url = Uri.parse(Uri.encodeFull(
        "$_baseUrl$_community/${type.url().split("/").first}/$communityId/update?community_id=$communityId"));
    var request = MultipartRequest("POST", url);
    request.headers['Authorization'] = 'Bearer $token';

    if (image1 != null) {
      var picture1 = http.MultipartFile.fromBytes(
          'files', await image1.readAsBytes(),
          filename: 'image1.png');
      request.files.add(picture1);
    }

    if (image2 != null) {
      var picture2 = http.MultipartFile.fromBytes(
          'files', await image2.readAsBytes(),
          filename: 'image2.png');
      request.files.add(picture2);
    }
    if (image3 != null) {
      var picture2 = http.MultipartFile.fromBytes(
          'files', await image3.readAsBytes(),
          filename: 'image3.png');
      request.files.add(picture2);
    }
    if (image4 != null) {
      var picture2 = http.MultipartFile.fromBytes(
          'files', await image4.readAsBytes(),
          filename: 'image4.png');
      request.files.add(picture2);
    }

    if (image5 != null) {
      var picture2 = http.MultipartFile.fromBytes(
          'files', await image5.readAsBytes(),
          filename: 'image5.png');
      request.files.add(picture2);
    }

    request.fields["payload"] = payload;

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return json.decode(respStr);
    } else {
      final body = json.decode(respStr);
      print("API Exception $body");
      throw ApiClientException(statusCode: response.statusCode, body: body);
    }
  }

  /// 커뮤니티 이미지 삭제
  Future<void> deleteCommunityImage(
    String token, {
    required String imageId,
  }) async {
    final url = "$_community/image/$imageId?image=image_id$imageId";
    final response = await _delete(url, token: token);
    _checkResponse(response);
  }

  // common
  Future<Map<String, dynamic>> getTerms() async {
    final url = "$_common/terms";
    final response = await _get(url);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  Future<List<dynamic>> getCitys() async {
    final url = "$_common/citys";
    final response = await _get(url);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  Future<List<dynamic>> getCountry(String cityId) async {
    final url = "$_common/citys/$cityId/country";
    final response = await _get(url);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  Future<List<dynamic>> getHobby() async {
    final url = "$_common/hobbys";
    final response = await _get(url);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  Future<List<dynamic>> getFrequentlyQuestions() async {
    final url = "$_common/frequently/asked/questions";
    final response = await _get(url);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  Future<Map<String, dynamic>> getMBTI() async {
    final url = "$_common/mbtis";
    final response = await _get(url);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  Future<List<dynamic>> getTendencies() async {
    final url = "$_common/tendencies";
    final response = await _get(url);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  Future<List<dynamic>> getNotifications() async {
    final url = "$_common/notifications";
    final response = await _get(url);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  Future<Map<String, dynamic>> getNotification({required String id}) async {
    final url = "$_common/notification/$id?notification_id=$id";
    final response = await _get(url);
    _checkResponse(response);
    var result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  // 공휴일
  Future<Map<String, dynamic>> getHolyDay(int year) async {
    final url = Uri.parse(Uri.encodeFull(
        "http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getRestDeInfo?solYear=$year&numOfRows=100&ServiceKey=VmiuEGJughm504SlGiaSfpQukd9mf27WJL2z2subLqfzG9DNUoYqKJ4KU6yHHdkrPuTo0CJwEZHGOhHqss9uFA==&_type=json"));
    var response = await _httpClient.get(url);
    _checkResponse(response);
    Map<String, dynamic> result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }
}
