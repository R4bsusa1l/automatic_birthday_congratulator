import "package:flutter/material.dart";
import 'package:english_words/english_words.dart';

class CardDisplay extends StatelessWidget {
  const CardDisplay({super.key, required this.pair});

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    final double height = MediaQuery.of(context).size.height;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: height / 2),
        child: CarouselView.weighted(
          scrollDirection: Axis.vertical,
          flexWeights: const <int>[
            1,
          ], // Or any positive integers as long as the length of the array is 1.
          children: List<Widget>.generate(10, (int index) {
            return Center(child: Text('Item $index'));
          }),
        ),
      ),
    );
  }
}
