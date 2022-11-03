import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:oasis/model/user/opti/user_mbti_main.dart';
import 'package:oasis/ui/theme.dart';

class TriangleChart extends CustomPainter {
  final UserMBTIMain mbtiMain;
  final String mbti;

  TriangleChart({required this.mbtiMain, required this.mbti});

  List<String> titleList = [
    "열정",
    "책임감",
    "결심/헌신",
  ];

  @override
  void paint(Canvas canvas, Size size) {
    _drawTriangle(
      canvas,
      size,
      size.width / 2,
    );

    _drawValueLine(canvas, size, (size.width / 2 + 15));

    _drawTextValue(canvas, size, size.width / 2);
  }

  double triangleHeight(double width) => sqrt(3) / 2 * width;

  _drawTriangle(Canvas canvas, Size size, shapeSize) {
    canvas.save();
    canvas.translate(0, size.height * 2 / 3);
    var height = triangleHeight(size.width);
    var startPt = Offset(
      size.width / 2,
      -height * 2 / 3,
    );

    var degrees = 30;
    var radians = degrees * (pi / 180);
    var xRatio = cos(radians) * (height * 2 / 3);
    var yRatio = sin(radians) * (height * 2 / 3);

    var secondPt = Offset(
      size.width / 2 - xRatio,
      yRatio,
    );
    var thirdPt = Offset(
      size.width - (size.width / 2 - xRatio),
      yRatio,
    );

    List<Offset> offset = [startPt, secondPt, thirdPt];

    var path = Path()
      ..moveTo(offset[0].dx, offset[0].dy)
      ..lineTo(offset[1].dx, offset[1].dy)
      ..lineTo(offset[2].dx, offset[2].dy)
      ..lineTo(offset[0].dx, offset[0].dy);

    Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.05)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(
        path,
        Paint()
          ..color = gray300
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke);
    canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill);

    var path01 = Path()
      ..moveTo(offset[0].dx, offset[0].dy)
      ..lineTo(offset[0].dx, 0);
    canvas.drawPath(
        path01,
        Paint()
          ..color = gray300
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke);

    var path02 = Path()
      ..moveTo(offset[1].dx, offset[1].dy)
      ..lineTo(offset[0].dx, 0);
    canvas.drawPath(
        path02,
        Paint()
          ..color = gray300
          ..style = PaintingStyle.stroke);

    var path03 = Path()
      ..moveTo(offset[2].dx, offset[2].dy)
      ..lineTo(offset[0].dx, 0);
    canvas.drawPath(
        path03,
        Paint()
          ..color = gray300
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke);
    canvas.restore();
  }

  _drawValueLine(Canvas canvas, Size size, shapeSize) {
    var topRatio = (mbtiMain.passionValue ?? 0) / 25;
    var leftRatio = (mbtiMain.responsibilityValue ?? 0) / 25;
    var rightRatio = (mbtiMain.dedicationValue ?? 0) / 25;

    canvas.save();
    canvas.translate(0, size.height * 2 / 3);

    var height = triangleHeight(size.width);
    var startPt = Offset(
      size.width / 2,
      -height * 2 / 3 * topRatio,
    );

    var degrees = 30;
    var radians = degrees * (pi / 180);
    var xRatio = cos(radians) * (height * 2 / 3);
    var yRatio = sin(radians) * (height * 2 / 3);

    var secondPt = Offset(
      size.width / 2 - xRatio * leftRatio,
      yRatio * leftRatio,
    );
    var thirdPt = Offset(
      size.width - (size.width / 2 - xRatio * rightRatio),
      yRatio * rightRatio,
    );

    List<Offset> offset = [
      Offset(startPt.dx, startPt.dy),
      Offset(secondPt.dx, secondPt.dy),
      Offset(thirdPt.dx, thirdPt.dy),
    ];

    List<int> value = [
      mbtiMain.passionValue ?? 0,
      mbtiMain.responsibilityValue ?? 0,
      mbtiMain.dedicationValue ?? 0,
    ];

    var path = Path()
      ..moveTo(startPt.dx, startPt.dy)
      ..lineTo(secondPt.dx, secondPt.dy)
      ..lineTo(thirdPt.dx, thirdPt.dy)
      ..lineTo(startPt.dx, startPt.dy);

    canvas.drawPath(
        path,
        Paint()
          ..color = mainMint.withOpacity(0.2)
          ..style = PaintingStyle.fill);

    canvas.drawPath(
        path,
        Paint()
          ..color = mainMint
          ..strokeWidth = 1
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke);

    for (var i = 0; i < offset.length; i++) {
      var textSpan = TextSpan(
          text: "${value[i]}",
          style: header03.copyWith(fontSize: 9, color: mainMint));

      var textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      var _offset = offset[i];
      if (i == 0) {
        _offset = Offset(_offset.dx - textPainter.width / 2, _offset.dy - 15);
      } else if (i == 1) {
        _offset = Offset(_offset.dx - textPainter.width / 2 - 10, _offset.dy);
      } else {
        _offset = Offset(_offset.dx - textPainter.width / 2 + 10, _offset.dy);
      }

      textPainter.paint(canvas, _offset);
    }
    canvas.restore();
  }

  _drawTextValue(Canvas canvas, Size size, shapeSize) {
    canvas.save();
    canvas.translate(0, size.height * 2 / 3);
    var height = triangleHeight(size.width * 1.15);
    var startPt = Offset(
      size.width / 2,
      -height * 2 / 3 - 6,
    );

    var degrees = 30;
    var radians = degrees * (pi / 180);
    var xRatio = cos(radians) * (height * 2 / 3);
    var yRatio = sin(radians) * (height * 2 / 3) + 10;

    var secondPt = Offset(
      size.width / 2 - xRatio,
      yRatio,
    );
    var thirdPt = Offset(
      size.width - (size.width / 2 - xRatio),
      yRatio,
    );

    List<Offset> offset = [startPt, secondPt, thirdPt];
    for (var i = 0; i < offset.length; i++) {
      var textSpan = TextSpan(
          text: titleList[i],
          style: header03.copyWith(fontSize: 9, color: mainMint));

      var textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(offset[i].dx - textPainter.width / 2,
              (offset[i].dy) - textPainter.height / 2 )  );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
