import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/default_dialog.dart';
import 'package:oasis/ui/purchase/purchase_success.dart';
import 'package:oasis/ui/purchase/purchase_type.dart';
import 'package:oasis/ui/theme.dart';
import 'package:oasis/ui/util/bold_generator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cubit/purchase_cubit.dart';
import 'cubit/purchase_state.dart';

class PurchaseScreen extends StatefulWidget {
  final BuildContext mainContext;
  final bool showOnlyMembership;
  final int depth;
  PurchaseScreen({
    required this.mainContext,
    this.showOnlyMembership = false,
    this.depth = 2,
  });
  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => PurchaseCubit(
        appBloc: widget.mainContext.read<AppBloc>(),
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: BlocListener<PurchaseCubit, PurchaseState>(
        listener: (context, state) async {
          if (state.status == ScreenStatus.fail) {
            DefaultDialog.show(
              context,
              title: "결제에 실패했습니다.",
              defaultButtonTitle: "확인",
            );
          }

          if (state.status == ScreenStatus.success) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PurchaseSuccessScreen(),
              ),
            );

            for (var i = 0; i < widget.depth; i++) {
              Navigator.pop(context);
            }
          }
        },
        listenWhen: (pre, cur) => pre.status != cur.status,
        child: BlocBuilder<PurchaseCubit, PurchaseState>(
          builder: (context, state) {
            return BaseScaffold(
              title: "",
              onLoading: state.status == ScreenStatus.loading,
              onBack: () {
                Navigator.pop(context);
              },
              backgroundColor: backgroundColor,
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                color: backgroundColor,
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      if (PurchaseType.values
                          .map((e) => e.enableDisplay(
                              state.user.customer?.membership,
                              Platform.isIOS,
                              widget.showOnlyMembership))
                          .where((element) => element)
                          .toList()
                          .isEmpty)
                        Container(
                          height: 150,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            '고객센터에 문의해주세요.',
                            style: header02.copyWith(color: gray300),
                          ),
                        ),
                      ...PurchaseType.values
                          .map((e) => _button(e, () {
                                if (e.id != null) {
                                  context.read<PurchaseCubit>().buy(e.id!);
                                }
                              }, state.user))
                          .toList(),
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
      ),
    );
  }

  Widget _button(PurchaseType type, Function onTap, UserProfile userProfile) {
    return type.enableDisplay(userProfile.customer?.membership, Platform.isIOS,
            widget.showOnlyMembership)
        ? GestureDetector(
            onTap: () {
              if (type.enablePurchase(Platform.isIOS)) {
                onTap();
              } else {
                DefaultDialog.show(
                  context,
                  title: "고객센터로 문의해주세요.",
                  defaultButtonTitle: "확인",
                  child: GestureDetector(
                    onTap: () {
                      launch('tel://1544-2857');
                    },
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "1544-2857",
                        style: body02.copyWith(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                  ),
                );
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 21),
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: cardShadow,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: type.color ?? Colors.transparent)),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        if (type.title != null)
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              child: BoldMsgGenerator.toRichText(
                                msg: type.title!,
                                boldWeight: FontWeight.bold,
                                boldColor: mainMint,
                                style: header10.copyWith(
                                  fontFamily: "Godo",
                                ),
                              ),
                            ),
                          ),
                        if (type.image != null)
                          Expanded(
                            child: Image.asset(
                              "assets/${type.image!}.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    width: 10,
                    alignment: Alignment.center,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${type.priceLabel ?? ""}${type.priceLabel != null ? "원" : ""} ",
                              style: header02.copyWith(
                                fontFamily: "Godo",
                                color: gray900,
                              ),
                            ),
                            Text(
                              "${type.priceLabel != null ? "(부가세포함)" : ""}",
                              style: caption02.copyWith(color: gray600),
                            )
                          ],
                        ),
                        if (!type.enablePurchase(Platform.isIOS))
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${type.enablePurchase(Platform.isIOS) ? "" : "전화로 문의해주세요."}",
                              style: body02.copyWith(
                                fontFamily: "Godo",
                                color: gray500,
                              ),
                            ),
                          ),
                        if ((type.descriptions ?? []).isNotEmpty)
                          Column(
                            children: [
                              SizedBox(height: 4),
                              ...type.descriptions!
                                  .map(
                                    (e) => Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(top: 8),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 9,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: gray100),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        e,
                                        style: header03.copyWith(
                                          color: Color.fromRGBO(75, 75, 75, 1),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
