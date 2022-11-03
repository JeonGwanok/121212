import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oasis/ui/theme.dart';

// 실제 캐시가 되진 않아욥
class CacheImage extends StatefulWidget {
  final BoxFit boxFit;
  final String url;

  CacheImage({
    this.boxFit = BoxFit.fitHeight,
    required this.url,
  });

  @override
  _CacheImageState createState() => _CacheImageState();
}

class _CacheImageState extends State<CacheImage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          child: Container(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              backgroundColor: gray300,
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.network(
            widget.url,
            fit: widget.boxFit,
            loadingBuilder: (_, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                alignment: Alignment.center,
                child: Container(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    backgroundColor: gray300,
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              );
            },
            errorBuilder: (_, __, ___) {
              return Container();
            },
          ),
        ),
      ],
    );
  }
}
