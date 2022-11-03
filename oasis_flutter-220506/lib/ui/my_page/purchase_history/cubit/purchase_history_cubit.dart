import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/my_page/purchase_history/cubit/purchase_history_state.dart';

class PurchaseHistoryCubit extends Cubit<PurchaseHistoryState> {
  final UserRepository userRepository;

  PurchaseHistoryCubit({
    required this.userRepository,
  }) : super(PurchaseHistoryState());

  initialize() async {
    try {
      emit(state.copyWith(
        status: ScreenStatus.loading,
      ));
      var user = await userRepository.getUser();
      var history = await userRepository.getPurchaseHistory(
          customerId: "${user.customer?.id}");
      emit(state.copyWith(
        purchaseHistory: history,
        status: ScreenStatus.success,
      ));
    } catch (err) {
      emit(state.copyWith(
        status: ScreenStatus.fail,
      ));
    }
  }
}
