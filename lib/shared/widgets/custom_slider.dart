
import 'package:flutter/material.dart';

class SlideableContainer extends StatefulWidget {
  final Widget child;
  final double initialPosition;
  final double minPosition;
  final double maxPosition;
  final Function onSlide;

  const SlideableContainer({
    Key? key,
    required this.child,
    required this.initialPosition,
    required this.minPosition,
    required this.maxPosition,
    required this.onSlide,
  }) : super(key: key);

  @override
  _SlideableContainerState createState() => _SlideableContainerState();
}

class _SlideableContainerState extends State<SlideableContainer> {
  double _position = 0.0;
  bool _isSliding = false;

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (_isSliding) {
          setState(() {
            _position = _position + details.delta.dx;
            _position = _position.clamp(widget.minPosition, widget.maxPosition);
          });
        }
      },
      onHorizontalDragStart: (details) {
        _isSliding = true;
      },
      onHorizontalDragEnd: (details) {
        _isSliding = false;
        setState(() {
          _position = widget.initialPosition;
        });
        widget.onSlide();
      },
      child: Transform.translate(
        offset: Offset(_position, 0),
        child: widget.child,
      ),
    );
  }
}