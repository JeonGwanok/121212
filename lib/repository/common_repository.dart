import 'package:intl/intl.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/model/common/citys.dart';
import 'package:oasis/model/common/frequency_question.dart';
import 'package:oasis/model/common/hobby.dart';
import 'package:oasis/model/common/notification.dart';
import 'package:oasis/model/common/terms.dart';
import 'package:oasis/model/opti/mbti.dart';
import 'package:oasis/model/opti/tendencies.dart';
import 'package:oasis/model/user/iamport_result.dart';
import 'package:oasis/ui/util/date.dart';

class CommonRepository {
  final ApiProvider _apiClient;

  CommonRepository({
    required ApiProvider apiClient,
  }) : _apiClient = apiClient;

  Future<IamportResult> getIamportInfo(String impUid) async {
    IamportResult result = IamportResult.empty;
    try {
      var response = await _apiClient.getIamportInfo(impUid);
      result = IamportResult.fromJson(response["response"] ?? {});
    } on ApiClientException {}

    return result;
  }

  Future<Terms> getTerms() async {
    try {
      var result = await _apiClient.getTerms();
      var terms = Terms.fromJson(result);
      return terms;
    } on ApiClientException catch (err) {
      throw err;
    }
  }

  Future<List<City>> getCitys() async {
    try {
      var result = await _apiClient.getCitys();
      var citys = result.map((e) => City.fromJson(e)).toList();
      return citys;
    } on ApiClientException catch (err) {
      throw err;
    }
  }

  Future<List<Country>> getCountry(String cityId) async {
    try {
      var result = await _apiClient.getCountry(cityId);
      var country = result.map((e) => Country.fromJson(e)).toList();
      return country;
    } on ApiClientException catch (err) {
      throw err;
    }
  }

  Future<List<Hobby>> getHobby() async {
    try {
      var result = await _apiClient.getHobby();
      var hobby = result.map((e) => Hobby.fromJson(e)).toList();
      return hobby;
    } on ApiClientException catch (err) {
      throw err;
    }
  }

  Future<List<FrequentlyQuestion>> getFrequentlyQuestions() async {
    try {
      var result = await _apiClient.getFrequentlyQuestions();
      var question = result.map((e) => FrequentlyQuestion.fromJson(e)).toList();
      return question;
    } on ApiClientException catch (err) {
      throw err;
    }
  }

  Future<MBTI> getMBTI() async {
    try {
      var result = await _apiClient.getMBTI();
      var mbti = MBTI.fromJson(result);
      return mbti;
    } on ApiClientException catch (err) {
      throw err;
    }
  }

  Future<List<Tendency>> getTendencies() async {
    try {
      var result = await _apiClient.getTendencies();
      var tendencies = result.map((e) => Tendency.fromJson(e)).toList();
      return tendencies;
    } on ApiClientException catch (err) {
      throw err;
    }
  }

  Future<List<NotificationModel>> getNotifications() async {
    try {
      var result = await _apiClient.getNotifications();
      var notifications =
          result.map((e) => NotificationModel.fromJson(e)).toList();
      return notifications;
    } on ApiClientException catch (err) {
      throw err;
    }
  }

  Future<NotificationModel> getNotification({required int id}) async {
    try {
      var result = await _apiClient.getNotification(id: "$id");
      var notification = NotificationModel.fromJson(result);
      return notification;
    } on ApiClientException catch (err) {
      throw err;
    }
  }

  Future<List<DateTime>> getHolyDay(int year) async {
    try {
      var json = await _apiClient.getHolyDay(year);
      var _items = json["response"]["body"]["items"]["item"];
      List<String> _result =
          (_items as List<dynamic>).map((e) => "${e["locdate"]}").toList();

      var holydays = _result.map((e) {
        var item =
            "${e.substring(0, 4)}-${e.substring(4, 6)}-${e.substring(6, 8)}";
        return Date.clearDate(
            DateFormat("yyyy-MM-dd").parse(item, true).toLocal());
      }).toList();

      return holydays;
    } catch (ex) {
      print("Exception ${ex.toString()}");
    }
    return [];
  }
}
