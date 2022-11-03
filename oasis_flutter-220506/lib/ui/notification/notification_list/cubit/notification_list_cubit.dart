import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/common_repository.dart';

import 'notification_list_state.dart';

class NotificationListCubit extends Cubit<NotificationListState> {
  final CommonRepository commonRepository;

  NotificationListCubit({required this.commonRepository})
      : super(NotificationListState());

  Future<void> initialize() async {
    try {
      emit(state.copyWith(status: ScreenStatus.loading));
      var items = await commonRepository.getNotifications();
      emit(state.copyWith(
        items: items,
        status: ScreenStatus.loaded,
      ));
    } catch (err) {
      emit(state.copyWith(status: ScreenStatus.fail));
    }
  }
}
