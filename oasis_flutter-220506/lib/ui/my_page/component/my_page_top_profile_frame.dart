import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oasis/enum/profile/job_type.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/ui/common/cache_image.dart';
import 'package:oasis/ui/common/default_small_button.dart';

import '../../theme.dart';

class MyPageTopProfileFrame extends StatefulWidget {
  final UserProfile user;
  final String buttonName;
  final Function onTap;
  MyPageTopProfileFrame({
    required this.user,
    required this.buttonName,
    required this.onTap,
  });

  @override
  _MyPageTopProfileFrameState createState() => _MyPageTopProfileFrameState();
}

class _MyPageTopProfileFrameState extends State<MyPageTopProfileFrame> {
  @override
  Widget build(BuildContext context) {
    var membership = "--";

    if (widget.user.customer != null) {
      switch (widget.user.customer?.membership) {
        case "basic":
          if (widget.user.customer?.is_event ?? false) {
            membership = "무료 만남권 1회 이벤트";
          } else {
            membership = "일반 회원";
          }

          break;
        case "gold":
          membership = "골드 회원";
          break;
        case "diamond":
          membership = "다이아몬드 회원";
          break;
        default:
          membership = "회원권 없음";
          break;
      }
    }

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: 20,
      ),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: gray50,
            ),
            child: CacheImage(
              url: widget.user.image?.representative1 ?? "",
              boxFit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  membership,
                  style: header02.copyWith(fontFamily: "Godo", color: gray600),
                ),
                Container(
                  padding: EdgeInsets.only(top: 8, bottom: 12),
                  child: Text(
                    '${widget.user.customer?.nickName != null ? widget.user.customer?.nickName : "--"} / ${widget.user.customer?.name != null ? widget.user.customer?.name : "--"} / ${widget.user.customer?.username != null ? (widget.user.customer?.username ?? "").replaceAllMapped(RegExp(r'(\d{3})(\d{4})(\d+)'), (m) => "${m[1]}-${m[2]}-${m[3]}") : "--"}',
                    style: body01.copyWith(color: gray600),
                  ),
                ),
                Container(
                  height: 40,
                  child: DefaultSmallButton(
                    title: widget.buttonName,
                    reverse: true,
                    showShadow: true,
                    onTap: () {
                      widget.onTap();
                    },
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
