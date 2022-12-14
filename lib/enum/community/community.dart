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
        return "μ½λ ππ";
      case CommunityType.date:
        return "λ°μ΄νΈ π«";
      case CommunityType.love:
        return "μ°μ  π";
      case CommunityType.marry:
        return "κ²°νΌ π©ββ€οΈβπ¨";
    }
  }

  String get writeTitle {
    switch (this) {
      case CommunityType.stylist:
        return "μ½λ κΈ μμ± ππ";
      case CommunityType.date:
        return "λ°μ΄νΈ κΈ μμ± π«";
      case CommunityType.love:
        return "μ°μ  κΈ μμ± π";
      case CommunityType.marry:
        return "κ²°νΌ κΈ μμ± π©ββ€οΈβπ¨";
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
        return "λ¨μ μ½λ π";
      case CommunitySubType.woman:
        return "μ¬μ μ½λ π";
      case CommunitySubType.season:
        return "μμ¦λ³ μ½λ π§₯";
      case CommunitySubType.restaurant:
        return "λ§μ§ π«";
      case CommunitySubType.drive:
        return "λλΌμ΄λΈ π";
      case CommunitySubType.place:
        return "ν«νλ μ΄μ€ π‘";
      case CommunitySubType.gift:
        return "μ λ¬Ό π";
      case CommunitySubType.tip:
        return "μ°μ ν π₯°";
      case CommunitySubType.psychology:
        return "μ°μ μ¬λ¦¬ π§";
      case CommunitySubType.relationship:
        return "κ΄κ³κ°μ  π€";
      case CommunitySubType.preparation:
        return "κ²°νΌμ€λΉ π";
      case CommunitySubType.dowry:
        return "νΌμ π";
      case CommunitySubType.house:
        return "μ νΌμ§ π‘";
      case CommunitySubType.loan:
        return "λμΆ π΅";
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
