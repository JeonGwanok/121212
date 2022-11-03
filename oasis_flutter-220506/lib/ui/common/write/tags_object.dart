import 'package:flutter/cupertino.dart';

import '../../theme.dart';

class TagsObject extends StatelessWidget {
  final List<String> tags;
  final double? spacing;
  TagsObject({required this.tags, this.spacing});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 8,
      children: [
        ...tags
            .map(
              (e) => Container(
                height: 20,
                margin: EdgeInsets.only(right: spacing ?? 4),
                decoration: BoxDecoration(
                  color: lightMint,
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: Text(
                  e,
                  textAlign: TextAlign.center,
                  style: caption01.copyWith(color: mainMint, height: 1.3),
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}
