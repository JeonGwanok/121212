import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oasis/model/user/customer/customer.dart';
import 'package:oasis/ui/common/cache_image.dart';
import 'package:oasis/ui/common/info_field.dart';
import 'package:oasis/ui/register_user_info/common/base_info/gender_select.dart';
import 'package:oasis/ui/theme.dart';

class UserStatusCard extends StatefulWidget {
  final Customer? customer;
  final String? imageUrl;
  UserStatusCard({
    required this.customer,
    required this.imageUrl,
  });

  @override
  _UserStatusCardState createState() => _UserStatusCardState();
}

class _UserStatusCardState extends State<UserStatusCard> {
  @override
  Widget build(BuildContext context) {
    var widthRatio = MediaQuery.of(context).size.width / 414;
    return Container(
      width: 178 * widthRatio,
      height: 282,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white),
          boxShadow: cardShadow),
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: CacheImage(
                url: widget.imageUrl ?? "",
                boxFit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  InfoField(
                    titleWidth: 46,
                    title:
                        "${widget.customer?.gender != null ? (widget.customer?.gender as Gender).title : "--"}",
                    value: "${widget.customer?.nickName ?? "--"}",
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: gray100),
                    ),
                    child: Text(
                      "${(widget.customer?.username ?? "--").replaceAllMapped(
                          RegExp(r'(\d{3})(\d{4})(\d+)'), (m) => "${m[1]}-${m[2]}-${m[3]}")}",
                      style: body01.copyWith(color: gray600),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
