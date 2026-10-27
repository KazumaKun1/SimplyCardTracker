import 'package:flutter/material.dart';

class HorizontalCardCarousel extends StatefulWidget {
  const HorizontalCardCarousel({
    super.key,
    required this.numberOfItems,
    required this.selectedIndex,
    required this.onSelectedChanged,
    required this.itemBuilder,
  });

  final int numberOfItems;
  final int selectedIndex;
  final ValueChanged<int> onSelectedChanged;
  final IndexedWidgetBuilder itemBuilder;

  @override
  State<HorizontalCardCarousel> createState() => _HorizontalCardCarouselState();
}

class _HorizontalCardCarouselState extends State<HorizontalCardCarousel> {
  late final PageController _controller = PageController(
    viewportFraction: 0.8,
    initialPage: widget.selectedIndex,
  );

  @override
  void didUpdateWidget(covariant HorizontalCardCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedIndex != oldWidget.selectedIndex &&
        _controller.hasClients &&
        _controller.page?.round() != widget.selectedIndex) {
      _controller.animateToPage(
        widget.selectedIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const fraction = 0.8;
        const aspectRatio = 0.63;
        const gap = 8.0;
        const shadowRoom = 30.0;
        final itemWidth = constraints.maxWidth * fraction - gap * 2;
        return SizedBox(
          height: itemWidth / aspectRatio + shadowRoom * 2,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.numberOfItems,
            onPageChanged: widget.onSelectedChanged,
            itemBuilder: (context, index) => Padding(
              padding: const .symmetric(horizontal: gap, vertical: shadowRoom),
              child: widget.itemBuilder(context, index),
            ),
          ),
        );
      },
    );
  }
}
