import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/theme.dart';

class PurchaseSuccessScreen extends StatefulWidget {
  @override
  _PurchaseSuccessScreenState createState() => _PurchaseSuccessScreenState();
}

class _PurchaseSuccessScreenState extends State<PurchaseSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    var ratio = MediaQuery.of(context).size.height / 896;
    return BaseScaffold(
      buttons: [
        BaseScaffoldDefaultButtonScheme(
            title: "홈으로",
            onTap: () {
              Navigator.pop(context);
            }),
      ],
      body: Container(
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            CustomIcon(
              width: double.infinity,
              height: double.infinity,
              path: "photos/couple_flower",
              type: "png",
              boxFit: BoxFit.cover,
            ),
            // Container(
            //   height: 212,
            //   decoration: BoxDecoration(
            //       gradient: LinearGradient(
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //         stops: [0.1, 1],
            //         colors: [
            //           Colors.transparent,
            //           Colors.black.withOpacity(0.4),
            //         ],
            //       )),
            // ),
            Container(width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top + 20,
                  ),
                  CustomIcon(
                    path: "photos/logo_white",
                    type: ".png",
                    width: 100,
                  ),
                  SizedBox(height: 56 * ratio),
                  Text(
                    '결제 완료',
                    style: body01.copyWith(
                      fontSize: 40,
                      fontFamily: "Godo",
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20 * ratio),
                  Text(
                    '당신의 성공적인 만남을 기원합니다.',
                    style: header10.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
