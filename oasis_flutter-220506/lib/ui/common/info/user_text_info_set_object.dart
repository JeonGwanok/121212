import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oasis/model/user/user_profile.dart';
import 'package:oasis/ui/common/info_field.dart';

class UserTextInfoSetObject extends StatefulWidget {
  final UserProfile user;
  const UserTextInfoSetObject({
    required this.user,
  });

  @override
  _UserInfoSetState createState() => _UserInfoSetState();
}

class _UserInfoSetState extends State<UserTextInfoSetObject> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _objectMargin(
            InfoField(
              isHorizontal: false,
              title: "자기소개(매력-장점-인사말)",
              value: widget.user.profile?.myIntroduce ?? "--",
            ),
          ),
          _objectMargin(
            InfoField(
              isHorizontal: false,
              title: "나의 업무 소개",
              value: widget.user.profile?.myWorkIntro ?? "--",
            ),
          ),
          _objectMargin(
            InfoField(
              isHorizontal: false,
              title: "나의 가족 소개",
              value: widget.user.profile?.myFamilyIntro ?? "--",
            ),
          ),
          _objectMargin(
            InfoField(
              isHorizontal: false,
              title: "나의 힐링법",
              value: widget.user.profile?.myHealing ?? "--",
            ),
          ),
          _objectMargin(
            InfoField(
              isHorizontal: false,
              title: "미래 배우자에게 한마디",
              value: widget.user.profile?.myVoiceToLover ?? "--",
            ),
          ),
        ],
      ),
    );
  }

  _objectMargin(Widget child) {
    return Container(margin: EdgeInsets.symmetric(vertical: 4), child: child);
  }
}
