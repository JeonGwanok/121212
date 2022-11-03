import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/matching/ai_matching.dart';
import 'package:oasis/model/matching/matchings.dart';

class AiMatchingListState extends Equatable {
  final ScreenStatus status;
  final List<AiMatching> aiMatchings;

  AiMatchingListState({
    this.status = ScreenStatus.success,
    this.aiMatchings = const [],
  });

  AiMatchingListState copyWith({
    ScreenStatus? status,
    List<AiMatching>? aiMatchings,
  }) {
    return AiMatchingListState(
      status: status ?? this.status,
      aiMatchings: aiMatchings ?? this.aiMatchings,
    );
  }

  @override
  List<Object?> get props => [
        status,
        aiMatchings,
      ];
}
