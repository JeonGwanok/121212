enum MarriageType { single, married }

extension MarriageTypeExtension on MarriageType {
  String get title {
    switch (this) {
      case MarriageType.married:
        return "재혼";
      case MarriageType.single:
        return "미혼";
    }
  }
}

MarriageType marriageStringToType(String marriage) {
  if (marriage == "재혼") {
    return MarriageType.married;
  } else {
    return MarriageType.single;
  }
}


enum HasChildrenType { no, yes }

extension HasChildrenTypeExtension on HasChildrenType {
  String get title {
    switch (this) {
      case HasChildrenType.yes:
        return "있음";
      case HasChildrenType.no:
        return "없음";
    }
  }
}

HasChildrenType hasChildrenStringToType(bool children) {
  if (children) {
    return HasChildrenType.yes;
  } else {
    return HasChildrenType.no;
  }
}
