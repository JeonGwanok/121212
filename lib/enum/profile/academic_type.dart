// 네이밍 어떻게 해야할지 모르겠어서 일단 알파벳으로 대체
enum AcademicType { a, b, c, d, e, f, g, h }

extension AcademicTypeExtension on AcademicType {
  String get title {
    switch (this) {
      case AcademicType.a:
        return "고졸";
      case AcademicType.b:
        return "전문대 재학";
      case AcademicType.c:
        return "전문대 졸업";
      case AcademicType.d:
        return "대학 재학";
      case AcademicType.e:
        return "대학 졸업";
      case AcademicType.f:
        return "대학원 재학";
      case AcademicType.g:
        return "대학원 졸업";
      case AcademicType.h:
        return "박사 이상";
    }
  }
}

AcademicType? academicStringToType(String academic) {
  switch (academic) {
    case "고졸":
      return AcademicType.a;
    case "전문대 재학":
      return AcademicType.b;
    case "전문대 졸업":
      return AcademicType.c;
    case "대학 재학":
      return AcademicType.d;
    case "대학 졸업":
      return AcademicType.e;
    case "대학원 재학":
      return AcademicType.f;
    case "대학원 졸업":
      return AcademicType.g;
    case "박사 이상":
      return AcademicType.h;
  }
  return null;
}
