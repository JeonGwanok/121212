import 'package:flutter/material.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/snack_bar.dart';

class ToastTest extends StatefulWidget {
  @override
  _ToastTestState createState() => _ToastTestState();
}

class _ToastTestState extends State<ToastTest> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "dfsf",
      buttons: [
        BaseScaffoldDefaultButtonScheme(
            title: "Ddd",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                snackBar(context, "잘못됐습니다. 잘못됐습니다"),
              );
            })
      ],
    );
  }
}
