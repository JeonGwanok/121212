import 'package:flutter/material.dart';

import '../theme.dart';

class DefaultIgnoreField extends StatefulWidget {
  final String? initialValue;
  final String hintMsg;
  final bool enable;
  final Function onTap;

  DefaultIgnoreField({
    this.initialValue,
    required this.hintMsg,
    required this.onTap,
    this.enable = true,
  });

  @override
  _DefaultIgnoreFieldState createState() => _DefaultIgnoreFieldState();
}

class _DefaultIgnoreFieldState extends State<DefaultIgnoreField> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        height: 52,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color:
              widget.enable ? Colors.white : Color.fromRGBO(243, 244, 246, 1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: gray300),
        ),
        child: Text(
          widget.initialValue ?? widget.hintMsg,
          style: body02.copyWith(
              color: widget.initialValue == null
                  ? (widget.enable ? gray400 : gray300)
                  : black),
        ),
      ),
    );
  }
}
