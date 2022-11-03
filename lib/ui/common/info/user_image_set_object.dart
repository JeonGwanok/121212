import 'package:flutter/material.dart';
import 'package:oasis/model/user/image/user_image.dart';
import 'package:oasis/ui/common/cache_image.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';

import '../../theme.dart';

class UserImageSetObject extends StatefulWidget {
  final UserImage? userImage;
  final int? matchingRate;

  UserImageSetObject({
    required this.userImage,
    this.matchingRate,
  });

  @override
  _UserImageSetObjectState createState() => _UserImageSetObjectState();
}

class _UserImageSetObjectState extends State<UserImageSetObject> {
  late PageController _pageController;

  List<String> _images = [];
  @override
  void initState() {
    _images = (widget.userImage?.imagesToList ?? []);
    _pageController = PageController(initialPage: 0)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: double.infinity,
              height: 504,
              child: _images.isNotEmpty
                  ? PageView(
                      controller: _pageController,
                      children: [
                        ..._images
                            .map(
                              (e) => Container(
                                alignment: Alignment.center,
                                child: PinchZoomImage(
                                  image: Image.network(
                                    e ,
                                    fit: BoxFit.cover,
                                    width:
                                    double.infinity,
                                    height:
                                    double.infinity,
                                    alignment:
                                    Alignment.center,
                                  ),
                                  zoomedBackgroundColor:
                                  Colors.black
                                      .withOpacity(
                                      0.1),
                                  hideStatusBarWhileZooming:
                                  true,
                                ),
                              ),
                            )
                            .toList()
                      ],
                    )
                  : Center(
                      child: Text(
                        '이미지가 없습니다.',
                        style: header02.copyWith(color: gray400),
                      ),
                    ),
            ),
            IgnorePointer(
              child: Container(
                height: 212,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.1, 1],
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.4),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            if (widget.matchingRate != null)
              _matchingRate(widget.matchingRate ?? 0),
            _indicator(),
          ],
        ),
      ],
    );
  }

  _indicator() {
    int currentPage = 0;
    if (_pageController.hasClients && _images.isNotEmpty) {
      currentPage = (_pageController.page ?? 0).round() + 1;
    }

    return Column(children: [
      Container(
        height: 40,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._images
                .asMap()
                .map(
                  (i, e) {
                    bool isSelected = false;
                    if (_pageController.hasClients) {
                      isSelected = (_pageController.page ?? 0).round() == i;
                    }

                    return MapEntry(
                      i,
                      GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(i,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease);
                        },
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.transparent),
                            color: gray100,
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          width: isSelected ? 40 : 32,
                          height: isSelected ? 40 : 32,
                          child: CacheImage(
                            url: e,
                            boxFit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                )
                .values
                .toList()
          ],
        ),
      ),
      SizedBox(height: 12),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$currentPage/",
            style: header03.copyWith(color: Colors.white),
          ),
          Text(
            "${_images.length}",
            style: header03.copyWith(
              color: Colors.white.withOpacity(0.5),
            ),
          )
        ],
      ),
      SizedBox(height: 15),
    ]);
  }

  _matchingRate(int matchingRate) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 13),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '매칭률',
            style: header05.copyWith(color: Colors.white),
          ),
          Container(
            height: 2,
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: gray200,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                Expanded(
                    flex: matchingRate,
                    child: Container(
                      color: Colors.white,
                    )),
                Expanded(
                  flex: 100 - matchingRate,
                  child: Container(),
                ),
              ],
            ),
          ),
          Text(
            "$matchingRate%",
            style: header06.copyWith(color: Colors.white),
          )
        ],
      ),
    );
  }
}
