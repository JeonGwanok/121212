import 'package:flutter/cupertino.dart';
import 'package:oasis/ui/common/default_field.dart';
import 'package:oasis/ui/common/object_text_default_frame.dart';

class SignUpRecommendId extends StatefulWidget {
  final String initialValue;
  final Function(String) onChange;

  SignUpRecommendId({
    required this.initialValue,
    required this.onChange,
  });
  @override
  _SignUpRecommendIdState createState() => _SignUpRecommendIdState();
}

class _SignUpRecommendIdState extends State<SignUpRecommendId> {
  @override
  Widget build(BuildContext context) {
    return  ObjectTextDefaultFrame(
      title: "추천인코드",
      body:  Row(
        children: [
          Expanded(
            child: DefaultField(
              initialValue: widget.initialValue,
              hintText: "추천인 코드를 입력해주세요.",
              onChange: widget.onChange,
            ),
          ),
        ],
      ),
    );
  }
}
