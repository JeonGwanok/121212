import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/model/common/frequency_question.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/my_page/frequently_question/cubit/frequently_question_state.dart';
import 'package:oasis/ui/theme.dart';

import 'cubit/frequently_question_cubit.dart';

class FrequentlyQuestionScreen extends StatefulWidget {
  @override
  _FrequentlyQuestionScreenState createState() =>
      _FrequentlyQuestionScreenState();
}

class _FrequentlyQuestionScreenState extends State<FrequentlyQuestionScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => FrequentlyQuestionCubit(
        commonRepository: context.read<CommonRepository>(),
      )..initialize(),
      child: BlocBuilder<FrequentlyQuestionCubit, FrequentlyQuestionState>(
        builder: (context, state) {
          return BaseScaffold(
            title: "자주 묻는 질문",
            showAppbarUnderline: false,
            backgroundColor: backgroundColor,
            onBack: () {
              Navigator.pop(context);
            },
            body: Container(
              width: double.infinity,
              height: double.infinity,
              child: RawScrollbar(
                thumbColor: gray300,
                radius: Radius.circular(20),
                thickness: 5,
                crossAxisMargin: 3,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        if (state.questions.isEmpty)
                          Container(
                            height: 150,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              '자주 묻는 질문이 없습니다.',
                              style: header02.copyWith(color: gray300),
                            ),
                          ),
                        ...state.questions
                            .asMap()
                            .map(
                              (i, e) => MapEntry(
                                i,
                                _tile(
                                  e,
                                  () {
                                    context
                                        .read<FrequentlyQuestionCubit>()
                                        .changeOpenStatus(i);
                                  },
                                ),
                              ),
                            )
                            .values
                            .toList(),
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 30,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _tile(FrequentlyQuestion question, Function onTap) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: cardShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              onTap();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Text(
                      "Q",
                      style: header06.copyWith(color: lightMint),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        question.qestion ?? "--",
                        style: header04.copyWith(color: gray900, fontFamily: "Godo", height: 1.5),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 11),
                    child: Transform.rotate(
                      angle: question.uiShowAnswer ? -pi : 0,
                      child: CustomIcon(
                        path: "icons/downArrow",
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (question.uiShowAnswer)
            Container(
              height: 1,
              width: double.infinity,
              color: gray100,
            ),
          if (question.uiShowAnswer)
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              constraints: BoxConstraints(minHeight: 52),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Text(
                      "A",
                      style: header06.copyWith(color: lightMint),
                    ),
                  ),
                  SizedBox(width: 16),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(top: 16, bottom: 16, right: 16),
                      child: Text(
                        question.answer ?? "--",
                        style: body03.copyWith(color: gray900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
