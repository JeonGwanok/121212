import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oasis/model/opti/tendencies.dart';
import 'package:oasis/ui/opti_test/mbti_test/component/mbti_question_component.dart';
import 'package:oasis/ui/theme.dart';

class TendencyTestComponent extends StatefulWidget {
  final List<Tendency> questions;
  final Map<int, Tendency> initialAnswers;
  final Function(Tendency, bool) onClick;

  TendencyTestComponent({
    required this.questions,
    required this.initialAnswers,
    required this.onClick,
  });

  @override
  _TendencyTestComponentState createState() => _TendencyTestComponentState();
}

class _TendencyTestComponentState extends State<TendencyTestComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: cardShadow),
        child: Column(
          children: [
            ...widget.questions.map((e) => _tile(e)).toList(),
          ],
        ),
    );
  }

  _tile(Tendency question) {
    return Container(
      child: Column(
        children: [
          MBTIQuestionComponent(
              idx: (question.numbering ?? 0) - 1,
              title: question.question ?? ""),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                ...[true, false].map((e) {
                  bool? onClicked =
                      widget.initialAnswers[question.numbering]?.answer != null
                          ? widget.initialAnswers[question.numbering]?.answer ==
                              e
                          : null;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        widget.onClick(question, e);
                      },
                      child: Container(
                        height: 44,
                        margin:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: onClicked != null
                              ? (onClicked ? mainMint : Colors.white)
                              : Colors.white,
                          border: Border.all(
                            color: onClicked != null
                                ? (onClicked ? mainMint : gray300)
                                : gray300,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          e ? "O" : "X",
                          style: body02.copyWith(
                            color: onClicked != null
                                ? (onClicked ? Colors.white : gray300)
                                : gray300,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
