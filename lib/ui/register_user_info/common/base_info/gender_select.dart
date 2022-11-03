import 'package:flutter/material.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/object_text_default_frame.dart';
import 'package:oasis/ui/theme.dart';

enum Gender {
  male,
  female,
}

extension GenderExtension on Gender {
  String get title {
    switch (this) {
      case Gender.male:
        return "남자";
      case Gender.female:
        return "여자";
    }
  }

  String get imagePath {
    switch (this) {
      case Gender.male:
        return "icons/male";
      case Gender.female:
        return "icons/female";
    }
  }
}

Gender? genderStringToKey(String gender) {
  switch (gender) {
    case "남자":
      return Gender.male;
    case "여자":
      return Gender.female;
  }
  return null;
}

class GenderSelect extends StatefulWidget {
  final Gender? initialValue;
  final Function(Gender) onChangeGender;
  GenderSelect({required this.onChangeGender, this.initialValue});

  @override
  _GenderSelectState createState() => _GenderSelectState();
}

class _GenderSelectState extends State<GenderSelect> {
  @override
  Widget build(BuildContext context) {
    return ObjectTextDefaultFrame(
      title: "* 성별",
      body: Container(
        child: Row(
          children: [
            _tile(Gender.male),
            SizedBox(width: 12),
            _tile(Gender.female),
          ],
        ),
      ),
    );
  }

  _tile(Gender gender) {
    var color = gender == widget.initialValue ? mainMint : gray300;
    return GestureDetector(
      onTap: () {
        // widget.onChangeGender(gender);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color),
        ),
        width: 64,
        height: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomIcon(
              path: gender.imagePath,
              color: color,
              width: 28,
              height: 28,
            ),
            SizedBox(height: 3),
            Text(
              gender.title,
              style: body04,
            )
          ],
        ),
      ),
    );
  }
}
