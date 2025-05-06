import 'package:flutter/material.dart';
import 'package:overlapped_carousel/overlapped_carousel.dart';
import 'dart:math';

class CarouselDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    final double height = MediaQuery.of(context).size.height;

    return Center(
      child: Container(
        color: style.color,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: height / 2),
          child: SizedBox(
            height: min(screenWidth / 3.3 * (16 / 9), screenHeight * .9),
            child: OverlappedCarousel(
              widgets: [
                ...List<Widget>.generate(10, (int index) {
                  return Card(
                    color: Colors.primaries[index % Colors.primaries.length],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(child: Text('Item $index', style: style)),
                  );
                }),
              ],
              currentIndex: 2,
              onClicked: (index) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("You clicked at $index")),
                );
              },
              // To obscure or blur cards not in focus use the obscure parameter.
              obscure: 0.1,
              // To control skew angle
              skewAngle: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}
