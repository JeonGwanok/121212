enum PhoneFieldStatus {
  initial,
  valid,
  invalid,
  userNotFound,
  alreadyInUse,
  fail,
  success,
}

enum NickNameFieldStatus {
  initial, // 항상이상태
  invalid,
  hasSlang,
  alreadyUse,
  fail,
  valid,
  success,
}

enum HeightFieldStatus {
  initial, // 항상이상태
  invalid,
  fail,
  valid,
  success,
}

enum SchoolFieldStatus {
  initial, // 항상이상태
  invalid,
  alreadyUse,
  fail,
  valid,
  success,
}

enum EmailFieldStatus {
  initial,
  invalid,
  valid,
  alreadyInUse,
  fail,
  success,
}

enum PasswordFieldStatus {
  initial,
  invalid,
  wrong,
  fail,
  success,
}

enum RepasswordFieldStatus {
  initial,
  invalid,
  unMatched,
  fail,
  success,
}
