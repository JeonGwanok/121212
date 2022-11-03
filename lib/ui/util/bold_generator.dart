
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BoldMsgGenerator {
  static AutoSizeText toRichText({
    required String msg,
    required TextStyle style,
    required FontWeight boldWeight,
    double? boldFontSize,
    TextAlign? textAlign,
    int? maxLine,
    bool showUnderline = false,
    Color? boldColor,
    Function? onTap,
  }) {
    List<InlineSpan> texts = [];
    var _msg = _GuideMessageGenerator.from(msg);

    for (var i = 0; i < _msg.length; i++) {
      texts.add(
        TextSpan(
          text: _msg[i].message,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              if (_msg[i].isBold && onTap != null) {
                onTap();
              }
            },
          style: style.copyWith(
            color: _msg[i].isBold ? (boldColor ?? style.color) : style.color,
            fontSize: _msg[i].isBold
                ? (boldFontSize ?? style.fontSize)
                : boldFontSize,
            fontWeight: _msg[i].isBold ? boldWeight : style.fontWeight,
            decoration: showUnderline
                ? _msg[i].isBold
                    ? TextDecoration.underline
                    : null
                : null,
          ),
        ),
      );
    }

    return AutoSizeText.rich(
      TextSpan(
        children: texts,
      ),
      minFontSize: 1,
      textAlign: textAlign,
      maxLines: maxLine ?? getTextLine(msg),
    );
  }

  static int getTextLine(String text) {
    if (text.contains("\n")) {
      return text.split("\n").length;
    } else {
      return 1;
    }
  }
}

class _BoldMessage {
  final String message;
  final bool isBold;

  _BoldMessage({required this.message, this.isBold = false});
}

class _GuideMessageGenerator {
  static const BOLD_SIGN = "*";
  static List<_BoldMessage> from(String msg) {
    if (msg.split('').where((e) => e == BOLD_SIGN).toList().length % 2 != 0) {
      msg = msg + BOLD_SIGN;
    }

    int startIdx = 0;
    List<int> signIdxs = [];
    while (startIdx != -1) {
      startIdx = msg.indexOf(BOLD_SIGN, startIdx) + 1;
      if (startIdx != 0) {
        signIdxs.add(startIdx);
      } else {
        break;
      }
    }

    if (signIdxs.isEmpty) {
      return [_BoldMessage(message: msg)];
    }

    List<_BoldMessage> result = [];
    for (var i = 0; i < signIdxs.length / 2; i++) {
      var idx = 0;
      try {
        idx = signIdxs[2 * i - 1];
        // ignore: empty_catches
      } catch (err) {}
      result
          .add(_BoldMessage(message: msg.substring(idx, signIdxs[2 * i] - 1)));
      result.add(_BoldMessage(
          message: msg.substring(signIdxs[2 * i], signIdxs[2 * i + 1] - 1),
          isBold: true));

      if (i == signIdxs.length / 2 - 1 && signIdxs[i] != msg.length) {
        result.add(
            _BoldMessage(message: msg.substring(signIdxs.last, msg.length)));
      }
    }

    result = result.where((e) => e.message != "").toList();
    return result;
  }
}
