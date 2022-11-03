
import 'package:flutter/material.dart';
import 'package:oasis/enum/community/community.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/community/community_main/community_main_screen.dart';
import 'package:oasis/ui/theme.dart';

class MyCommunityListScreen extends StatelessWidget {
  final int? customerId;
  MyCommunityListScreen({required this.customerId});


  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "",
      backgroundColor: backgroundColor,
      onBack: () {
        Navigator.pop(context);
      },
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '내가 작성한 📃',
                style: header02.copyWith(fontFamily: "Godo", color: darkBlue),
              ),
              SizedBox(height: 32),
              _button(
                title: "코디",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommunityMainScreen(
                        type: CommunityType.stylist,
                          customerId: customerId,
                      ),
                    ),
                  );
                },
                iconPath: "icons/clothes",
              ),
              _button(
                title: "데이트",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommunityMainScreen(
                        type: CommunityType.date,
                        customerId: customerId,
                      ),
                    ),
                  );
                },
                iconPath: "icons/date",
              ),
              _button(
                title: "연애",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommunityMainScreen(
                        type: CommunityType.love,
                        customerId: customerId,
                      ),
                    ),
                  );
                },
                iconPath: "icons/couple",
              ),
              _button(
                title: "결혼",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommunityMainScreen(
                        type: CommunityType.marry,
                        customerId: customerId,
                      ),
                    ),
                  );
                },
                iconPath: "icons/ring",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button({
    required String title,
    required Function onTap,
    required String iconPath,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 52,
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: cardShadow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: mainMint),
        ),
        child: Row(children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: lightMint,
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIcon(
              path: iconPath,
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: header02.copyWith(fontFamily: "Godo", color: mainMint),
            ),
          )
        ]),
      ),
    );
  }
}
