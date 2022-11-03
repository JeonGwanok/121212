import 'package:equatable/equatable.dart';

class UserMBTIMain extends Equatable {
  final int? eValue; // "e_value": 0,
  final int? iValue; // "i_value": 0,
  final int? sValue; // "s_value": 0,
  final int? nValue; // "n_value": 0,
  final int? tValue; // "t_value": 0,
  final int? fValue; // "f_value": 0,
  final int? jValue; // "j_value": 0,
  final int? pValue; // "p_value": 0,
  final int? responsibilityValue; // "responsibility_value": 0,
  final int? passionValue; // "passion_value": 0,
  final int? dedicationValue; // "dedication_value": 0,
  final String? myTendency; // "my_tendency": "string"

  const UserMBTIMain({
    this.eValue,
    this.iValue,
    this.sValue,
    this.nValue,
    this.tValue,
    this.fValue,
    this.jValue,
    this.pValue,
    this.responsibilityValue,
    this.passionValue,
    this.dedicationValue,
    this.myTendency,
  });

  static const empty = UserMBTIMain();

  factory UserMBTIMain.fromJson(Map<String, dynamic> json) {
    return UserMBTIMain(
      eValue: json["e_value"],
      iValue: json["i_value"],
      sValue: json["s_value"],
      nValue: json["n_value"],
      tValue: json["t_value"],
      fValue: json["f_value"],
      jValue: json["j_value"],
      pValue: json["p_value"],
      responsibilityValue: json["responsibility_value"],
      passionValue: json["passion_value"],
      dedicationValue: json["dedication_value"],
      myTendency: json["my_tendency"],
    );
  }

  @override
  List<Object?> get props => [
        eValue,
        iValue,
        sValue,
        nValue,
        tValue,
        fValue,
        jValue,
        pValue,
        responsibilityValue,
        passionValue,
        dedicationValue,
        myTendency,
      ];
}
