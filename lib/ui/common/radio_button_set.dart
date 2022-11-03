import 'package:flutter/material.dart';
import 'package:oasis/ui/theme.dart';

class RadioButtonSet<T> extends StatefulWidget {
  final T? initialValue;
  final List<T> items;
  final List<String> labels;
  final Function(T) onTap;

  RadioButtonSet({
    required this.initialValue,
    required this.labels,
    required this.items,
    required this.onTap,
  });
  @override
  _RadioButtonSetState createState() => _RadioButtonSetState();
}

class _RadioButtonSetState extends State<RadioButtonSet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          ...widget.items
              .asMap()
              .map((i, element) => MapEntry(i, _tile(i)))
              .values
              .toList()
        ],
      ),
    );
  }

  _tile(int idx) {
    return GestureDetector(
      onTap: () {
        widget.onTap(widget.items[idx]);
      },
      child: Container(
        color: Colors.transparent,
        height: 40,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.only(right: 10),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: gray400),
              ),
              width: 18,
              height: 18,
              alignment: Alignment.center,
              child: widget.initialValue == widget.items[idx] ? Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: mainMint,
                  borderRadius: BorderRadius.circular(100),
                ),
              ) : null,
              margin: EdgeInsets.only(right: 8),
            ),
            Text(
              widget.labels[idx],
              style: body02,
            )
          ],
        ),
      ),
    );
  }
}
