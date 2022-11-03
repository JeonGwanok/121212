import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/purchase/purchase_type.dart';
import 'package:oasis/ui/theme.dart';

import 'cubit/purchase_history_cubit.dart';
import 'cubit/purchase_history_state.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({Key? key}) : super(key: key);

  @override
  _PurchaseHistoryScreenState createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    var widthRatio = MediaQuery.of(context).size.width / 414;
    return BlocProvider(
      create: (BuildContext context) => PurchaseHistoryCubit(
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: BlocBuilder<PurchaseHistoryCubit, PurchaseHistoryState>(
        builder: (context, state) {
          PurchaseType? purchaseType;

          switch (state.purchaseHistory.membership) {
            case "basic":
              purchaseType = PurchaseType.basic;
              break;
            case "gold":
              purchaseType = PurchaseType.gold;
              break;
            case "diamond":
              purchaseType = PurchaseType.diamond;
              break;
            case "blue":
              purchaseType = PurchaseType.blue;
              break;
          }

          return BaseScaffold(
            title: "",
            onLoading: state.status == ScreenStatus.loading,
            appbarColor: Colors.white,
            backgroundColor: backgroundColor,
            onBack: () {
              Navigator.pop(context);
            },
            body: SingleChildScrollView(
              child: Column(
                children: [
                  if (purchaseType != null)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      decoration: BoxDecoration(color: Colors.white),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 160 * widthRatio,
                            height: 160 * widthRatio,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: gray200)),
                            child: CustomIcon(
                              path: "${purchaseType.keyImage}",
                              type: ".png",
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomIcon(
                                  path: purchaseType.badgeImage!,
                                  type: ".png",
                                  width: double.infinity,
                                ),
                                SizedBox(height: 20),
                                ...purchaseType.descriptions!
                                    .map(
                                      (e) => Container(
                                        width: double.infinity,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 4),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 9),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(color: gray100),
                                        ),
                                        child: Text(
                                          e,
                                          style: body01.copyWith(
                                              color: gray700,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                    .toList()
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          )
                        ],
                      ),
                    ),
                  if (state.purchaseHistory.payment.isEmpty)
                    Container(
                      height: 100,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        '구매내역이 없습니다.',
                        style: header02.copyWith(color: gray300),
                      ),
                    ),
                  if (state.purchaseHistory.payment.isNotEmpty)
                    ...state.purchaseHistory.payment.map(
                      (e) => Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding:
                            EdgeInsets.symmetric(vertical: 18, horizontal: 29),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: cardShadow,
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Text(
                              e.kindDisplay ?? "",
                              style: header05.copyWith(
                                  color: gray900, fontFamily: "Godo"),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              height: 30,
                              color: gray200,
                              width: 1,
                            ),
                            Text(
                              DateFormat("yyyy.MM.dd").format(e.createdAt!),
                              style: body06.copyWith(color: gray900),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 15,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
