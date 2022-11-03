import 'dart:ui';

import '../theme.dart';

enum PurchaseType {
  meeting01,
  meeting03,
  meeting05,
  meeting10,
  basic,
  gold,
  blue,
  diamond,
}

extension PurchaseTypeExtension on PurchaseType {
  bool enableDisplay(
      String? currentMembership, bool isIos, bool showOnlyMembership) {
    if (currentMembership == null) {
      switch (this) {
        case PurchaseType.meeting01:
        case PurchaseType.meeting03:
          return !showOnlyMembership && currentMembership != null && true;
        case PurchaseType.meeting05:
          return !showOnlyMembership && currentMembership != null && !isIos;
        case PurchaseType.meeting10:
          return !showOnlyMembership && currentMembership != null && !isIos;
        case PurchaseType.gold:
        case PurchaseType.diamond:
        case PurchaseType.blue:
          return !isIos;
        case PurchaseType.basic:
          return true;
      }
    } else {
      switch (this) {
        case PurchaseType.meeting01:
        case PurchaseType.meeting03:
          return !showOnlyMembership && true;
        case PurchaseType.meeting05:
        case PurchaseType.meeting10:
          return !showOnlyMembership && true;
        case PurchaseType.gold:
          return (currentMembership != "gold" &&
                  currentMembership != "diamond") &&
              !isIos;
        case PurchaseType.basic:
          return false;
        case PurchaseType.blue:
          return currentMembership != "gold" && currentMembership != "blue" &&  currentMembership != "diamond" && !isIos;
        case PurchaseType.diamond:
          return currentMembership != "diamond" && !isIos;

      }
    }
  }

  String? get title {
    switch (this) {
      case PurchaseType.meeting01:
        return "*1*회 만남권";
      case PurchaseType.meeting03:
        return "*3*회 만남권";
      case PurchaseType.meeting05:
        return "*5*회 만남권";
      case PurchaseType.meeting10:
        return "*10*회 만남권";
      case PurchaseType.gold:
        return null;
      case PurchaseType.basic:
        return null;
      case PurchaseType.diamond:
        return null;
      case PurchaseType.blue:
      return null;
    }
  }

  String? get id {
    switch (this) {
      case PurchaseType.meeting01:
        return "oasis_meeting_01";
      case PurchaseType.meeting03:
        return "oasis_meeting_03";
      case PurchaseType.meeting05:
        return "oasis_meeting_05";
      case PurchaseType.meeting10:
        return "oasis_meeting_10";
      case PurchaseType.gold:
        return "oasis_gold";
      case PurchaseType.basic:
        return "oasis_basic";
      case PurchaseType.diamond:
        return null;
      case PurchaseType.blue:
        return null;
    }
  }

  String? get priceLabel {
    switch (this) {
      case PurchaseType.meeting01:
        return "149,000";
      case PurchaseType.meeting03:
        return "450,000";
      case PurchaseType.meeting05:
        return "590,000"; //
      case PurchaseType.meeting10:
        return "1,190,000"; //
      case PurchaseType.gold:
        return "990,000"; //
      case PurchaseType.basic:
        return "299,000";
      case PurchaseType.blue:
        return "1,999,000";
      case PurchaseType.diamond:
        return "9,998,000";
    }
  }

  int? get price {
    switch (this) {
      case PurchaseType.meeting01:
        return 149000;
      case PurchaseType.meeting03:
        return 450000;
      case PurchaseType.meeting05:
        return 590000; //
      case PurchaseType.meeting10:
        return 1190000; //
      case PurchaseType.gold:
        return 990000; //
      case PurchaseType.basic:
        return 299000;
      case PurchaseType.blue:
        return 1999000;
      case PurchaseType.diamond:
        return 9998000;
    }
  }

  bool enablePurchase(bool isIos) {
    switch (this) {
      case PurchaseType.meeting01:
      case PurchaseType.meeting03:
        return true;
      case PurchaseType.meeting05:
      case PurchaseType.meeting10:
        return false;
      case PurchaseType.gold:
        return isIos; //
      case PurchaseType.basic:
        return true;
      case PurchaseType.blue:
        return false;
      case PurchaseType.diamond:
        return false;
    }
  }

  String? get image {
    switch (this) {
      case PurchaseType.meeting01:
      case PurchaseType.meeting03:
      case PurchaseType.meeting05:
      case PurchaseType.meeting10:
        return null;
      case PurchaseType.gold:
        return "icons/gold_price";
      case PurchaseType.basic:
        return "icons/basic_price";
      case PurchaseType.diamond:
        return "icons/diamond_price";
      case PurchaseType.blue:
        return "icons/blue_prcie";
    }
  }

  String? get keyImage {
    switch (this) {
      case PurchaseType.meeting01:
      case PurchaseType.meeting03:
      case PurchaseType.meeting05:
      case PurchaseType.meeting10:
        return null;
      case PurchaseType.gold:
        return "icons/gold_key";
      case PurchaseType.basic:
        return "icons/basic_key";
      case PurchaseType.diamond:
        return "icons/diamond_key";
      case PurchaseType.blue:
        return "icons/blue_key";
    }
  }

  String? get badgeImage {
    switch (this) {
      case PurchaseType.meeting01:
      case PurchaseType.meeting03:
      case PurchaseType.meeting05:
      case PurchaseType.meeting10:
        return null;
      case PurchaseType.gold:
        return "icons/gold_badge";
      case PurchaseType.basic:
        return "icons/basic_badge";
      case PurchaseType.diamond:
        return "icons/diamod_badge";
      case PurchaseType.blue:
        return "icons/blue_badge";
    }
  }

  Color? get color {
    switch (this) {
      case PurchaseType.meeting01:
      case PurchaseType.meeting03:
      case PurchaseType.meeting05:
      case PurchaseType.meeting10:
        return null;
      case PurchaseType.gold:
        return yellow;
      case PurchaseType.blue:
        return Color(0xff8BB9FF);
      case PurchaseType.basic:
        return Color.fromRGBO(214, 224, 229, 1);
      case PurchaseType.diamond:
        return Color.fromRGBO(190, 224, 229, 1);
    }
  }

  List<String>? get descriptions {
    switch (this) {
      case PurchaseType.meeting01:
        return [];
      case PurchaseType.meeting03:
        return [];
      case PurchaseType.meeting05:
        return ["22% 할인"];
      case PurchaseType.meeting10:
        return ["20% 할인"];
      case PurchaseType.gold:
        return ["10+1회 만남권", "매칭 카드 1장 추가", "우선 매칭"];
      case PurchaseType.blue:
        return ["1년 무제한", "매칭 카드 1장 추가","우선 매칭"];
      case PurchaseType.basic:
        return ["3회 만남권", "매칭 가능"];
      case PurchaseType.diamond:
        return ["결혼할 때까지 무제한", "매칭 카드 1장 추가", "최우선 매칭", "결혼성사시\n2백만원 상당 다이아"];
    }
  }
}
