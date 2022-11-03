import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/user/cut_phone.dart';

class CutPhoneMainState extends Equatable {
  final ScreenStatus status;
  final List<CutPhone> registered;
  CutPhoneMainState({
    this.status = ScreenStatus.initial,
    this.registered = const [],
  });

  CutPhoneMainState copyWith(
      {ScreenStatus? status, List<CutPhone>? registered}) {
    return CutPhoneMainState(
      status: status ?? this.status,
      registered: registered ?? this.registered,
    );
  }

  @override
  List<Object?> get props => [
        status,
        registered,
      ];
}
