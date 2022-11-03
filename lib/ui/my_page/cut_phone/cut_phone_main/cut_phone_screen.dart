import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/model/user/cut_phone.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/my_page/cut_phone/cut_phone_by_contact/cut_phone_by_contact_screen.dart';
import 'package:oasis/ui/my_page/cut_phone/cut_phone_main/cubit/cut_phone_main_state.dart';
import 'package:oasis/ui/my_page/cut_phone/cut_phone_manual/cut_phone_manual_screen.dart';
import 'package:oasis/ui/theme.dart';
import 'package:oasis/ui/util/bold_generator.dart';

import 'cubit/cut_phone_main_cubit.dart';

class CutPhoneMainScreen extends StatefulWidget {
  @override
  _CutPhoneMainScreenState createState() => _CutPhoneMainScreenState();
}

class _CutPhoneMainScreenState extends State<CutPhoneMainScreen> {
  @override
  Widget build(BuildContext context) {
    var ratio = MediaQuery.of(context).size.height / 896;
    return BlocProvider(
      create: (BuildContext context) => CutPhoneMainCubit(
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: BlocBuilder<CutPhoneMainCubit, CutPhoneMainState>(
        builder: (context, state) {
          return BaseScaffold(
            title: "지인 차단 및 만남 방지",
            showAppbarUnderline: false,
            backgroundColor: backgroundColor,
            onBack: () {
              Navigator.pop(context);
            },
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 50 * ratio),
                  CustomIcon(
                    path: "icons/block_friends",
                    width: 133.9 * ratio,
                    height: 165.9 * ratio,
                  ),
                  BoldMsgGenerator.toRichText(
                      msg: '*지인 리스트*를 *등록*하면\n등록된 지인과 회원님은 서로 *만남이 방지*됩니다.',
                      textAlign: TextAlign.center,
                      style: header02.copyWith(
                        color: gray900,
                        fontWeight: FontWeight.w400,
                      ),
                      boldWeight: FontWeight.bold),
                  SizedBox(height: 20 * ratio),
                  Column(
                    children: [
                      _button(
                        value: state.registered
                            .where((e) => e.kind == CutPhoneType.contract)
                            .toList()
                            .length,
                        title: "내 연락처에 있는 번호 차단하기",
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CutPhoneByContactScreen(),
                            ),
                          );

                          context.read<CutPhoneMainCubit>().initialize();
                        },
                      ),
                      _button(
                        value: state.registered
                            .where((e) => e.kind == CutPhoneType.direct)
                            .toList()
                            .length,
                        title: "번호 입력으로 차단하기",
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CutPhoneManualScreen(),
                            ),
                          );
                          context.read<CutPhoneMainCubit>().initialize();
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 15*ratio,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _button({
    required int value,
    required String title,
    required Function onTap,
  }) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: cardShadow,
        color: Colors.white,
      ),
      child: Column(
        children: [
          Column(
            children: [
              Container(
                height: 52,
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: header02.copyWith(color: gray900),
                ),
              ),
              Container(
                height: 52,
                alignment: Alignment.center,
                child: Text(
                  value == 0 ? "아직 차단된 지인이 없습니다." : "$value명 차단됨",
                  style: body01.copyWith(color: gray600),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              onTap();
            },
            child: Container(
              height: 52,
              decoration: BoxDecoration(color: mainMint),
              alignment: Alignment.center,
              child: Text(
                value == 0 ? '등록하기' : '수정하기',
                style: header02.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
