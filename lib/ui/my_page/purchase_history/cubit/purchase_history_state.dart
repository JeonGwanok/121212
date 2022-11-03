import 'package:equatable/equatable.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/user/purchase_history.dart';

class PurchaseHistoryState extends Equatable {
  final ScreenStatus status;
  final PurchaseHistory purchaseHistory;

  PurchaseHistoryState({
    this.status = ScreenStatus.initial,
    this.purchaseHistory = PurchaseHistory.empty,
  });

  PurchaseHistoryState copyWith({
    ScreenStatus? status,
    PurchaseHistory? purchaseHistory,
  }) {
    return PurchaseHistoryState(
      status: status ?? this.status,
      purchaseHistory: purchaseHistory ?? this.purchaseHistory,
    );
  }

  @override
  List<Object?> get props => [status, purchaseHistory];
}
