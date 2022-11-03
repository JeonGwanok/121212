enum MyStoryType { daily, love, marry }

extension MyStoryTypeExtension on MyStoryType {
  String get key {
    switch (this) {
      case MyStoryType.daily:
        return "daily";
      case MyStoryType.love:
        return "love";
      case MyStoryType.marry:
        return "marry";
    }
  }

  String get title {
    switch (this) {
      case MyStoryType.daily:
        return "나의 일상 🏠";
      case MyStoryType.love:
        return "연애 이야기 💕";
      case MyStoryType.marry:
        return "결혼 이야기 👩‍❤️‍";
    }
  }
}