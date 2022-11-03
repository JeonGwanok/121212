import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/model/common/notification.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/theme.dart';

import 'cubit/notification_detail_cubit.dart';
import 'cubit/notification_detail_state.dart';

class NotificationDetailScreen extends StatefulWidget {
  final NotificationModel item;
  NotificationDetailScreen({required this.item});
  @override
  _NotificationDetailScreenState createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => NotificationDetailCubit(
        item: widget.item,
        commonRepository: context.read<CommonRepository>(),
      )..initialize(),
      child: BlocBuilder<NotificationDetailCubit, NotificationDetailState>(
        builder: (context, state) {
          return BaseScaffold(
            backgroundColor: backgroundColor,
            showAppbarUnderline: false,
            title: "알림",
            onBack: () {
              Navigator.pop(context);
            },
            body: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: cardShadow,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.item.title ?? "",
                        style: header02.copyWith(color: gray900),
                      ),
                      SizedBox(height: 26),
                      Text(
                        widget.item.content ?? "",
                        textAlign: TextAlign.left,
                        style: body02.copyWith(color: gray600),
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
}
