import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/matching/last_matching_history/component/last_matching_history_card.dart';
import 'package:oasis/ui/matching/last_matching_history/cubit/last_matching_history_state.dart';
import 'package:oasis/ui/matching/last_matching_history/last_matching_detail/last_matching_detail_screen.dart';
import 'package:oasis/ui/theme.dart';

import 'cubit/last_matching_history_cubit.dart';

class LastMatchingHistoryScreen extends StatefulWidget {
  LastMatchingHistoryScreen();
  @override
  _LastMatchingHistoryScreenState createState() =>
      _LastMatchingHistoryScreenState();
}

class _LastMatchingHistoryScreenState extends State<LastMatchingHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LastMatchingHistoryCubit(
        matchingRepository: context.read<MatchingRepository>(),
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: BlocListener<LastMatchingHistoryCubit, LastMatchingHistoryState>(
        listener: (context, state) {},
        child: BlocBuilder<LastMatchingHistoryCubit, LastMatchingHistoryState>(
          builder: (context, state) {
            return BaseScaffold(
              title: "",
              onBack: () {
                Navigator.pop(context);
              },
              onLoading: state.status == ScreenStatus.loading,
              backgroundColor: backgroundColor,
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white),
                            boxShadow: cardShadow),
                        child: Text(
                          '* 카드는 추천일로부터 14일간 조회할 수 있습니다.',
                          style: body01.copyWith(color: gray600),
                        ),
                      ),
                      SizedBox(height: 24),
                      ...state.matchings
                          .asMap()
                          .map(
                            (i, e) => MapEntry(
                              i,
                              LastMatchingCard(
                                item: e,
                                isFirst: i == 0,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LastMatchingDetailScreen(matching: e),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                          .values
                          .toList()
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
}
