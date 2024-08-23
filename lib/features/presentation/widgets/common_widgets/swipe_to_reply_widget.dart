import 'package:flutter/material.dart';

class SwipeToReplyWidget extends StatefulWidget {
  final Widget child;
  final Function onSwipeReply;
  const SwipeToReplyWidget({
    super.key,
    required this.child,
    required this.onSwipeReply,
  });

  @override
  State<SwipeToReplyWidget> createState() => _SwipeToReplyWidgetState();
}

class _SwipeToReplyWidgetState extends State<SwipeToReplyWidget> {
  double _dragExtent = 0.0;
  bool _isSwiping = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragExtent += details.primaryDelta!;
          if (_dragExtent > 100 && !_isSwiping) {
            _isSwiping = true;
            widget.onSwipeReply();
          }
        });
      },
      onHorizontalDragEnd: (details) {
        setState(() {
          _dragExtent = 0.0;
          _isSwiping = false;
        });
      },
      child: AnimatedContainer(
        duration:const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(_dragExtent, 0, 0),
        child: widget.child,
      ),
    );
  }
}