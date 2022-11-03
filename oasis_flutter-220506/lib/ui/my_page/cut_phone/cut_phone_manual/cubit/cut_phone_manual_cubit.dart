import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/model/user/cut_phone.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/sign/util/field_status.dart';
import 'package:oasis/ui/sign/util/validator.dart';

import 'cut_phone_manual_state.dart';

class CutPhoneManualCubit extends Cubit<CutPhoneManualState> {
  final UserRepository userRepository;
  CutPhoneManualCubit({
    required this.userRepository,
  }) : super(CutPhoneManualState());

  initialize() async {
    try {
      emit(state.copyWith(status: CutPhoneManualScreenStatus.loading));
      final user = await userRepository.getUser();
      final registered =
          await userRepository.getCutPhones(customerId: "${user.customer?.id}");
      emit(state.copyWith(
          registered:
              registered.where((e) => e.kind == CutPhoneType.direct).toList(),
          selected: [],
          name: "",
          phoneNumber: "",
          status: CutPhoneManualScreenStatus.loaded));
    } on ApiClientException catch (err) {
      emit(state.copyWith(status: CutPhoneManualScreenStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: CutPhoneManualScreenStatus.fail));
    }
  }

  remove(CutPhone phone) async {
    try {
      emit(state.copyWith(status: CutPhoneManualScreenStatus.loading));
      final user = await userRepository.getUser();
      await userRepository
          .deleteCutPhones(customerId: "${user.customer?.id}", items: [phone]);
      emit(state.copyWith(status: CutPhoneManualScreenStatus.removeSuccess));
      initialize();
    } on ApiClientException catch (err) {
      emit(state.copyWith(status: CutPhoneManualScreenStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: CutPhoneManualScreenStatus.fail));
    }
  }

  select(CutPhone phone) {
    var items = [...state.selected];
    items.add(phone);
    emit(state.copyWith(selected: items));
  }

  unselect(CutPhone phone) {
    var items = [...state.selected];
    for (var i = 0; i < items.length; i++) {
      if (phone == items[i]) {
        items.removeAt(i);
        break;
      }
    }

    emit(state.copyWith(selected: items));
  }

  save() async {
    try {
      emit(state.copyWith(
          status: CutPhoneManualScreenStatus.loading, switchOff: false));
      final user = await userRepository.getUser();
      await userRepository.uploadCutPhones(
          customerId: "${user.customer?.id}",
          items: state.selected,
          kind: CutPhoneType.contract);
      emit(state.copyWith(
        status: CutPhoneManualScreenStatus.selectCutsSuccess,
        phoneFieldStatus: PhoneFieldStatus.initial,
      ));
      initialize();
    } on ApiClientException catch (err) {
      emit(state.copyWith(
          status: CutPhoneManualScreenStatus.fail, switchOff: true));
    } catch (err) {
      emit(state.copyWith(
          status: CutPhoneManualScreenStatus.fail, switchOff: true));
    }
  }

  enterName(String name) {
    emit(state.copyWith(name: name));
  }

  enterPhoneNumber(String phoneNumber) {
    emit(state.copyWith(
      phoneNumber: phoneNumber,
      phoneFieldStatus: Validator.phoneValidator(phoneNumber),
    ));
  }

  addPhoneNumber() async {
    try {
      emit(state.copyWith(status: CutPhoneManualScreenStatus.loading));
      final user = await userRepository.getUser();
      await userRepository.uploadCutPhones(
        customerId: "${user.customer?.id}",
        kind: CutPhoneType.direct,
        items: [CutPhone(name: state.name, phoneNumber: state.phoneNumber)],
      );
      emit(state.copyWith(status: CutPhoneManualScreenStatus.success));
      initialize();
    } on ApiClientException catch (err) {
      emit(state.copyWith(status: CutPhoneManualScreenStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: CutPhoneManualScreenStatus.fail));
    }
  }

  // 전체 차단
  allCut() async {
    try {
      emit(state.copyWith(
          status: CutPhoneManualScreenStatus.loading, switchOff: false));
      final user = await userRepository.getUser();
      await userRepository.uploadCutPhones(
          customerId: "${user.customer?.id}",
          items: state.registered.map((e) {
            return e;
          }).toList(),
          kind: CutPhoneType.contract);
      final registered =
          await userRepository.getCutPhones(customerId: "${user.customer?.id}");
      emit(state.copyWith(
        status: CutPhoneManualScreenStatus.registerCutsSuccess,
        registered: registered,
      ));
      initialize();
    } on ApiClientException catch (err) {
      emit(state.copyWith(status: CutPhoneManualScreenStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: CutPhoneManualScreenStatus.fail));
    }
  }

  // 전체 차단 해제
  allRemove() async {
    try {
      emit(state.copyWith(
          status: CutPhoneManualScreenStatus.loading, switchOff: true));
      final user = await userRepository.getUser();
      await userRepository.deleteCutPhones(
        customerId: "${user.customer?.id}",
        items: state.registered,
      );
      emit(state.copyWith(
          status: CutPhoneManualScreenStatus.registerRemoveSuccess));
      initialize();
    } on ApiClientException catch (err) {
      emit(state.copyWith(status: CutPhoneManualScreenStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: CutPhoneManualScreenStatus.fail));
    }
  }
}
