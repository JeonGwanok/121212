import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/common/notification.dart';

class NotificationDetailState extends Equatable {
  final ScreenStatus status;
  final NotificationModel item;

  NotificationDetailState({
    this.status = ScreenStatus.initial,
    this.item = NotificationModel.empty,
  });

  NotificationDetailState copyWith(
      {ScreenStatus? status, NotificationModel? item}) {
    return NotificationDetailState(
      status: status ?? this.status,
      item: item ?? this.item,
    );
  }

  @override
  List<Object?> get props => [
        status,
        item,
      ];
}
