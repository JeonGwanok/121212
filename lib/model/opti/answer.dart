import 'package:equatable/equatable.dart';

class OBTIAnswer extends Equatable {
  final int? numbering; // "numbering": 0,
  final int? example; // "example": 0,

  OBTIAnswer({
    this.numbering,
    this.example,
  });

  Map<String, dynamic> toJson() {
    return {
      "numbering": numbering,
      "example": example,
    };
  }

  @override
  List<Object?> get props => [
        numbering,
        example,
      ];
}