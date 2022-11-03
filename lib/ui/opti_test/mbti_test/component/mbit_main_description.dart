import 'package:flutter/material.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/util/bold_generator.dart';

import '../../../theme.dart';

class MBITMainDescription extends StatelessWidget {
  final String title;
  final String description;

  MBITMainDescription({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    var ratio = MediaQuery.of(context).size.height / 896;
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 30 * ratio, horizontal: 16),
        child: Column(
          children: [
            Column(
              children: [
                BoldMsgGenerator.toRichText(
                    msg:
                        "OPTI\n*(Oasis psychological type Indicator)*\n오아시스 연애의 발견",
                    style: header03.copyWith(color: gray900),
                    boldFontSize: 16,
                    textAlign: TextAlign.center,
                    boldWeight: FontWeight.w400),
                SizedBox(height: 24 * ratio),
                Container(
                  width: 134 * ratio,
                  height: 166 * ratio,
                  child: CustomIcon(
                    path: "icons/certificate",
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  title,
                  style: header02,
                ),
              ],
            ),
            SizedBox(height: 8 * ratio),
            Container(width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: cardShadow,
              ),
              child: Text(
                description,
                textAlign: TextAlign.left,
                style: body01.copyWith(color: gray600,height: 1.4),
              ),
            ),
            SizedBox(height: 8 * ratio),
          ],
        ),
      ),
    );
  }
}
