import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/util/bold_generator.dart';

import '../../theme.dart';
import 'cubit/after_meeting_cubit.dart';
import 'cubit/after_metting_state.dart';

class AfterMeetingScreen extends StatefulWidget {
  final BuildContext mainContext;
  AfterMeetingScreen({required this.mainContext});
  @override
  _AfterMeetingScreenState createState() => _AfterMeetingScreenState();
}

class _AfterMeetingScreenState extends State<AfterMeetingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AfterMeetingCubit(
        matchingRepository: context.read<MatchingRepository>(),
        appBloc: widget.mainContext.read<AppBloc>(),
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: BlocListener<AfterMeetingCubit, AfterMeetingState>(
        listener: (context, state) {
          if (state.status == ScreenStatus.success) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<AfterMeetingCubit, AfterMeetingState>(
          builder: (context, state) {
            return BaseScaffold(
              title: "",
              backgroundColor: backgroundColor,
              onBack: () {
                Navigator.pop(context);
              },
              onLoading: state.status == ScreenStatus.loading,
              resizeToAvoidBottomInset: true,
              buttons: [
                BaseScaffoldDefaultButtonScheme(
                  title: "다음",
                  onTap: state.enableButton
                      ? () {
                          context.read<AfterMeetingCubit>().save();
                        }
                      : null,
                ),
              ],
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: cardShadow,
                        ),
                        child: BoldMsgGenerator.toRichText(
                          msg:
                              "만남 후 이야기 미제출시\n*24시간 이후* 상대방에 대해 *호감 없음*으로 처리되며,\n신규 매칭 진행이 늦어지게 됩니다.",
                          style: body01.copyWith(color: gray600),
                          boldWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      _frame(
                        idx: 0,
                        value: state.meetingQuestion,
                        onChange: (type) {
                          context
                              .read<AfterMeetingCubit>()
                              .changeValue(meetingQuestion: type);
                        },
                        title: '${state.partner}님과의 만남은 어떠셨나요?',
                      ),
                      _frame(
                        idx: 1,
                        value: state.profileQuestion,
                        onChange: (type) {
                          context
                              .read<AfterMeetingCubit>()
                              .changeValue(profileQuestion: type);
                        },
                        title: '${state.partner}님의 실제 정보와 프로필이 동일했나요?',
                      ),
                      _frame(
                        idx: 2,
                        value: state.dateQuestion,
                        onChange: (type) {
                          context
                              .read<AfterMeetingCubit>()
                              .changeValue(dateQuestion: type);
                        },
                        title: '만남 시간과 장소는 어떠셨나요?',
                      ),
                      _loveFrame(
                        title: "${state.partner}님에게 호감을 표현하시겠습니까?",
                        value: state.feelingQuestion,
                        onChange: (value) {
                          context
                              .read<AfterMeetingCubit>()
                              .changeValue(feelingQuestion: value);
                        },
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: cardShadow,
                        ),
                        child: BoldMsgGenerator.toRichText(
                          msg:
                              "※  호감을 보낸 후 양쪽이 O를 하면,\n      상태창이 연애 중으로 바뀌며, *매칭이 일시정지* 됩니다.\n      한쪽이라도 *X*를 할 경우 새로운 매칭이 진행됩니다.",
                          style: body01.copyWith(color: gray600),
                          boldWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      _contentFrame(
                        title: "${state.partner}님에 대한 한줄평",
                        description:
                            "상대방에 대한 평가 내용은 서비스 어디에도 노출되지 않으며,\n오아시스 서비스 개선을 위한 용도로만 사용됩니다.",
                        value: state.review,
                        onChange: (text) {
                          context
                              .read<AfterMeetingCubit>()
                              .changeValue(review: text);
                        },
                      ),
                      _contentFrame(
                        title: "오아시스에 바라는 점",
                        value: state.oasisWant,
                        onChange: (text) {
                          context
                              .read<AfterMeetingCubit>()
                              .changeValue(oasisWant: text);
                        },
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _frame({
    required String title,
    required int idx,
    required AfterMeetingSelectType? value,
    required Function(AfterMeetingSelectType) onChange,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        boxShadow: cardShadow,
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 5, right: 5, top: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 3),
                  child: Text(
                    "Q",
                    style: header06.copyWith(color: lightMint),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: header05.copyWith(color: gray900),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 14, top: 5),
            width: double.infinity,
            height: 1,
            color: gray100,
          ),
          Container(
            padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: Row(
              children: [
                ...AfterMeetingSelectType.values
                    .asMap()
                    .map(
                      (i, e) => MapEntry(
                        i,
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              onChange(e);
                            },
                            child: Container(
                              height: 52,
                              margin: EdgeInsets.only(left: i == 0 ? 0 : 6),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color:
                                    value == e ? mainMint : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      value == e ? Colors.transparent : gray300,
                                ),
                              ),
                              child: Text(
                                idx == 1 ? e.title2 : e.title,
                                textAlign: TextAlign.center,
                                style: header03.copyWith(
                                  color: value == e ? Colors.white : gray400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _loveFrame({
    required String title,
    required bool? value,
    required Function(bool) onChange,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        boxShadow: cardShadow,
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 5, right: 5, top: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Text(
                    "Q",
                    style: header06.copyWith(color: lightMint),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  title,
                  style: header05.copyWith(color: gray900),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 14),
            width: double.infinity,
            height: 1,
            color: gray100,
          ),
          Container(
            padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: Row(
              children: [
                ...[false, true]
                    .asMap()
                    .map(
                      (i, e) => MapEntry(
                        i,
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              onChange(e);
                            },
                            child: Container(
                              height: 52,
                              margin: EdgeInsets.only(left: i == 0 ? 0 : 6),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: value == e
                                      ? mainMint
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: value == e
                                          ? Colors.transparent
                                          : gray300)),
                              child: Text(
                                e ? "O" : "X",
                                textAlign: TextAlign.center,
                                style: header03.copyWith(
                                    color: value == e ? Colors.white : gray400),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _contentFrame({
    required String title,
    String? description,
    required String value,
    required Function(String) onChange,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        boxShadow: cardShadow,
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 14,
            ),
            child: Text(
              title,
              style: header05.copyWith(color: gray900),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 14),
            width: double.infinity,
            height: 1,
            color: gray100,
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (description != null)
                  Text(
                    description,
                    style: body01.copyWith(color: gray600),
                  ),
                if (description != null) SizedBox(height: 16),
                DefaultField(
                  hintText: "최소 10자~최대200자",
                  onChange: (text) {
                    onChange(text);
                  },
                  textLimit: 200,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
