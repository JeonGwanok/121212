import 'package:flutter/material.dart';
import 'package:oasis/model/opti/mbti.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/opti_test/mbti_test/component/mbti_question_component.dart';
import 'package:oasis/ui/theme.dart';

class PrevMBTIComponent extends StatefulWidget {
  final int idx;
  final MBTIQuestion question;
  final MBTIExample? answer;
  final Function(MBTIExample) onClick;

  PrevMBTIComponent({
    required this.answer,
    required this.question,
    required this.idx,
    required this.onClick,
  });

  @override
  State<PrevMBTIComponent> createState() => _PrevMBTIComponentState();
}

class _PrevMBTIComponentState extends State<PrevMBTIComponent> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = Container();

    if (widget.idx == 0) {
      screen = _question01();
    } else if (widget.idx == 1) {
      screen = _question02();
    } else if (widget.idx == 2) {
      screen = _question03();
    }

    return Container(
      height: double.infinity,
      child: SingleChildScrollView(
        controller: scrollController,
        child: screen,
      ),
    );
  }

  _question01() {
    return Container(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: CustomIcon(
              path: "photos/prev1",
              type: "png",
            ),
          ),
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
                  idx: widget.idx,
                  title: widget.question.question ?? "",
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    children: [
                      ...widget.question.example.map((e) {
                        var title = "";
                        if (e.text == "1") {
                          title = "매우\n덜 민감";
                        } else if (e.text == "2") {
                          title = "덜 민감";
                        } else if (e.text == "3") {
                          title = "보통";
                        } else if (e.text == "4") {
                          title = "민감";
                        } else if (e.text == "5") {
                          title = "매우\n민감";
                        }
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              widget.onClick(e);
                              scrollController.jumpTo(0);
                            },
                            child: Container(
                              height: 52,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 12),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: widget.answer != null &&
                                          widget.answer!.numbering ==
                                              e.numbering
                                      ? mainMint
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: widget.answer != null &&
                                          widget.answer!.numbering ==
                                              e.numbering
                                      ? null
                                      : Border.all(color: gray300)),
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                                style: body01.copyWith(
                                    color: widget.answer != null &&
                                            widget.answer!.numbering ==
                                                e.numbering
                                        ? Colors.white
                                        : gray400),
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
          ),
        ],
      ),
    );
  }

  _question02() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: cardShadow,
        ),
        child: Column(
          children: [
            MBTIQuestionComponent(
              idx: widget.idx,
              title: widget.question.question ?? "",
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _question02Button("photos/prev2_01", 0,
                                widget.question.example[0]),
                            SizedBox(height: 10),
                            _question02Button("photos/prev2_03", 2,
                                widget.question.example[2]),
                            SizedBox(height: 10),
                            _question02Button("photos/prev2_05", 4,
                                widget.question.example[4])
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            _question02Button("photos/prev2_02", 1,
                                widget.question.example[1]),
                            SizedBox(height: 10),
                            _question02Button("photos/prev2_04", 3,
                                widget.question.example[3])
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _question02Button(String path, int idx, MBTIExample answer) {
    return GestureDetector(
      onTap: () {
        widget.onClick(answer);
        scrollController.jumpTo(0);
      },
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: this.widget.answer != null &&
                    this.widget.answer!.numbering == answer.numbering
                ? mainMint
                : null,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: this.widget.answer != null &&
                      this.widget.answer!.numbering == answer.numbering
                  ? Colors.transparent
                  : gray300,
            ),
          ),
          child: Text(
            "${idx + 1}",
            textAlign: TextAlign.center,
            style: header02.copyWith(
                color: this.widget.answer != null &&
                        this.widget.answer!.numbering == answer.numbering
                    ? Colors.white
                    : gray300,
                fontFamily: "Godo"),
          ),
        ),
        SizedBox(height: 6),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: this.widget.answer != null &&
                      this.widget.answer!.numbering == answer.numbering
                  ? null
                  : Border.all(color: gray300)),
          child: AspectRatio(
            aspectRatio: 1,
            child: CustomIcon(
              path: path,
              type: "png",
            ),
          ),
        )
      ]),
    );
  }

  _question03() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: cardShadow,
        ),
        child: Column(
          children: [
            MBTIQuestionComponent(
              idx: widget.idx,
              title: widget.question.question ?? "",
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 43, vertical: 16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      widget
                                          .onClick(widget.question.example[0]);
                                      scrollController.jumpTo(0);
                                    },
                                    child: Container(
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          border: widget.answer != null &&
                                                  widget.answer!.numbering ==
                                                      widget.question.example[0]
                                                          .numbering
                                              ? null
                                              : Border.all(color: gray300),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: CustomIcon(
                                          path: "photos/prev03_01",
                                          type: "png",
                                          boxFit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: () {
                                      widget
                                          .onClick(widget.question.example[1]);
                                      scrollController.jumpTo(0);
                                    },
                                    child: Container(
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: widget.answer != null &&
                                                widget.answer!.numbering ==
                                                    widget.question.example[1]
                                                        .numbering
                                            ? null
                                            : Border.all(color: gray300),
                                      ),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: CustomIcon(
                                          path: "photos/prev03_02",
                                          type: "png",
                                          boxFit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
