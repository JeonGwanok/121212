import 'package:flutter/material.dart';

import 'package:iamport_flutter/iamport_certification.dart';
import 'package:iamport_flutter/model/certification_data.dart';
import 'package:oasis/ui/common/custom_icon.dart';

import '../../theme.dart';

class PhoneCertificateScreen extends StatelessWidget {
  final String phoneNumber;
  PhoneCertificateScreen({required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return IamportCertification(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: CustomIcon(
            path: "icons/back",
          ),
        ),
        title: Text(
          '본인인증',
          style: header02,
        ),
      ),
      initialChild: Container(
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white.withOpacity(0),
            valueColor: AlwaysStoppedAnimation<Color>(darkBlue),
          ),
        ),
      ),
      userCode: 'imp95472118',
      data: CertificationData(
        merchantUid: 'mid_${DateTime.now().millisecondsSinceEpoch}', // 주문번호
        phone: phoneNumber, // 전화번호
      ),
      callback: (Map<String, String> result) {
        if (result["success"] == "true") {
          Navigator.pop(context, result["imp_uid"]);
        } else {
          Navigator.pop(context);
        }
      },
    );
  }
}
