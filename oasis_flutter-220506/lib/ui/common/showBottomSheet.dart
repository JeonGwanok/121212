import 'dart:math';

import 'package:flutter/material.dart';
import 'package:oasis/ui/theme.dart';

Future<T?> showBottomOptionSheet<T>(
  context, {
  required String title,
  required List<T> items,
  required List<String> labels,
  double? minChildSize,
}) async {
  T? value;
  await showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15.0),
      ),
    ),
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return DraggableScrollableSheet(
            initialChildSize: minChildSize ??
                min(
                    0.8,
                    max(
                        0.3,
                        (MediaQuery.of(context).padding.bottom +
                                80 +
                                (56 * items.length)) /
                            MediaQuery.of(context).size.height)),
            expand: false,
            minChildSize: minChildSize ??
                min(
                    0.8,
                    max(
                        0.3,
                        (MediaQuery.of(context).padding.bottom +
                                80 +
                                (56 * items.length)) /
                            MediaQuery.of(context).size.height)),
            maxChildSize: minChildSize ??
                min(
                    0.8,
                    max(
                        0.3,
                        (MediaQuery.of(context).padding.bottom +
                            80 +
                            (56 * items.length)) /
                            MediaQuery.of(context).size.height)),
            builder: (BuildContext context, ScrollController scrollController) {
              return Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: gray200),
                  ),
                  Container(
                    height: 72,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: gray100))),
                    child: Text(
                      title,
                      style: header05,
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (context, int) {
                        return Container();
                      },
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            value = items[index];
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 56,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            width: double.infinity,
                            color: Colors.white.withOpacity(0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                labels[index],
                                style: header04,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );
  return value;
}

Future<T?> showBottomOptionWithCancelSheet<T>(
  context, {
  required String title,
  required List<T> items,
  required List<String> labels,
  double? minChildSize,
}) async {
  T? value;
  await showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15.0),
      ),
    ),
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return DraggableScrollableSheet(
            initialChildSize: minChildSize ??
                min(
                    0.8,
                    max(
                        0.3,
                        (MediaQuery.of(context).padding.bottom +
                            80 +
                            (56 * items.length)) /
                            MediaQuery.of(context).size.height)),
            expand: false,
            minChildSize: minChildSize ??
                min(
                    0.8,
                    max(
                        0.3,
                        (MediaQuery.of(context).padding.bottom +
                            80 +
                            (56 * items.length)) /
                            MediaQuery.of(context).size.height)),
            maxChildSize: minChildSize ??
                min(
                    0.8,
                    max(
                        0.3,
                        (MediaQuery.of(context).padding.bottom +
                            80 +
                            (56 * items.length)) /
                            MediaQuery.of(context).size.height)),
            builder: (BuildContext context, ScrollController scrollController) {
              return Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: gray200),
                  ),
                  Container(
                    height: 58,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: gray100),
                      ),
                    ),
                    child: Text(
                      title,
                      style: header05,
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: items.length,
                      separatorBuilder: (context, int) {
                        return Container();
                      },
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            value = items[index];
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 56,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            width: double.infinity,
                            color: Colors.white.withOpacity(0),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                labels[index],
                                style: header04.copyWith(
                                    color: labels[index] == "취소"
                                        ? gray400
                                        : Colors.black),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );
  return value;
}
