import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/user/user_profile.dart';

class PurchaseState extends Equatable {
  final ScreenStatus status;
  final UserProfile user;
  final List<ProductDetails> products;

  PurchaseState({
    this.user = UserProfile.empty,
    this.products = const [],
    this.status = ScreenStatus.initial,
  });

  PurchaseState copyWith({
    ScreenStatus? status,
    UserProfile? user,
    List<ProductDetails>? products,
  }) {
    return PurchaseState(
      user: user ?? this.user,
      products: products ?? this.products,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        user,
      ];
}
