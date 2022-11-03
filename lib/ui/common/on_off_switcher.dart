import 'package:flutter/material.dart';
import 'package:oasis/ui/theme.dart';

class OnOffSwitch extends StatefulWidget {
  final bool value;
  final String title;
  final Function(bool) onChanged;

  OnOffSwitch({
    this.value = false,
    this.title = "",
    required this.onChanged,
  });

  @override
  _OnOffSwitchState createState() => _OnOffSwitchState();
}

class _OnOffSwitchState extends State<OnOffSwitch>
    with SingleTickerProviderStateMixin {
  late Animation _circleAnimation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _circleAnimation = AlignmentTween(
      begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
      end: widget.value ? Alignment.centerLeft : Alignment.centerRight,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: caption02.copyWith(
                color: _circleAnimation.value == Alignment.centerLeft
                    ? gray400
                    : mainMint,
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                if (_animationController.isCompleted) {
                  _animationController.reverse();
                } else {
                  _animationController.forward();
                }
                widget.value == false
                    ? widget.onChanged(true)
                    : widget.onChanged(false);
              },
              child: Container(
                width: 45.0,
                height: 24.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  color: Colors.white,
                  boxShadow: cardShadow,
                  border: Border.all(
                    color: _circleAnimation.value == Alignment.centerLeft
                        ? gray300
                        : mainMint,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 2,
                    right: 2,
                    top: 1,
                    bottom: 1,
                  ),
                  child: Container(
                    alignment: _circleAnimation.value,
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _circleAnimation.value == Alignment.centerLeft
                            ? gray300
                            : mainMint,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
