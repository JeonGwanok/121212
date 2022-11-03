import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/illust.dart';
import 'package:oasis/ui/sign/sign_up/component/terms/terms_detail.dart';
import 'package:oasis/ui/sign/sign_up/component/terms/terms_model.dart';
import 'package:oasis/ui/theme.dart';

class SignUpTerms extends StatefulWidget {
  final List<TermsModel> terms; // 목록
  final List<TermsModel> initialTerms; // 선택한 약관
  final Function(List<TermsModel>) onChange;

  SignUpTerms({
    required this.terms,
    required this.initialTerms,
    required this.onChange,
  });

  @override
  _SignUpTermsState createState() => _SignUpTermsState();
}

class _SignUpTermsState extends State<SignUpTerms> {
  @override
  Widget build(BuildContext context) {
    var ratio = MediaQuery.of(context).size.height / 896;
    return Container(
      child: Column(
        children: [
          SizedBox(height: 38 * ratio),
          GestureDetector(
            onTap: () {
              setState(() {
                if (widget.initialTerms.length == widget.terms.length) {
                  widget.onChange([]);
                } else {
                  widget.onChange([...widget.terms]);
                }
              });
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 17),
              decoration: BoxDecoration(
                  color: mainMint, borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '모두 동의',
                    style: header02.copyWith(color: Colors.white),
                  ),
                  CustomIcon(
                    path: "icons/lineCheck",width: 20,height: 20,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          ...widget.terms
              .map(
                (e) => TermsObject(
                  item: e,
                  isChecked: widget.initialTerms
                      .map((e) => e.title)
                      .toList()
                      .contains(e.title),
                  onTap: (item) {
                    var old = [...widget.initialTerms];
                    setState(() {
                      if (widget.initialTerms.contains(item)) {
                        old.remove(item);
                      } else {
                        old.add(item);
                      }
                      widget.onChange(old);
                    });
                  },
                ),
              )
              .toList()
        ],
      ),
    );
  }
}

// ==

class TermsObject extends StatefulWidget {
  final TermsModel item;
  final bool isChecked;
  final Function(TermsModel) onTap;

  TermsObject({
    required this.item,
    required this.isChecked,
    required this.onTap,
  });

  @override
  _TermsObjectState createState() => _TermsObjectState();
}

class _TermsObjectState extends State<TermsObject> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                widget.item.required ? '[필수]' : '[선택]',
                style: body03,
              ),
              SizedBox(width: 12),
              Text(
                widget.item.title,
                style: body01,
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TermDetail(item: widget.item),
                      ));
                },
                child: Text(
                  '보기',
                  style: body02.copyWith(color: mainMint),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              widget.onTap(widget.item);
            },
            child: CustomIcon(
              path: widget.isChecked ? "icons/check" : "icons/uncheck",
              width: 20,
              height: 20,
            ),
          )
        ],
      ),
    );
  }
}
