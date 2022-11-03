import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/user/user_profile.dart';

class ProfileImageUpdateState extends Equatable {
  final ScreenStatus status;
  final UserProfile user;

  final File? representative1;
  final File? representative2;
  final File? face1;
  final File? face2;
  final File? free;

  ProfileImageUpdateState({
    this.status = ScreenStatus.initial,
    this.user = UserProfile.empty,
    this.representative1,
    this.representative2,
    this.face1,
    this.face2,
    this.free,
  });

  ProfileImageUpdateState copyWith({
    ScreenStatus? status,
    UserProfile? user,
    File? representative1,
    File? representative2,
    File? face1,
    File? face2,
    File? free,
  }) {
    return ProfileImageUpdateState(
      status: status ?? this.status,
      user: user ?? this.user,
      representative1: representative1 ?? this.representative1,
      representative2: representative2 ?? this.representative2,
      face1: face1 ?? this.face1,
      face2: face2 ?? this.face2,
      free: free ?? this.free,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        representative1,
        representative2,
        face1,
        face2,
        free,
      ];
}
