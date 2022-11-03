import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/common/notification.dart';

class NotificationListState extends Equatable {
  final ScreenStatus status;
  final List<NotificationModel> items;

  NotificationListState({
    this.status = ScreenStatus.initial,
    this.items = const [],
  });

  NotificationListState copyWith(
      {ScreenStatus? status, List<NotificationModel>? items}) {
    return NotificationListState(
      status: status ?? this.status,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
      ];
}
