import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../../theme.dart';

TextFieldTags tagField({
  required List<String> tags,
  required Function(String) onAdd,
  required Function(String) onDelete,
  required Function onErr,
}) {
  var border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: BorderSide(
      width: 1,
      color: gray300,
      style: BorderStyle.solid,
    ),
  );
  return TextFieldTags(initialTags: tags,
      tagsDistanceFromBorderEnd: 0.8,
      tagsStyler: TagsStyler(
        tagTextPadding: EdgeInsets.symmetric(horizontal: 3),
        tagTextStyle: caption01.copyWith(color: mainMint),
        tagDecoration: BoxDecoration(
          color: lightMint,
          borderRadius: BorderRadius.circular(100),
        ),
        tagCancelIcon: Container(
          margin: EdgeInsets.only(left: 3),
          child: Icon(
            Icons.cancel,
            color: mainMint,
          ),
        ),
        tagPadding: const EdgeInsets.all(5.0),
      ),
      textFieldStyler: TextFieldStyler(
        helperText: "",
        contentPadding: EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        cursorColor: gray600,
        textFieldFilled: true,
        textStyle: body01.copyWith( fontFamily: "Godo",),
        textFieldFilledColor: Colors.white,
        hintText: "최대 10개까지 가능하며, 띄어쓰기를 하면 태그가 완성됩니다.",
        hintStyle: body01.copyWith(color: gray400),
        textFieldFocusedBorder: border,
        textFieldBorder: border,
        textFieldEnabledBorder: border,
      ),
      onTag: (tag) {
          if (!tags.contains(tag)) {
            onAdd(tag);
          }

      },
      onDelete: (tag) {
        onDelete(tag);
      },
      validator: (tag) {
        if (tags.length >= 10) {
          onErr();
          return "10개 이하만 가능합니다.";
        }

        if (tags.contains(tag)) {
          onErr();
          return "이미 입력된 태그입니다.";
        }
        return null;
      });
}
