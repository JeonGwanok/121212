import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/model/matching/ai_matching.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/matching/ai_matching_list/component/ai_matching_card.dart';
import 'package:oasis/ui/matching/ai_matching_list/cubit/ai_matching_list_state.dart';
import 'package:oasis/ui/theme.dart';
import 'package:oasis/ui/util/bold_generator.dart';

import 'cubit/ai_matching_list_cubit.dart';

class AiMatchingListScreen extends StatefulWidget {
  @override
  _AiMatchingListScreenState createState() => _AiMatchingListScreenState();
}

class _AiMatchingListScreenState extends State<AiMatchingListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AiMatchingListCubit(
        matchingRepository: context.read<MatchingRepository>(),
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: BlocBuilder<AiMatchingListCubit, AiMatchingListState>(
        builder: (context, state) {
          return BaseScaffold(
            title: "",
            appbarColor: backgroundColor,
            backgroundColor: backgroundColor,
            showAppbarUnderline: false,
            onBack: () {
              Navigator.pop(context);
            },
            body: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      alignment: Alignment.center,
                      width: 80,
                      height: 80,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: gray300),
                        boxShadow: cardShadow,
                        color: Colors.white,
                      ),
                      child: AutoSizeText(
                        'N명',
                        maxLines: 1,
                        minFontSize: 1,
                        style: header07.copyWith(color: mainMint),
                      ),
                    ),
                    SizedBox(height: 36),
                    BoldMsgGenerator.toRichText(
                      msg: "AI 매니저가 *현재 n명*까지 짝을 찾고 있습니다.",
                      style: header05.copyWith(
                          color: gray900, fontWeight: FontWeight.w400),
                      boldWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '※ 적합도가 90% 이상인 분만 매칭을 진행합니다.',
                      style: body01.copyWith(color: gray600),
                    ),
                    SizedBox(height: 28),
                    Column(
                      children: [
                        ...List.generate(
                          (state.aiMatchings.length / 2).ceil(),
                          (idx) => _tileRow(state.aiMatchings, idx),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 30,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _tileRow(List<AiMatching> items, int idx) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
              child: AiMatchingCard(
            aiMatching: items[idx * 2],
          )),
          SizedBox(width: 18),
          Expanded(
            child: ((idx * 2 + 1 < items.length))
                ? AiMatchingCard(
                    aiMatching: items[idx * 2 + 1],
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
