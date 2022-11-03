import 'package:contacts_service/contacts_service.dart';
import 'package:equatable/equatable.dart';
import 'package:oasis/model/user/cut_phone.dart';

enum CutPhoneByContactScreenStatus {
  initial,
  loaded,
  loading,
  fail,
  success,
  cutSuccess, // 하나만 해제 성공했을때의
  selectCutsSuccess, // 여러개 선택 등록 성공했을떄
  registerCutsSuccess, // 모두 등록 성공했을때
  registerRemoveSuccess, // 여러개 해제 성공했을때
}

class CutPhoneByContactState extends Equatable {
  final CutPhoneByContactScreenStatus status;
  final List<Contact> phones;
  final List<Contact> selected;
  final List<CutPhone> registeredNumber;
  final bool switchOff;
  CutPhoneByContactState({
    this.status = CutPhoneByContactScreenStatus.initial,
    this.phones = const [],
    this.registeredNumber = const [],
    this.selected = const [],
    this.switchOff = true,
  });

  CutPhoneByContactState copyWith({
    CutPhoneByContactScreenStatus? status,
    List<Contact>? phones,
    List<CutPhone>? registeredNumber,
    List<Contact>? selected,
    bool? switchOff,
  }) {
    return CutPhoneByContactState(
      status: status ?? this.status,
      phones: phones ?? this.phones,
      registeredNumber: registeredNumber ?? this.registeredNumber,
      selected: selected ?? this.selected,
      switchOff: switchOff ?? this.switchOff,
    );
  }

  @override
  List<Object?> get props => [
        status,
        phones,
        registeredNumber,
        selected,
        switchOff,
      ];
}
