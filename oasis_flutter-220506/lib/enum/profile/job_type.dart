enum JobType {
  student,
  officeWorker,
  profession,
  publicOfficial,
  business,
  freelancer,
  artist,
}

extension JobTypeExtension on JobType {
  String get title {
    switch (this) {
      case JobType.student:
        return "학생";
      case JobType.officeWorker:
        return "직장인";
      case JobType.profession:
        return "전문직";
      case JobType.publicOfficial:
        return "공무원/공기업";
      case JobType.business:
        return "사업/자영업";
      case JobType.freelancer:
        return "프리랜서";
      case JobType.artist:
        return "문화예술인";
    }
  }
}

JobType? jobStringToType(String job) {
    switch (job) {
      case "학생":
        return JobType.student;
      case "직장인":
        return JobType.officeWorker;
      case "전문직":
        return JobType.profession ;
      case "공무원/공기업":
        return JobType.publicOfficial ;
      case "사업/자영업":
        return JobType.business ;
      case "프리랜서":
        return JobType.freelancer;
      case "문화예술인":
        return JobType.artist;
    }

}
