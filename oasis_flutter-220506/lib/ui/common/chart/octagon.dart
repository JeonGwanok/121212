import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:oasis/model/user/opti/user_mbti_main.dart';
import 'package:oasis/ui/theme.dart';

class OctagonChart extends CustomPainter {
  final UserMBTIMain mbtiMain;
  final String mbti;

  OctagonChart({required this.mbtiMain, required this.mbti});

  List<String> titleList = [
    "F",
    "S",
    "I",
    "J",
    "N",
    "P",
    "E",
    "T",
  ];

  @override
  void paint(Canvas canvas, Size size) {
    _drawOctagon(canvas, size, size.width / 2, showShadow: true);

    _drawOctagon(canvas, size, (size.width / 2) * (4 / 5));
    _drawOctagon(canvas, size, (size.width / 2) * (3 / 5));
    _drawOctagon(canvas, size, (size.width / 2) * (2 / 5));
    _drawOctagon(canvas, size, (size.width / 2) * (1 / 5));

    _drawTextValue(canvas, size, (size.width / 2 + 15));

    _drawValueLine(canvas, size, size.width / 2);
  }

  _drawOctagon(Canvas canvas, Size size, shapeSize, {bool showShadow = false}) {
    Paint paint = Paint()
      ..color = gray300
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    Path path = Path();
    var numberOfSides = 8;
    double xCenter = size.width / 2;
    double yCenter = size.height / 2;

    path.moveTo(
        xCenter + shapeSize * math.cos(0), yCenter + shapeSize * math.sin(0));

    for (var i = 1; i <= numberOfSides; i += 1) {
      path.lineTo(
          xCenter + shapeSize * math.cos(i * 2 * math.pi / numberOfSides),
          yCenter + shapeSize * math.sin(i * 2 * math.pi / numberOfSides));
    }

    Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.05)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);
    if (showShadow) {
      canvas.drawPath(path, shadowPaint);
    }

    canvas.drawPath(path, paint);
    canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill);
  }

  _drawValueLine(Canvas canvas, Size size, shapeSize) {
    List<int> valueList = [
      mbtiMain.sValue ?? 0,
      mbtiMain.iValue ?? 0,
      mbtiMain.jValue ?? 0,
      mbtiMain.nValue ?? 0,
      mbtiMain.pValue ?? 0,
      mbtiMain.eValue ?? 0,
      mbtiMain.tValue ?? 0,
      mbtiMain.fValue ?? 0,
    ];

    Paint paint = Paint()
      ..color = mainMint
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    Path path = Path();
    var numberOfSides = 8;
    double xCenter = size.width / 2;
    double yCenter = size.height / 2;

    path.moveTo(xCenter + (shapeSize * (valueList.last / 100)) * math.cos(0),
        yCenter + (valueList.last / 100) * math.sin(0));

    for (var i = 1; i <= numberOfSides; i += 1) {
      path.lineTo(
          xCenter +
              (shapeSize * (valueList[i - 1] / 100)) *
                  math.cos(i * 2 * math.pi / numberOfSides),
          yCenter +
              (shapeSize * (valueList[i - 1] / 100)) *
                  math.sin(i * 2 * math.pi / numberOfSides));
    }

    canvas.drawPath(path, paint);
    canvas.drawPath(
        path,
        Paint()
          ..color = mainMint.withOpacity(0.2)
          ..style = PaintingStyle.fill);

    List<bool> enableList = [
      mbti.contains("S"),
      mbti.contains("I"),
      mbti.contains("J"),
      mbti.contains("N"),
      mbti.contains("P"),
      mbti.contains("E"),
      mbti.contains("T"),
      mbti.contains("F"),
    ];

    var textShapeSize = shapeSize * 1.2;
    for (var i = 1; i <= numberOfSides; i++) {
      var textSpan = TextSpan(
          text: "${valueList[i - 1]}",
          style: header03.copyWith(
              fontSize: 9,
              color: enableList[i - 1] ? mainMint : Colors.transparent));

      var textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      var ratio = 2.0;
      var yRatio = 2.0;
      var xRatio = 1.0;

      if (valueList[i - 1] >= 90) {
        yRatio = 10;
        if (i == 6) {
          ratio = 50;
          yRatio = 5;
        }

        if (i == 1) {
          ratio = 2;
          yRatio = 10;
          xRatio = 5;
        }

        if (i == 3) {
          ratio = 2;
          xRatio = -5;
        }

        if (i == 2) {
          ratio = 2;
          yRatio = -10;
        }
      }
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(
              xCenter +
                  (textShapeSize * (valueList[i - 1] / 100)) *
                      math.cos(i * 2 * math.pi / numberOfSides) -
                  textPainter.width / 2 -
                  xRatio,
              yCenter +
                  (textShapeSize * (valueList[i - 1] / 100)) *
                      math.sin(i * 2 * math.pi / numberOfSides) -
                  textPainter.height / ratio +
                  yRatio));
    }
  }

  _drawTextValue(Canvas canvas, Size size, shapeSize) {
    var numberOfSides = 8;
    double xCenter = size.width / 2;
    double yCenter = size.height / 2;

    List<bool> enableList = [
      mbti.contains("F"),
      mbti.contains("S"),
      mbti.contains("I"),
      mbti.contains("J"),
      mbti.contains("N"),
      mbti.contains("P"),
      mbti.contains("E"),
      mbti.contains("T"),
    ];

    for (var i = 0; i < numberOfSides; i++) {
      var textSpan = TextSpan(
          text: titleList[i],
          style: header03.copyWith(color: enableList[i] ? mainMint : gray300));

      var textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(
              (xCenter +
                      shapeSize * math.cos(i * 2 * math.pi / numberOfSides)) -
                  textPainter.width / 2,
              (yCenter +
                      shapeSize * math.sin(i * 2 * math.pi / numberOfSides)) -
                  textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
