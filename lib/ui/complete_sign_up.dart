import 'package:flutter/material.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/theme.dart';

class CompleteSignUpScreen extends StatefulWidget {
  final Function onPrev;
  final Function onNext;

  CompleteSignUpScreen({
    required this.onPrev,
    required this.onNext,
  });

  @override
  _CompleteSignUpScreenState createState() => _CompleteSignUpScreenState();
}

class _CompleteSignUpScreenState extends State<CompleteSignUpScreen> {
  @override
  Widget build(BuildContext context) {
    var ratio = MediaQuery.of(context).size.height / 896;
    return BaseScaffold(
      buttons: [
        BaseScaffoldDefaultButtonScheme(
            title: "가입 완료",
            onTap: () {
              widget.onNext();
            }),
      ],
      body: Container(
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            CustomIcon(
              width: double.infinity,
              height: double.infinity,
              path: "photos/wedding_photo",
              type: "png",
              boxFit: BoxFit.cover,
            ),
            Container(
              height: 212,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 1],
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                ],
              )),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome',
                    style: header01.copyWith(
                      fontSize: 60,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 56 * ratio),
                  Text(
                    '오아시스 회원가입이 완료되었습니다.',
                    style: header02.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '오아시스에서\n진정한 이상형을 만나실 수 있도록\n최선의 노력을 다하겠습니다.',
                    style: body01.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 72 * ratio),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
