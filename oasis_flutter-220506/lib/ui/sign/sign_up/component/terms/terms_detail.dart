import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/sign/sign_up/component/terms/terms_model.dart';
import 'package:oasis/ui/theme.dart';

class TermDetail extends StatelessWidget {
  final TermsModel item;
  final String buttonLabel;
  TermDetail({
    required this.item,
    this.buttonLabel = "닫기",
  });

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      buttons: [
        BaseScaffoldDefaultButtonScheme(
            title: buttonLabel,
            onTap: () {
              Navigator.pop(context, true);
            })
      ],
      onBack: () {
        Navigator.pop(context, false);
      },
      title: item.title,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: gray200),
              boxShadow: cardShadow),
          child: SingleChildScrollView(
            child: Text(
              item.content,
              style: body01.copyWith(color: gray600),
            ),
          ),
        ),
      ),
    );
  }
}
