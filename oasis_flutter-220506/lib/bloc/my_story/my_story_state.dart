import 'package:equatable/equatable.dart';

class MyStoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MyStoryLoading extends MyStoryState {}

class MyStoryLoaded extends MyStoryState {
  final DateTime? updateAt;
  MyStoryLoaded({
    this.updateAt,
  });

  @override
  List<Object?> get props => [
        updateAt,
      ];
}
