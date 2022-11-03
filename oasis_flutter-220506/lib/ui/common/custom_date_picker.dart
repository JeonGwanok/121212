import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oasis/ui/theme.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initValue;
  final ValueChanged<DateTime> onDateChanged;

  CustomDatePicker({required this.onDateChanged, required this.initValue});

  @override
  State createState() => CustomDatePickerState();
}

class CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _selectedDate;
  late DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = _dateTime = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 300,
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              MaterialButton(
                child: Text(
                  "취소",style: header02.copyWith(color: gray400),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              MaterialButton(
                child: Text("완료",style: header02.copyWith(color: mainMint)),
                onPressed: () {
                  setState(() {
                    _selectedDate = _dateTime;
                  });
                  widget.onDateChanged(_selectedDate);
                },
              ),
            ],
          ),
          Expanded(
            child: CupertinoDatePicker(
                initialDateTime: _dateTime,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (date) {
                  _dateTime = date;
                }),
          ),
        ],
      ),
    );
  }
}
