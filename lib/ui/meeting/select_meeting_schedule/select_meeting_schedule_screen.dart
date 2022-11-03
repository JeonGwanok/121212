import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/calendar/calendar.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/meeting/select_meeting_schedule/cubit/select_meeting_schedule_cubit.dart';
import 'package:oasis/ui/theme.dart';
import 'package:oasis/ui/util/bold_generator.dart';
import 'package:oasis/ui/util/date.dart';

import 'cubit/select_meeting_schedule_state.dart';

enum MeetingScheduleType { morning, five, seven }

extension MeetingScheduleTypeExtension on MeetingScheduleType {
  String get title {
    switch (this) {
      case MeetingScheduleType.morning:
        return "오전 11:00";
      case MeetingScheduleType.five:
        return "오후 05:00";
      case MeetingScheduleType.seven:
        return "오후 07:00";
    }
  }

  bool get enableWeekday {
    // 평일만 가능한 시간
    switch (this) {
      case MeetingScheduleType.morning:
      case MeetingScheduleType.five:
        return false;
      case MeetingScheduleType.seven:
        return true;
    }
  }

  DateTime get time {
    switch (this) {
      case MeetingScheduleType.morning:
        return DateTime(0, 0, 0, 11, 0);
      case MeetingScheduleType.five:
        return DateTime(0, 0, 0, 17, 0);
      case MeetingScheduleType.seven:
        return DateTime(0, 0, 0, 19, 0);
    }
  }
}

class SelectMeetingScheduleScreen extends StatefulWidget {
  final BuildContext mainContext;
  SelectMeetingScheduleScreen({required this.mainContext});
  @override
  _SelectMeetingScheduleScreenState createState() =>
      _SelectMeetingScheduleScreenState();
}

class _SelectMeetingScheduleScreenState
    extends State<SelectMeetingScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SelectMeetingScheduleCubit(
        commonRepository: context.read<CommonRepository>(),
        matchingRepository: context.read<MatchingRepository>(),
        appBloc: widget.mainContext.read<AppBloc>(),
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child:
          BlocListener<SelectMeetingScheduleCubit, SelectMeetingScheduleState>(
        listener: (context, state) {
          if (state.status == ScreenStatus.success) {
            Future.delayed(Duration(milliseconds: 100), () {
              Navigator.pop(context);
            });
          }

          if (state.status == ScreenStatus.fail) {
            DefaultDialog.show(
              context,
              defaultButtonTitle: "확인",
              title: "다시시도해주세요.",
            );
          }
        },
        listenWhen: (pre, cur) => pre.status != cur.status,
        child:
            BlocBuilder<SelectMeetingScheduleCubit, SelectMeetingScheduleState>(
          builder: (context, state) {
            return BaseScaffold(
              title: "",
              onBack: () {
                Navigator.pop(context);
              },
              onLoading: state.status == ScreenStatus.loading,
              backgroundColor: backgroundColor,
              buttons: (state.meeting?.schedule ?? []).isEmpty
                  ? [
                      BaseScaffoldDefaultButtonScheme(
                        title: "일정확정",
                        onTap: state.selectedDate.isNotEmpty
                            ? () {
                                DefaultDialog.show(
                                  context,
                                  onTap: () {
                                    context
                                        .read<SelectMeetingScheduleCubit>()
                                        .confirm();
                                  },
                                  title: "만남 일정은 변경이 불가합니다.\n일정을 확정하시겠습니까?",
                                );
                              }
                            : null,
                      ),
                    ]
                  : null,
              body: Container(
                child: (state.meeting?.schedule ?? []).isEmpty
                    ? SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                width: double.infinity,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: cardShadow,
                                ),
                                child: BoldMsgGenerator.toRichText(
                                    msg:
                                        "*평일 : 오후 7시\n공휴일, 토, 일요일 : 오전 11시, 오후 5시*\n시간은 3가지 중에서만 선택 가능합니다.\n세부적인 시간변경이 필요한 경우, 만남일 전날 임시번호가 발급\n되오니, 상대방과 협의하시길 바랍니다.",
                                    style: body01.copyWith(color: gray600),
                                    boldWeight: FontWeight.bold),
                              ),
                              if (state.selectedDate.isNotEmpty)
                                _selectedList(state.selectedDate, (date) {
                                  context
                                      .read<SelectMeetingScheduleCubit>()
                                      .deleteDate(date);
                                }),
                              SizedBox(height: 16),
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: cardShadow,
                                ),
                                height: 368,
                                child: Calendar(
                                  startDate:
                                      state.meeting?.meeting?.create_dt ??
                                          DateTime.now(),
                                  hollyDays: state.hollyDays,
                                  onSelect: (date) {
                                    context
                                        .read<SelectMeetingScheduleCubit>()
                                        .changeSelectDate(date);
                                  },
                                  selectedDate: state.selectedDateTime,
                                ),
                              ),
                              SizedBox(height: 16),
                              _selectTime(
                                onTap: (type) {
                                  context
                                      .read<SelectMeetingScheduleCubit>()
                                      .changeSelectTime(type);
                                },
                                selectedDates: state.selectedDate,
                                isWeekday: (state.selectedDateTime?.weekday ??
                                            0) <
                                        6 &&
                                    !state.hollyDays.contains(
                                      Date.clearDate(state.selectedDateTime),
                                    ),
                                selectedDate: state.selectedDateTime,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).padding.bottom + 30,
                              )
                            ],
                          ),
                        ),
                      )
                    : SingleChildScrollView(
              child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            _selectedList(
                                (state.meeting?.schedule ?? [])
                                    .map((e) => DateTime(
                                        e.date!.year,
                                        e.date!.month,
                                        e.date!.day,
                                        int.parse((e.time ?? "00:00")
                                            .split(":")
                                            .first),
                                        int.parse(
                                            (e.time ?? "00:00").split(":")[1])))
                                    .toList(),
                                null),
                            SizedBox(height: 16),
                            Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: cardShadow,
                              ),
                              height: 368,
                              child: Calendar(
                                startDate: state.meeting?.meeting?.create_dt ??
                                    DateTime.now(),
                                hollyDays: state.hollyDays,
                                onSelect: (date) {},
                              ),
                            ),
                          ],
                        ),
                      ),),
              ),
            );
          },
        ),
      ),
    );
  }

  _selectedList(
    List<DateTime> selectedDates,
    Function(DateTime)? onDelete,
  ) {
    selectedDates.sort((a,b) => b.compareTo(a));
    return Container(
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            onDelete == null ? "내가 선택한 일정" : '선택 일정',
            style: header02.copyWith(
              color: gray900,
            ),
          ),
          SizedBox(height: 5),
          ...selectedDates
              .map(
                (e) => Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 52,
                        color: Colors.white,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${DateFormat("yyyy년 MM월 dd일").format(e)} (${getWeekKorean(e.weekday)}) ${e.hour >= 12 ? "오후" : "오전"} ${DateFormat("hh시").format(e)}",
                          style: body06.copyWith(color: gray600),
                        ),
                      ),
                    ),
                    if (onDelete != null)
                      GestureDetector(
                        onTap: () {
                          onDelete(e);
                        },
                        child: Container(
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          width: 50,
                          height: 50,
                          child: Text(
                            '삭제',
                            style: body06.copyWith(color: mainMint),
                          ),
                        ),
                      )
                  ],
                ),
              )
              .toList()
        ],
      ),
    );
  }

  _selectTime({
    required bool isWeekday,
    required Function(MeetingScheduleType) onTap,
    required DateTime? selectedDate, // 날짜 선택 안되어있으면 비활성화
    required List<DateTime> selectedDates,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '시간 선택',
            style: header02.copyWith(color: gray900),
          ),
          SizedBox(height: 5),
          ...MeetingScheduleType.values.map(
            (e) {
              if ((isWeekday && !e.enableWeekday) ||
                  (!isWeekday && e.enableWeekday)) {
                return Container();
              } else {
                if (selectedDate == null) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    child: Text(
                      '먼저 날짜를 선택해주세요',
                      style: header04.copyWith(
                        color: gray300,
                      ),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      if (!selectedDates.contains(DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          e.time.hour,
                          00))) {
                        onTap(e);
                      }
                    },
                    child: Container(
                      height: 52,
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: Text(
                        e.title,
                        style: header04.copyWith(
                            color: selectedDates.contains(DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    e.time.hour,
                                    00))
                                ? gray300
                                : gray600),
                      ),
                    ),
                  );
                }
              }
            },
          ).toList()
        ],
      ),
    );
  }
}
