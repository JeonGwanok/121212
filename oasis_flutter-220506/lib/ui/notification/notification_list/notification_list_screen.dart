import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/model/common/notification.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/notification/notification_detail/notification_detail_screen.dart';
import 'package:oasis/ui/notification/notification_list/cubit/notification_list_cubit.dart';
import 'package:oasis/ui/notification/notification_list/cubit/notification_list_state.dart';
import 'package:oasis/ui/theme.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({Key? key}) : super(key: key);

  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => NotificationListCubit(
        commonRepository: context.read<CommonRepository>(),
      )..initialize(),
      child: BlocBuilder<NotificationListCubit, NotificationListState>(
        builder: (context, state) {
          return BaseScaffold(
            title: "알림",
            backgroundColor: backgroundColor,
            showAppbarUnderline: false,
            onBack: () {
              Navigator.pop(context);
            },
            body: Container(
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ...state.items.map((e) => _tile(e)).toList(),
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 15,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _tile(NotificationModel item) {
    return GestureDetector(onTap: (){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => NotificationDetailScreen(
                item: item,
              )));

    },child: Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.title ?? "",
            style: header03.copyWith(fontFamily: "Godo", color: gray600),
          ),
          Transform.rotate(
            angle: pi,
            child: CustomIcon(
              path: "icons/back",
              width: 25,
              height: 25,
            ),
          ),
        ],
      ),
    ),);
  }
}
