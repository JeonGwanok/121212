import 'package:equatable/equatable.dart';

class UserImage extends Equatable {
  final int? id;
  final String? representative1;
  final String? representative2;
  final String? face1;
  final String? face2;
  final String? free;

  const UserImage({
    this.id,
    this.representative1,
    this.representative2,
    this.face1,
    this.face2,
    this.free,
  });

  static const empty = UserImage();

  factory UserImage.fromJson(Map<String, dynamic> json) {
    return UserImage(
      id: json["id"],
      representative1: json["representative1"],
      representative2: json["representative2"],
      face1: json["face1"],
      face2: json["face2"],
      free: json["free"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "representative1": representative1,
      "representative2": representative2,
      "face1": face1,
      "face2": face2,
      "free": free,
    };
  }

  List<String> get imagesToList {
    List<String> items = [];
    for (var item in [representative1, representative2, face1, face2, free]) {
      if (item != null) {
        items.add(item);
      }
    }
    return items;
  }

  UserImage copyWith({
    int? id,
    String? representative1,
    String? representative2,
    String? face1,
    String? face2,
    String? free,
  }) {
    return UserImage(
      id: id ?? this.id,
      representative1: representative1 ?? this.representative1,
      representative2: representative2 ?? this.representative2,
      face1: face1 ?? this.face1,
      face2: face2 ?? this.face2,
      free: free ?? this.free,
    );
  }

  @override
  List<Object?> get props => [
        id,
        representative1,
        representative2,
        face1,
        face2,
        free,
      ];
}
