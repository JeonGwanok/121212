import 'package:equatable/equatable.dart';
import 'package:oasis/model/user/user_profile.dart';

class AppEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppInitialize extends AppEvent {
  final UserProfile? user;

  AppInitialize({this.user});
  @override
  List<Object?> get props => [user];
}

class AppUpdate extends AppEvent {
  final UserProfile? user;

  AppUpdate({this.user});
  @override
  List<Object?> get props => [user];
}