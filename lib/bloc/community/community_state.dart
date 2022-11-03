import 'package:equatable/equatable.dart';

class CommunityState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CommunityLoading extends CommunityState {}

class CommunityLoaded extends CommunityState {
  final DateTime? updateAt;
  CommunityLoaded({this.updateAt});

  @override
  List<Object?> get props => [updateAt];
}
