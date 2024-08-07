import 'package:flutter/material.dart';

class ScrollingTomatoNamespaces extends StatefulWidget {
  final List<String> namespaces;

  const ScrollingTomatoNamespaces({super.key, required this.namespaces});

  @override
  ScrollingTomatoNamespacesState createState() =>
      ScrollingTomatoNamespacesState();
}

class ScrollingTomatoNamespacesState extends State<ScrollingTomatoNamespaces> {
  late ScrollController _scrollController;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScrolling();
    });
  }

  void _startScrolling() {
    if (_scrollController.hasClients && !_isScrolling) {
      _isScrolling = true;
      double maxExtent = _scrollController.position.maxScrollExtent;
      double distanceDifference = maxExtent - _scrollController.offset;
      double durationDouble = distanceDifference / 30; // スクロール速度を調整

      _scrollController
          .animateTo(_scrollController.position.maxScrollExtent,
              duration: Duration(seconds: durationDouble.toInt()),
              curve: Curves.linear)
          .then((_) {
        if (_isScrolling) {
          if (_scrollController.offset >= maxExtent) {
            _scrollController.jumpTo(0);
          }
          _startScrolling();
        }
      });
    }
  }

  void _stopScrolling() {
    _isScrolling = false;
    _scrollController.animateTo(
      _scrollController.offset,
      duration: const Duration(milliseconds: 1),
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, // 高さを調整
      child: GestureDetector(
        onPanDown: (_) {
          _stopScrolling();
        },
        onPanCancel: () {
          _startScrolling();
        },
        onPanEnd: (_) {
          _startScrolling();
        },
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          itemCount: widget.namespaces.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Text(
                  widget.namespaces[index],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
