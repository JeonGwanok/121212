import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oasis/model/opti/mbti.dart';
import 'package:oasis/ui/common/cache_image.dart';
import 'package:oasis/ui/common/custom_icon.dart';

import '../../../theme.dart';
import 'mbti_question_component.dart';

class MainMBTIComponent extends StatelessWidget {
  final int idx;
  final MBTIQuestion question;
  final MBTIExample? answer;
  final Function(MBTIExample) onClick;

  MainMBTIComponent({
    required this.answer,
    required this.question,
    required this.idx,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {    var widthRatio = MediaQuery.of(context).size.width / 414;
    return SingleChildScrollView(child: Container(
      child: Column(
        children: [
          AspectRatio(
              aspectRatio: 1,
              child: CacheImage(
                url: "http://139.150.75.56/${question.image ?? ""}",
                boxFit: BoxFit.cover,
              )),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: cardShadow,
            ),
            child: Column(
              children: [
                MBTIQuestionComponent(
                  idx: (question.numbering ?? 0) - 1,
                  title: question.question ?? "",
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      ...question.example
                          .map(
                            (e) => GestureDetector(
                              onTap: () {
                                onClick(e);
                              },
                              child: Container(
                                color: Colors.transparent,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 20,
                                      child: Text(
                                        "${e.numbering ?? ""}.",
                                        style: body06.copyWith(  fontSize: 14 * widthRatio,
                                          color: answer != null &&
                                                  answer!.numbering ==
                                                      e.numbering
                                              ? mainMint
                                              : gray900,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        e.text ?? "",
                                        style: body06.copyWith(
                                          fontSize: 14 * widthRatio,
                                          color: answer != null &&
                                                  answer!.numbering ==
                                                      e.numbering
                                              ? mainMint
                                              : gray900,
                                        ),
                                      ),
                                    ),
                                    // if (answer != null)
                                    // Container(
                                    //   margin: EdgeInsets.only(left: 16),
                                    //   child: CustomIcon(
                                    //     width: 20,
                                    //     height: 20,
                                    //     path: "icons/lineCheck",
                                    //     color: answer != null &&
                                    //             answer!.numbering == e.numbering
                                    //         ? mainMint
                                    //         : Colors.transparent,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),);
  }
}
