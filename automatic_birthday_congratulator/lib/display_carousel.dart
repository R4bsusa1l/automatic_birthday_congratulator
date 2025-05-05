import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;

class CarouselDisplay extends StatelessWidget {
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
        child: carousel_slider.CarouselSlider.builder(
          options: carousel_slider.CarouselOptions(
            height: 400, // Height of the carousel
            autoPlay: false, // Disable auto-scrolling
            enlargeCenterPage: true, // Enlarge the center card
            viewportFraction: 0.6, // Fraction of the viewport each card takes
            enableInfiniteScroll: true, // Enable infinite scrolling
            scrollPhysics: BouncingScrollPhysics(), // Smooth scrolling
          ),
          itemCount: 10, // Number of cards
          itemBuilder: (context, index, realIndex) {
            return Transform.scale(
              scale: realIndex == index ? 1.0 : 0.8, // Scale background cards
              child: Opacity(
                opacity:
                    realIndex == index ? 1.0 : 0.5, // Fade background cards
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.card_giftcard,
                        size: 64,
                        color: theme.colorScheme.onPrimary,
                      ),
                      SizedBox(height: 16),
                      Text('Card $index', style: style),
                      SizedBox(height: 8),
                      Text(
                        'Additional Info',
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorScheme.onPrimary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
