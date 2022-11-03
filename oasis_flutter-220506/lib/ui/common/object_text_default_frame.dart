import 'package:flutter/cupertino.dart';

import '../theme.dart';

class ObjectTextDefaultFrame extends StatefulWidget {
  final String title;
  final String? description;
  final Widget body;
  ObjectTextDefaultFrame({
    this.title = "",
    this.description,
    required this.body,
  });

  @override
  _ObjectTextDefaultFrameState createState() => _ObjectTextDefaultFrameState();
}

class _ObjectTextDefaultFrameState extends State<ObjectTextDefaultFrame> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: header03,
        ),
        SizedBox(height: 8),
        widget.body,
        if (widget.description != null)
         Container(margin: EdgeInsets.only(top: 5,left: 10),child: Text(
            widget.description!,
            style: caption02.copyWith(color: gray400),
          ),)
      ],
    );
  }
}
