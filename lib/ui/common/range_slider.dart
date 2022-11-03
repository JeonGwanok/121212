import 'dart:math';

import 'package:flutter/material.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/theme.dart';

class DefaultRangeSlider extends StatefulWidget {
  final Function(double, double) onChange;
  final double initialStartValue;
  final double initialEndValue;
  final double max;
  final double min;
  final int divisions;
  final int labelDivision;
  final String unit;
  DefaultRangeSlider({
    required this.onChange,
    required this.initialStartValue,
    required this.initialEndValue,
    required this.max,
    required this.min,
    required this.divisions,
    required this.labelDivision,
    required this.unit,
  });
  @override
  State<StatefulWidget> createState() => _DefaultRangeSliderState();
}

class _DefaultRangeSliderState extends State<DefaultRangeSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                widget.onChange(
                    max(widget.initialStartValue - 1, widget.min),
                    min(widget.initialEndValue, widget.max));
              },
              child: Container(
                width: 20,
                height: 20,
                child: CustomIcon(
                  path: "icons/circle_minus",
                ),
              ),
            ),
            SizedBox(width: 12),
            Text(
              "${widget.initialStartValue.ceil()}",
              style: header02.copyWith(color: mainMint),
            ),
            Text("${widget.unit}~", style: header02),
            Text(
              "${widget.initialEndValue.ceil()}",
              style: header02.copyWith(color: mainMint),
            ),
            Text("${widget.unit}", style: header02),
            SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                widget.onChange(
                    max(widget.initialStartValue, widget.min),
                    min(widget.initialEndValue + 1, widget.max));
              },
              child: Container(
                width: 20,
                height: 20,
                child: CustomIcon(
                  path: "icons/circle_plus",
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: mainMint,
            inactiveTrackColor: gray300,
            trackHeight: 4.0,
            rangeThumbShape: RoundRangeSliderThumbShape(enabledThumbRadius: 12),
            activeTickMarkColor: Colors.transparent,
            inactiveTickMarkColor: Colors.transparent,
            thumbColor: mainMint,
            overlayShape: RoundSliderOverlayShape(overlayRadius: 1),
            valueIndicatorColor: Colors.transparent,
          ),
          child: RangeSlider(
            values: RangeValues(
              widget.initialStartValue,
              widget.initialEndValue,
            ),
            min: widget.min,
            max: widget.max,
            divisions: widget.divisions,
            onChanged: (value) {
              setState(
                () {
                  widget.onChange(value.start, value.end);
                },
              );
            },
          ),
        ),
        SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...List.generate(
                (widget.divisions / widget.labelDivision).ceil() + 1,
                (index) => Text(
                      "${(widget.min + (widget.labelDivision * index)).toStringAsFixed(0)}",
                      style: body01.copyWith(color: gray300),
                    )).toList()
          ],
        )
      ],
    );
  }
}