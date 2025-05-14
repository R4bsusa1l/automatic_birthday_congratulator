library;

import 'dart:ui';
import 'package:flutter/material.dart';

import 'card.dart';
import 'dart:math' as math;

class InfiniteOverlappedCarousel extends StatefulWidget {
  final List<Widget> widgets;
  final Function(int) onClicked;
  final int? currentIndex;
  final double obscure;
  final double skewAngle;

  const InfiniteOverlappedCarousel({
    super.key,
    required this.widgets,
    required this.onClicked,
    this.currentIndex,
    this.obscure = 0,
    this.skewAngle = -0.25,
  });

  @override
  InfiniteOverlappedCarouselState createState() =>
      InfiniteOverlappedCarouselState();
}

class InfiniteOverlappedCarouselState
    extends State<InfiniteOverlappedCarousel> {
  double currentIndex = 2;

  @override
  void initState() {
    if (widget.currentIndex != null) {
      currentIndex = widget.currentIndex!.toDouble();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                currentIndex -= details.delta.dx * 0.02;
                if (currentIndex < 0) {
                  currentIndex += widget.widgets.length;
                } else if (currentIndex >= widget.widgets.length) {
                  currentIndex -= widget.widgets.length;
                }
              });
            },
            onPanEnd: (details) {
              setState(() {
                // Snap to the nearest integer index
                currentIndex = currentIndex.roundToDouble();

                // Wrap around logic for snapping
                if (currentIndex < 0) {
                  currentIndex += widget.widgets.length;
                } else if (currentIndex >= widget.widgets.length) {
                  currentIndex -= widget.widgets.length;
                }
              });
            },
            child: OverlappedCarouselCardItems(
              cards: List.generate(
                widget.widgets.length,
                (index) => CardModel(id: index, child: widget.widgets[index]),
              ),
              centerIndex: currentIndex,
              maxWidth: constraints.maxWidth,
              maxHeight: constraints.maxHeight,
              onClicked: widget.onClicked,
              obscure: widget.obscure,
              skewAngle: widget.skewAngle,
            ),
          );
        },
      ),
    );
  }
}

class OverlappedCarouselCardItems extends StatelessWidget {
  final List<CardModel> cards;
  final Function(int) onClicked;
  final double centerIndex;
  final double maxHeight;
  final double maxWidth;
  final double obscure;
  final double skewAngle;

  const OverlappedCarouselCardItems({
    super.key,
    required this.cards,
    required this.centerIndex,
    required this.maxHeight,
    required this.maxWidth,
    required this.onClicked,
    required this.obscure,
    required this.skewAngle,
  });

  ({double left, double bottom}) getCardPosition(int index) {
    final double center = maxWidth / 2;
    final double centerWidgetWidth = maxWidth / 4;
    final double basePosition = center - centerWidgetWidth / 2;
    // does not work if centerIndex (currentPosition) is 9 and index to be displayed is 0. -> distance = 9
    // does not work if centerIndex (currentPosition) is 0 and index to be displayed is 9. -> distance = -9

    // Calculate the raw distance
    double rawDistance = index - centerIndex;

    // Calculate the shortest distance considering the wrap-around
    double distance = rawDistance % cards.length;

    if (distance > cards.length / 2) {
      distance -= cards.length;
    } else if (distance <= -cards.length / 2) {
      distance += cards.length;
    }

    final double nearWidgetWidth = centerWidgetWidth / 5 * 4;
    final double farWidgetWidth = centerWidgetWidth / 5 * 3;
    final double nearBackWidgetWidth = centerWidgetWidth / 5 * 2;
    final double farBackWidgetWidth = centerWidgetWidth / 5 * 1.25;
    final double centerBackWidgetWidth = centerWidgetWidth / 5;

    final double verticalCenter = maxHeight / 2;
    final double centerWidgetHeight = maxHeight / 2.5;
    final double verticalBasePosition =
        (verticalCenter - centerWidgetHeight) / 8;

    final double factor = 4.75; // make smaller for steeper incline

    if (distance == 0) {
      return (
        left: basePosition,
        bottom: verticalBasePosition,
      );
    } else if (distance.abs() > 0.0 && distance.abs() <= 1.0) {
      if (distance > 0) {
        return (
          left: basePosition - nearWidgetWidth * distance.abs(),
          bottom: verticalBasePosition +
              ((centerWidgetHeight / factor) * (distance.abs()))
        );
      } else {
        return (
          left: maxWidth -
              (basePosition - nearWidgetWidth * distance.abs()) -
              nearWidgetWidth -
              16,
          bottom: verticalBasePosition +
              ((centerWidgetHeight / factor) * (distance.abs()))
        );
      }
    } else if (distance.abs() >= 1.0 && distance.abs() <= 2.0) {
      if (distance > 0) {
        return (
          left: basePosition -
              nearWidgetWidth -
              (nearWidgetWidth - farWidgetWidth) * (distance.abs() - 1),
          bottom: verticalBasePosition +
              ((centerWidgetHeight / factor) * (distance.abs()))
        );
      } else {
        return (
          left: maxWidth -
              (basePosition -
                  nearWidgetWidth -
                  (nearWidgetWidth - farWidgetWidth) * (distance.abs() - 1)) -
              farWidgetWidth -
              16,
          bottom: verticalBasePosition +
              ((centerWidgetHeight / factor) * (distance.abs()))
        );
      }
    } else if (distance.abs() > 2.0 && distance.abs() <= 3.0) {
      if (distance > 0) {
        return (
          left: basePosition -
              nearWidgetWidth +
              (farBackWidgetWidth - centerBackWidgetWidth) *
                  (distance.abs() - 2),
          bottom: verticalBasePosition +
              ((centerWidgetHeight / factor) * (distance.abs()))
        );
      } else {
        return (
          left: maxWidth -
              (basePosition -
                  nearWidgetWidth +
                  (farWidgetWidth - nearBackWidgetWidth) *
                      (distance.abs() - 2)) -
              nearBackWidgetWidth -
              16,
          bottom: verticalBasePosition +
              ((centerWidgetHeight / factor) * (distance.abs()))
        );
      }
    } else if (distance.abs() > 3.0 && distance.abs() <= 4.0) {
      if (distance > 0) {
        return (
          left: basePosition -
              nearWidgetWidth +
              (nearWidgetWidth / 2) * (distance.abs() - 3),
          bottom: verticalBasePosition +
              ((centerWidgetHeight / factor) * (distance.abs()))
        );
      } else {
        return (
          left: maxWidth -
              (basePosition -
                  nearWidgetWidth +
                  (nearWidgetWidth / 2) * (distance.abs() - 3)) -
              farWidgetWidth -
              16,
          bottom: verticalBasePosition +
              ((centerWidgetHeight / factor) * (distance.abs()))
        );
      }
    } else {
      if (distance > 0) {
        return (
          left: basePosition +
              ((centerWidgetWidth - farWidgetWidth) / 2) * (distance.abs() - 4),
          bottom: verticalBasePosition +
              ((centerWidgetHeight / factor) * (distance.abs()))
        );
      } else {
        return (
          left: maxWidth -
              (basePosition +
                  ((centerWidgetWidth - farWidgetWidth) / 2) *
                      (distance.abs() - 4)) -
              farWidgetWidth -
              16,
          bottom: verticalBasePosition +
              ((centerWidgetHeight / factor) * (distance.abs()))
        );
      }
    }
  }

  ({double left, double bottom}) getCardPosition1(int index) {
    final double center = maxWidth / 2;
    final double centerWidgetWidth = maxWidth / 4;
    final double basePosition = center - centerWidgetWidth / 2;

    final double centerWidgetHeight = maxHeight / 2.5;

    double rawDistance = index - centerIndex;
    double distance = rawDistance % cards.length;
    if (distance > cards.length / 2) {
      distance -= cards.length;
    } else if (distance <= -cards.length / 2) {
      distance += cards.length;
    }

    final double absDistance = distance.abs();
    const double maxVisibleDistance =
        3.0; // Adjust for the number of visible side cards

    // Normalize distance for smoother calculations
    double normalizedDistance =
        (absDistance / maxVisibleDistance).clamp(0.0, 1.0);

    // --- Horizontal Positioning (Curvature) ---
    double horizontalOffset =
        maxWidth / 3 * math.sin(normalizedDistance * math.pi / 2);
    if (distance < 0) {
      horizontalOffset = -horizontalOffset;
    }
    final double leftPosition = basePosition -
        horizontalOffset *
            (1 + 0.2 * normalizedDistance); // Add a bit more push to the sides

    // --- Vertical Positioning ---
    double verticalOffset =
        maxHeight / 8 * math.cos((normalizedDistance + 1) * math.pi);
    final double bottomPosition =
        (maxHeight / 2 - centerWidgetHeight / 2) / 2 + verticalOffset;
    return (left: leftPosition, bottom: bottomPosition);
  }

  ({double left, double bottom}) getCardPosition2(int index) {
    final double center = maxWidth / 2;
    final double centerWidgetWidth = maxWidth / 4;
    final double basePosition = center - centerWidgetWidth / 2;

    final double centerWidgetHeight = maxHeight / 2.5;

    double rawDistance = index - centerIndex;
    double distance = rawDistance % cards.length;
    if (distance > cards.length / 2) {
      distance -= cards.length;
    } else if (distance <= -cards.length / 2) {
      distance += cards.length;
    }

    final double absDistance = distance.abs();
    final double maxVisibleDistance = 6.0; // Increased to show more cards

    double normalizedDistance =
        (absDistance / maxVisibleDistance).clamp(0.0, 1.0);

    // --- Horizontal Positioning (More Circular) ---
    double horizontalOffset =
        maxWidth / 2.5 * math.sin(normalizedDistance * math.pi / 2);
    if (distance < 0) {
      horizontalOffset = -horizontalOffset;
    }
    final double leftPosition =
        basePosition - horizontalOffset * (1 + 0.1 * normalizedDistance);

    // --- Vertical Positioning (Smoother Circular Arc) ---
    double verticalOffset =
        maxHeight / 2 * (0.5 - math.cos(normalizedDistance * math.pi) / 2);
    final double bottomPosition =
        (maxHeight / 2 - centerWidgetHeight / 2) / 2 + verticalOffset;

    return (left: leftPosition, bottom: bottomPosition);
  }

  // -.---.-.-.-.-.-.-.-.-.-.-.-.-.-.-

  ({double left, double bottom}) getCardPosition3(int index) {
    final double center = maxWidth / 2;
    final double centerWidgetWidth = maxWidth / 4;
    final double basePosition = center - centerWidgetWidth / 2;
    final double centerWidgetHeight = maxHeight / 2.5;

    double rawDistance = index - centerIndex;
    double distance = rawDistance % cards.length;
    if (distance > cards.length / 2) {
      distance -= cards.length;
    } else if (distance <= -cards.length / 2) {
      distance += cards.length;
    }

    final double absDistance = distance.abs();
    final double maxVisibleDistance = cards.length.toDouble();
    //final double maxVisibleDistance = 6.0;

    double normalizedDistance =
        (absDistance / maxVisibleDistance).clamp(0.0, 1.0);

    // --- Horizontal Positioning (More Circular) ---
    double horizontalOffset =
        maxWidth / 2.5 * math.sin(normalizedDistance * math.pi * 2);
    if (distance < 0) {
      horizontalOffset = -horizontalOffset;
    }
    final double leftPosition =
        basePosition - horizontalOffset * (1 + 0.1 * normalizedDistance);

    double verticalOffset;
    double verticalScale = maxHeight / 2;
    double transitionPoint =
        0.5; // Adjust this to control where the transition happens

    if (normalizedDistance <= transitionPoint) {
      // Sine arc for closer cards
      verticalOffset = verticalScale * math.sin(normalizedDistance * math.pi);
    } else {
      // Cosine arc for further cards (slanting upwards)
      double adjustedNormalizedDistance =
          (normalizedDistance - transitionPoint) / (1 - transitionPoint);
      verticalOffset =
          verticalScale * (math.cos(adjustedNormalizedDistance * math.pi));
    }

    final double bottomPosition =
        (maxHeight / 2 - centerWidgetHeight / 2) / 2 + verticalOffset;

    return (left: leftPosition, bottom: bottomPosition);
  }

  double getCardWidth(int index) {
    final double centerWidgetWidth = maxWidth / 3.5;
    final double nearWidgetWidth = centerWidgetWidth / 5 * 4.5;
    final double farWidgetWidth = centerWidgetWidth / 5 * 3.5;

    // Calculate the raw distance
    double rawDistance = centerIndex - index;

    // Calculate the shortest distance considering the wrap-around
    double distance = rawDistance % cards.length;

    if (distance > cards.length / 2) {
      distance -= cards.length;
    } else if (distance <= -cards.length / 2) {
      distance += cards.length;
    }

    final double absDistance =
        distance.abs(); // Use the absolute shortest distance

    if (absDistance >= 0.0 && absDistance < 1.0) {
      return centerWidgetWidth -
          (centerWidgetWidth - nearWidgetWidth) *
              (absDistance - absDistance.floor());
    } else if (absDistance >= 1.0 && absDistance < 2.0) {
      return nearWidgetWidth -
          (nearWidgetWidth - farWidgetWidth) *
              (absDistance - absDistance.floor());
    } else {
      return farWidgetWidth;
    }
  }

  Widget _buildItem(CardModel item) {
    final int index = item.id;
    final width = getCardWidth(index);
    final height = maxHeight - 20 * (getCircularDistance(index)).abs();
    final position = getCardPosition3(index);
    final verticalPadding = width * 0.05 * (getCircularDistance(index)).abs();

    return Positioned(
      left: position.left,
      bottom: position.bottom,
      child: Stack(
        children: [
          Container(
            width: width.toDouble(),
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            height: height > 0 ? height : 0,
            child: item.child,
          ),
          Container(
            width: width.toDouble(),
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            height: height > 0 ? height : 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: getFilter(obscure, index),
                child: Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _sortedStackWidgets(List<CardModel> widgets) {
    for (int i = 0; i < widgets.length; i++) {
      // Calculate the raw distance
      double rawDistance = centerIndex - widgets[i].id;

      // Calculate the shortest distance considering the wrap-around
      double distance = rawDistance % cards.length;

      if (distance > cards.length / 2) {
        distance -= cards.length;
      } else if (distance <= -cards.length / 2) {
        distance += cards.length;
      }

      widgets[i].wrappedDistance =
          distance.abs(); // Store the wrapped absolute distance

      if (widgets[i].id == centerIndex.round()) {
        // Use rounded centerIndex for comparison
        widgets[i].zIndex =
            widgets.length.toDouble() - widgets[i].wrappedDistance;
      } else {
        widgets[i].zIndex =
            widgets.length.toDouble() - widgets[i].wrappedDistance - 1;
      }
    }

    widgets.sort((a, b) => a.zIndex.compareTo(b.zIndex));
    return widgets.map((e) {
      // Use the stored wrapped absolute distance for filtering
      if (e.wrappedDistance >= 0 && e.wrappedDistance <= 5) {
        return _buildItem(e);
      } else {
        return Container();
      }
    }).toList();
  }

  ImageFilter getFilter(double obscure, int index) {
    // Calculate the raw distance
    double rawDistance = (centerIndex - index).abs();

    // Calculate the shortest distance considering the wrap-around
    double distance = rawDistance % cards.length;

    if (distance > cards.length / 2) {
      distance -= cards.length;
    } else if (distance <= -cards.length / 2) {
      distance += cards.length;
    }
    return ImageFilter.blur(
      sigmaX: 5.0 * obscure * distance,
      sigmaY: 5.0 * obscure * distance,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.center,
        clipBehavior: Clip.none,
        children: _sortedStackWidgets(cards),
      ),
    );
  }

  double getCircularDistance(int index) {
    // Calculate the raw distance
    double rawDistance = (centerIndex - index).abs();

    // Calculate the shortest distance considering the wrap-around
    double distance = rawDistance % cards.length;

    if (distance > cards.length / 2) {
      distance -= cards.length;
    } else if (distance <= -cards.length / 2) {
      distance += cards.length;
    }
    return distance;
  }
}
