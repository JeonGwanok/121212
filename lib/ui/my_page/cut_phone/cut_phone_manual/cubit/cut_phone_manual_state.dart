import 'package:equatable/equatable.dart';
import 'package:oasis/model/user/cut_phone.dart';
import 'package:oasis/ui/sign/util/field_status.dart';

enum CutPhoneManualScreenStatus {
  initial,
  loaded,
  loading,
  fail,
  success,
  removeSuccess, // 하나만 해제 성공했을때
  selectCutsSuccess,
  registerCutsSuccess, // 여러개 등록 성공했을때
  registerRemoveSuccess, // 여러개 해제 성공했을때
}

class CutPhoneManualState extends Equatable {
  final CutPhoneManualScreenStatus status;
  final String name;
  final String phoneNumber;
  final PhoneFieldStatus phoneFieldStatus;
  final bool switchOff;

  final List<CutPhone> registered;
  final List<CutPhone> selected;

  CutPhoneManualState({
    this.status = CutPhoneManualScreenStatus.initial,
    this.name = "",
    this.phoneNumber = "",
    this.registered = const [],
    this.switchOff = false,
    this.selected = const [],
    this.phoneFieldStatus = PhoneFieldStatus.initial,
  });

  CutPhoneManualState copyWith({
    CutPhoneManualScreenStatus? status,
    String? name,
    String? phoneNumber,
    List<CutPhone>? registered,
    List<CutPhone>? selected,
    bool? switchOff,
    PhoneFieldStatus? phoneFieldStatus,
  }) {
    return CutPhoneManualState(
      status: status ?? this.status,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      switchOff: switchOff ?? this.switchOff,
      registered: registered ?? this.registered,
      selected: selected ?? this.selected,
      phoneFieldStatus: phoneFieldStatus ?? this.phoneFieldStatus,
    );
  }

  @override
  List<Object?> get props => [
        status,
        name,
        phoneNumber,
        registered,
        switchOff,
        selected,
        phoneFieldStatus,
      ];
}
