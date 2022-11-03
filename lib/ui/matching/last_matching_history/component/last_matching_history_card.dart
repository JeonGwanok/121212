import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oasis/model/matching/last_matching.dart';
import 'package:oasis/ui/theme.dart';

class LastMatchingCard extends StatefulWidget {
  final bool isFirst;
  final Function onTap;
  final LastMatching item;
  LastMatchingCard({
    required this.item,
    required this.onTap,
    this.isFirst = false,
  });

  @override
  _LastMatchingCardState createState() => _LastMatchingCardState();
}

class _LastMatchingCardState extends State<LastMatchingCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 3,
                height: 20,
                color: widget.isFirst ? Colors.transparent : mainMint,
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    color: mainMint,
                    boxShadow: cardShadow,
                    borderRadius: BorderRadius.circular(100)),
              ),
              Container(
                width: 3,
                height: 110,
                decoration: BoxDecoration(
                  boxShadow: cardShadow,
                  color: mainMint,
                ),
              ),
            ],
          ),
          SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () {
                widget.onTap();
              },
              child: Container(
                height: 114,
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white),
                    boxShadow: cardShadow),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${DateFormat("yyyy년 MM월 dd일 추천 카드").format(widget.item.createdAt ?? DateTime.now())}',
                      style: body03.copyWith(color: gray600),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '상태',
                          style: body02.copyWith(color: gray600),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                              border: Border.all(color: gray100),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                           widget.item.status ?? "",
                            style: body03.copyWith(color: gray600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
