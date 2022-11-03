import 'package:flutter/cupertino.dart';
import 'package:oasis/ui/theme.dart';

class MBTIQuestionComponent extends StatelessWidget {
  final int idx;
  final String title;

  MBTIQuestionComponent({
    required this.idx,
    required this.title,
  });
  @override
  Widget build(BuildContext context) {
    var widthRatio = MediaQuery.of(context).size.width / 414;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: backgroundColor,
          ),
        ),
      ),
      width: double.infinity,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
            child: Text(
              "Q${idx + 1}",
              style: header01.copyWith(
                fontFamily: "Godo",
                fontSize: 40,
                color: mainMint.withOpacity(0.1),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15 , bottom: 14 * widthRatio, left: 45 * widthRatio, right: 16),
            child: Text(
              title,
              style: header02.copyWith(
                color: gray900,
                fontSize: 16 * widthRatio,
                fontWeight: FontWeight.w600,
                height: 1.3,
                fontFamily: "Godo",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
