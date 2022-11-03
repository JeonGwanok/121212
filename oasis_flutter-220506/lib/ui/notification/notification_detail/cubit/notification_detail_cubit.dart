import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/common/notification.dart';
import 'package:oasis/repository/common_repository.dart';

import 'notification_detail_state.dart';

class NotificationDetailCubit extends Cubit<NotificationDetailState> {
  final CommonRepository commonRepository;
  final NotificationModel item;

  NotificationDetailCubit({
    required this.commonRepository,
    required this.item,
  }) : super(NotificationDetailState());

  Future<void> initialize() async {
    try {
      emit(state.copyWith(
        item: item,
        status: ScreenStatus.loaded,
      ));
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }
}
