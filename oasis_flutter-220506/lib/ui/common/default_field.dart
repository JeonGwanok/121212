import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import '../theme.dart';

class DefaultField extends StatefulWidget {
  final int? maxLine;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter> inputFormatters;
  final String? initialValue;
  final String? hintText;
  final String? guideText;
  final bool onError;
  final bool onHide;
  final Function(String text)? onChange;
  final Function(String text)? onFieldSubmitted;
  final Function()? onEditingComplete;
  final int? textLimit;
  final FocusNode? focus;
  final bool showCancelButton;
  final Color? backgroundColor;
  final bool showCount;
  final bool enable;
  final bool onlyShowCapital;
  final double? height;
  final double? fontSize;
  final double? cursorHeight;

  DefaultField({
    this.keyboardType = TextInputType.emailAddress,
    this.maxLine,
    this.prefixIcon,
    this.inputFormatters = const [],
    this.textLimit,
    this.initialValue = "",
    this.hintText,
    this.guideText = "",
    this.onError = false,
    this.onHide = false,
    this.onChange,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.focus,
    this.showCancelButton = true,
    this.backgroundColor,
    this.showCount = false,
    this.enable = true,
    this.onlyShowCapital = false,
    this.height,
    this.fontSize,
    this.cursorHeight,
  });

  @override
  _DefaultFieldState createState() => _DefaultFieldState();
}

class _DefaultFieldState extends State<DefaultField> {
  TextEditingController? _controller;
  FocusNode? focusNode;

  @override
  void initState() {
    focusNode = widget.focus;
    if (focusNode != null) {
      focusNode?.requestFocus();
    }

    _controller = TextEditingController(text: widget.initialValue)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    focusNode?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var borderColor = widget.onError ? red500 : gray300;
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(
        width: 1,
        color: borderColor,
        style: BorderStyle.solid,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: TextFormField(
            textCapitalization: widget.onlyShowCapital
                ? TextCapitalization.characters
                : TextCapitalization.none,
            enabled: widget.enable,
            focusNode: focusNode,
            controller: _controller,
            onEditingComplete: widget.onEditingComplete,
            obscureText: widget.onHide,
            cursorColor: darkBlue,
            cursorHeight: widget.cursorHeight,
            keyboardType: (widget.maxLine ?? 1) > 1
                ? TextInputType.multiline
                : widget.keyboardType,
            style: body01.copyWith(
                fontSize: widget.fontSize,
                color: widget.enable ? gray900 : gray600,
                height:(_controller?.text ?? "").isEmpty ? null : 1.8),
            onFieldSubmitted: (text) {
              if (widget.onFieldSubmitted != null) {
                widget.onFieldSubmitted!(text);
              }
            },
            onChanged: (text) {
              if (widget.onChange != null) {
                widget.onChange!(text);
              }
            },
            maxLength: widget.textLimit,
            maxLines: widget.maxLine ?? 1,
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
              counterText: "",
              fillColor: widget.enable ? widget.backgroundColor : gray100,
              filled: widget.enable ? widget.backgroundColor != null : true,
              prefixIcon: widget.prefixIcon != null
                  ? Container(
                      padding: EdgeInsets.all(6),
                      child: widget.prefixIcon,
                    )
                  : null,
              hintText: widget.hintText ?? "",
              hintStyle:
                  body01.copyWith(color: gray400, fontSize: widget.fontSize,height: 1.8 ),
              suffixIcon:
                  (widget.showCancelButton || widget.suffixIcon != null) &&
                          widget.enable
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_controller?.text != "")
                              GestureDetector(
                                onTap: () {
                                  if (_controller != null) {
                                    _controller!.clear();
                                  }
                                  if (widget.onChange != null) {
                                    widget.onChange!("");
                                  }
                                },
                                child: CustomIcon(
                                  path: "icons/circleCancel",
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            if (widget.suffixIcon != null) SizedBox(width: 10),
                            widget.suffixIcon != null
                                ? Container(
                                    margin: EdgeInsets.only(right: 12),
                                    child: widget.suffixIcon,
                                  )
                                : Container()
                          ],
                        )
                      : null,
              contentPadding: EdgeInsets.only(
                left: widget.prefixIcon != null ? 0 : 16,
                right: widget.prefixIcon != null
                    ? 6
                    : widget.suffixIcon == null
                        ? 16
                        : 6,
                top: widget.maxLine != null ? 31 : 15.0,
              ),
              disabledBorder: border,
              enabledBorder: border,
              focusedBorder: border,
            ),
          ),
          height: widget.height,
        ),
        if (widget.guideText != "" || widget.showCount)
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 4 + 8, right: 4 + 8, bottom: 0),
                    child: Text(
                      widget.guideText ?? "",
                      style: caption01.copyWith(
                          height: 1.3,
                          color: widget.onError ? Colors.red : gray400),
                    ),
                  ),
                ),
                if (widget.showCount)
                  Container(
                    margin: EdgeInsets.only(right: 6),
                    child: Text(
                      "${_controller?.text.length}/${widget.textLimit}자",
                      style: caption01.copyWith(color: gray400),
                    ),
                  )
              ],
            ),
          )
      ],
    );
  }
}
