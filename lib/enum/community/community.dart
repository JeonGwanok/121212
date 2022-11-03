enum CommunityType {
  stylist,
  date,
  love,
  marry,
}

extension CommunityTypeExtension on CommunityType {
  String get url {
    switch (this) {
      case CommunityType.stylist:
        return "stylist";
      case CommunityType.date:
        return "date";
      case CommunityType.love:
        return "love";
      case CommunityType.marry:
        return "marry";
    }
  }

  String get title {
    switch (this) {
      case CommunityType.stylist:
        return "코디 👚👕";
      case CommunityType.date:
        return "데이트 👫";
      case CommunityType.love:
        return "연애 💕";
      case CommunityType.marry:
        return "결혼 👩‍❤️‍👨";
    }
  }

  String get writeTitle {
    switch (this) {
      case CommunityType.stylist:
        return "코디 글 작성 👚👕";
      case CommunityType.date:
        return "데이트 글 작성 👫";
      case CommunityType.love:
        return "연애 글 작성 💕";
      case CommunityType.marry:
        return "결혼 글 작성 👩‍❤️‍👨";
    }
  }

  List<CommunitySubType> get subs {
    switch (this) {
      case CommunityType.stylist:
        return [
          CommunitySubType.man,
          CommunitySubType.woman,
          CommunitySubType.season,
        ];
      case CommunityType.date:
        return [
          CommunitySubType.restaurant,
          CommunitySubType.drive,
          CommunitySubType.place,
          CommunitySubType.gift,
        ];
      case CommunityType.love:
        return [
          CommunitySubType.tip,
          CommunitySubType.psychology,
          CommunitySubType.relationship,
        ];
      case CommunityType.marry:
        return [
          CommunitySubType.preparation,
          CommunitySubType.dowry,
          CommunitySubType.house,
          CommunitySubType.loan,
        ];
    }
  }
}

enum CommunitySubType {
  man,
  woman,
  season,
// ==
  restaurant, // /famous/restaurant
  drive,
  place, // /hot/place
  gift,
// ==
  tip,
  psychology,
  relationship,
  // ==
  preparation,
  dowry,
  house, // /newlywed/house
  loan,
}

extension CommunitySubTypeExtension on CommunitySubType {
  String url({String? customerPath = ""}) {
    switch (this) {
      case CommunitySubType.man:
        return "stylist$customerPath/man";
      case CommunitySubType.woman:
        return "stylist$customerPath/woman";
      case CommunitySubType.season:
        return "stylist$customerPath/season";
      case CommunitySubType.restaurant:
        return "date$customerPath/famous/restaurant";
      case CommunitySubType.drive:
        return "date$customerPath/drive";
      case CommunitySubType.place:
        return "date$customerPath/hot/place";
      case CommunitySubType.gift:
        return "date$customerPath/gift";
      case CommunitySubType.tip:
        return "love$customerPath/tip";
      case CommunitySubType.psychology:
        return "love$customerPath/psychology";
      case CommunitySubType.relationship:
        return "love$customerPath/relationship";
      case CommunitySubType.preparation:
        return "marry$customerPath/preparation";
      case CommunitySubType.dowry:
        return "marry$customerPath/dowry";
      case CommunitySubType.house:
        return "marry$customerPath/newlywed/house";
      case CommunitySubType.loan:
        return "marry$customerPath/loan";
    }
  }

  String get topic {
    switch (this) {
      case CommunitySubType.man:
        return "man_style";
      case CommunitySubType.woman:
        return "woman_style";
      case CommunitySubType.season:
        return "season_style";
      case CommunitySubType.restaurant:
        return "famous_restaurant";
      case CommunitySubType.drive:
        return "drive";
      case CommunitySubType.place:
        return "hot_place";
      case CommunitySubType.gift:
        return "gift";
      case CommunitySubType.tip:
        return "love_tip";
      case CommunitySubType.psychology:
        return "love_psychology";
      case CommunitySubType.relationship:
        return "love_relationship";
      case CommunitySubType.preparation:
        return "marry_preparation";
      case CommunitySubType.dowry:
        return "dowry";
      case CommunitySubType.house:
        return "newlywed_house";
      case CommunitySubType.loan:
        return "loan";
    }
  }

  String get title {
    switch (this) {
      case CommunitySubType.man:
        return "남자 코디 👕";
      case CommunitySubType.woman:
        return "여자 코디 👚";
      case CommunitySubType.season:
        return "시즌별 코디 🧥";
      case CommunitySubType.restaurant:
        return "맛집 🫕";
      case CommunitySubType.drive:
        return "드라이브 🚗";
      case CommunitySubType.place:
        return "핫플레이스 🎡";
      case CommunitySubType.gift:
        return "선물 🎁";
      case CommunitySubType.tip:
        return "연애팁 🥰";
      case CommunitySubType.psychology:
        return "연애심리 🧐";
      case CommunitySubType.relationship:
        return "관계개선 🤗";
      case CommunitySubType.preparation:
        return "결혼준비 🎀";
      case CommunitySubType.dowry:
        return "혼수 💍";
      case CommunitySubType.house:
        return "신혼집 🏡";
      case CommunitySubType.loan:
        return "대출 💵";
    }
  }


  CommunityType get parent {
    switch (this) {
      case CommunitySubType.man:
      case CommunitySubType.woman:
      case CommunitySubType.season:
        return CommunityType.stylist;
      case CommunitySubType.restaurant:
      case CommunitySubType.drive:
      case CommunitySubType.place:
      case CommunitySubType.gift:
        return CommunityType.date;
      case CommunitySubType.tip:
      case CommunitySubType.psychology:
      case CommunitySubType.relationship:
        return CommunityType.love;
      case CommunitySubType.preparation:
      case CommunitySubType.dowry:
      case CommunitySubType.house:
      case CommunitySubType.loan:
        return CommunityType.marry;
    }
  }
}
