import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/bloc/app/app_event.dart';
import 'package:oasis/bloc/app/app_state.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/purchase/cubit/purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final AppBloc appBloc;
  final UserRepository userRepository;

  StreamSubscription? _subscription;

  PurchaseCubit({required this.appBloc, required this.userRepository})
      : super(PurchaseState()) {
    _subscription = appBloc.stream.listen(_update);
    _update(appBloc.state);
  }

  void _update(AppState appState) {
    AppState _appState = appBloc.state;
    if (_appState is AppLoaded) {
      initialize();
    }
  }

  StreamSubscription? _purchaseSubscription;

  initialize() async {
    emit(state.copyWith(status: ScreenStatus.loading));
    var user = await userRepository.getUser();
    final bool available = await _inAppPurchase.isAvailable();

    List<ProductDetails> purchases = [];
    if (available) {
      Set<String> ids = {};

      if (Platform.isIOS) {
        ids = Set<String>.from([
          "oasis_basic",
          "oasis_gold",
          "oasis_meeting_01",
          "oasis_meeting_03",
          "oasis_meeting_05",
          "oasis_meeting_10",
        ]);
      } else {
        ids = Set<String>.from([
          "oasis_basic",
          "oasis_meeting_01",
          "oasis_meeting_03",
        ]);
      }

      ProductDetailsResponse res =
          await _inAppPurchase.queryProductDetails(ids);
      purchases = res.productDetails;
      _purchaseSubscription =
          _inAppPurchase.purchaseStream.listen((event) async {
        if (event.isNotEmpty) {
          var _eventStatus = event.first.status;

          switch (_eventStatus) {
            case PurchaseStatus.pending:
              emit(state.copyWith(status: ScreenStatus.fail));
              break;
            case PurchaseStatus.purchased:
              var price = 0;
              var id = "";
              switch (event.first.productID) {
                case "oasis_basic":
                  id = "basic";
                  price = 299000;
                  break;
                case "oasis_gold":
                  id = "gold";
                  price = 990000;
                  break;
                case "oasis_meeting_01":
                  id = "meeting-1";
                  price = 149000;
                  break;
                case "oasis_meeting_03":
                  id = "meeting-3";
                  price = 450000;
                  break;
              }

              await userRepository.updatePurchase(
                  customerId: "${user.customer?.id}", kind: id, price: price);
              emit(state.copyWith(status: ScreenStatus.success));
              appBloc.add(AppUpdate());
              break;
            case PurchaseStatus.restored:
              break;
            case PurchaseStatus.error:
              emit(state.copyWith(status: ScreenStatus.fail));
              break;
            case PurchaseStatus.canceled:
              emit(state.copyWith(status: ScreenStatus.fail));
              break;
          }
        }
      }, onDone: () {
        appBloc.add(AppUpdate());
      }, onError: (_) {
        emit(state.copyWith(status: ScreenStatus.fail));
      });
    }

    emit(state.copyWith(
        user: user, products: purchases, status: ScreenStatus.loaded));
  }

  var _inAppPurchase = InAppPurchase.instance;

  buy(String id) async {
    ProductDetails? details;
    for (var item in state.products) {
      if (item.id == id) {
        details = item;
        break;
      }
    }

    if (details != null) {
      emit(state.copyWith(status: ScreenStatus.loading));
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: details);
      var test =
          await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _purchaseSubscription?.cancel();
    return super.close();
  }
}
