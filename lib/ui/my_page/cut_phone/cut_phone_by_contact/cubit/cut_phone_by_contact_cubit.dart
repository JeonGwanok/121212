import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/api_client/api_client.dart';
import 'package:oasis/model/user/cut_phone.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:permission_handler/permission_handler.dart';

import 'cut_phone_by_contact_state.dart';

class CutPhoneByContactCubit extends Cubit<CutPhoneByContactState> {
  final UserRepository userRepository;
  CutPhoneByContactCubit({
    required this.userRepository,
  }) : super(CutPhoneByContactState());

  initialize() async {
    try {
      emit(state.copyWith(status: CutPhoneByContactScreenStatus.loading));

      final PermissionStatus permissionStatus = Platform.isIOS ? PermissionStatus.granted : await _getPermission();
      final contacts = permissionStatus == PermissionStatus.granted ? await ContactsService.getContacts() : null;
      final user = await userRepository.getUser();
      final registered =
          await userRepository.getCutPhones(customerId: "${user.customer?.id}");
      emit(state.copyWith(
          status: CutPhoneByContactScreenStatus.loaded,
          phones: contacts != null ? contacts.toList() : [],
          selected: [],
          registeredNumber: registered
              .where((e) => e.kind == CutPhoneType.contract)
              .toList()));
    } on ApiClientException {
      emit(state.copyWith(status: CutPhoneByContactScreenStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: CutPhoneByContactScreenStatus.fail));
    }
  }

  //Check contacts permission
  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
      await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.granted;
    } else {
      var _permission = await Permission.contacts.request();
      return _permission;
    }
  }

  select(Contact phone) {
    var items = [...state.selected];
    items.add(phone);
    emit(state.copyWith(selected: items));
  }

  unselect(Contact phone) {
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
          status: CutPhoneByContactScreenStatus.loading, switchOff: false));
      final user = await userRepository.getUser();

      await userRepository.uploadCutPhones(
          customerId: "${user.customer?.id}",
          items: state.selected.map((e) {
            var phoneN = (e.phones ?? []).isNotEmpty
                ? e.phones!.first.value!
                    .replaceAll("-", "")
                    .replaceAll(" ", "")
                    .replaceAll("(", "")
                    .replaceAll(")", "")
                : "";
            return CutPhone(name: e.displayName ?? "", phoneNumber: phoneN.replaceAll("-", "").replaceAll("+", ""));
          }).toList(),
          kind: CutPhoneType.contract);
      emit(state.copyWith(
          status: CutPhoneByContactScreenStatus.selectCutsSuccess));
      initialize();
    } on ApiClientException {
      emit(state.copyWith(
          status: CutPhoneByContactScreenStatus.fail, switchOff: true));
    } catch (err) {
      emit(state.copyWith(
          status: CutPhoneByContactScreenStatus.fail, switchOff: true));
    }
  }

  remove(CutPhone phone) async {
    try {
      emit(state.copyWith(status: CutPhoneByContactScreenStatus.loading));
      final user = await userRepository.getUser();
      await userRepository
          .deleteCutPhones(customerId: "${user.customer?.id}", items: [phone]);
      emit(state.copyWith(status: CutPhoneByContactScreenStatus.cutSuccess));
      initialize();
    } on ApiClientException {
      emit(state.copyWith(status: CutPhoneByContactScreenStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: CutPhoneByContactScreenStatus.fail));
    }
  }

  // 전체 차단
  allCut() async {
    try {
      emit(state.copyWith(
          status: CutPhoneByContactScreenStatus.loading, switchOff: false));
      final user = await userRepository.getUser();
      await userRepository.uploadCutPhones(
          customerId: "${user.customer?.id}",
          items: state.phones.map((e) {
            var phoneN = (e.phones ?? []).isNotEmpty
                ? e.phones!.first.value!
                    .replaceAll("-", "")
                    .replaceAll(" ", "")
                    .replaceAll("(", "")
                    .replaceAll(")", "")
                : "";
            return CutPhone(name: e.displayName, phoneNumber: phoneN.replaceAll("-", "").replaceAll("+", ""));
          }).toList(),
          kind: CutPhoneType.contract);
      final registered =
      await userRepository.getCutPhones(customerId: "${user.customer?.id}");
      emit(state.copyWith(
          status: CutPhoneByContactScreenStatus.registerCutsSuccess,registeredNumber: registered,));
      initialize();
    } on ApiClientException {
      emit(state.copyWith(status: CutPhoneByContactScreenStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: CutPhoneByContactScreenStatus.fail));
    }
  }

  // 전체 차단 해제
  allRemove() async {
    try {
      emit(state.copyWith(
          status: CutPhoneByContactScreenStatus.loading, switchOff: true));
      final user = await userRepository.getUser();
      await userRepository.deleteCutPhones(
        customerId: "${user.customer?.id}",
        items: state.registeredNumber
            .where(
              (e) => e.kind == CutPhoneType.contract,
            )
            .toList(),
      );
      emit(state.copyWith(
          status: CutPhoneByContactScreenStatus.registerRemoveSuccess));
      initialize();
    } on ApiClientException {
      emit(state.copyWith(status: CutPhoneByContactScreenStatus.fail));
    } catch (err) {
      emit(state.copyWith(status: CutPhoneByContactScreenStatus.fail));
    }
  }
}
