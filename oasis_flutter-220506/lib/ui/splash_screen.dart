import 'package:flutter/material.dart';
import 'package:oasis/ui/common/cache_image.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/theme.dart';
import 'package:oasis/ui/util/bold_generator.dart';
import 'common/base_scaffold.dart';

class SplashScreen extends StatefulWidget {
  final bool enableAnimation;
  final double? width;
  SplashScreen({this.enableAnimation = true, this.width});

  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => SplashScreen());

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late ScrollController controller;

  double width = 0.0;
  @override
  void initState() {
    controller = ScrollController(initialScrollOffset: widget.width ?? 0)..addListener(() {});
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (widget.enableAnimation) {
        controller.animateTo(width,
            duration: Duration(milliseconds: 2000), curve: Curves.easeIn);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var ratio = MediaQuery.of(context).size.height / 896;
    width = ((MediaQuery.of(context).size.height * 1480) / 1688) -
        MediaQuery.of(context).size.width;
    return BaseScaffold(
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: controller,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Container(
                alignment: Alignment.topRight,
                child: CustomIcon(
                  path: "photos/splash_photo",
                  type: "png",
                  alignment: Alignment.centerLeft,
                  height: MediaQuery.of(context).size.height,
                  width: (MediaQuery.of(context).size.height * 1480) / 1688,
                ),
              ),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BoldMsgGenerator.toRichText(
                    msg: "도심 속 *오아시스*에서 사랑을 꿈꾸다.\n*꿈*이 *현실*이 되는",
                    boldWeight: FontWeight.w800,
                    style: body05.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w300
                    ),
                  ),
                  SizedBox(height: 36),
                  CustomIcon(
                    path: "photos/logo_white",
                    type: "svg",
                    alignment: Alignment.centerLeft,
                    width: 259 * ratio,
                    height: 77 * ratio,
                  ),
                  SizedBox(
                    height: 114 * ratio,
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
