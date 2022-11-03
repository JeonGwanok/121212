import 'package:flutter/material.dart';
import 'package:oasis/ui/theme.dart';

class RadioValueSet<T> extends StatefulWidget {
  final T? initialValue;
  final List<T> items;
  final List<String> labels;
  final Function(T) onTap;

  RadioValueSet({
    required this.initialValue,
    required this.labels,
    required this.items,
    required this.onTap,
  });
  @override
  _RadioValueSetState createState() => _RadioValueSetState();
}

class _RadioValueSetState extends State<RadioValueSet> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
        color: Colors.white,
        margin: EdgeInsets.only(right: 8),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: widget.initialValue != widget.items[idx]
                    ? Border.all(color: gray400)
                    : null,
                color: widget.initialValue == widget.items[idx]
                    ? mainMint
                    : Colors.white),
            width: 52,
            height: 52,
            alignment: Alignment.center,
            child: Text(
              widget.labels[idx],
              style: body02.copyWith(
                  color: widget.initialValue == widget.items[idx]
                      ? Colors.white
                      : gray400),
            )),
      ),
    );
  }
}
