library;

import 'dart:ui';
import 'package:flutter/material.dart';

import 'card.dart';

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
    final double verticalBasePosition = (verticalCenter - centerWidgetHeight) / 8;

    final double factor = 4.75;    // make smaller for steeper incline


    if (distance == 0) {
      return (
        left : basePosition,
        bottom : verticalBasePosition,
      );
    } else if (distance.abs() > 0.0 && distance.abs() <= 1.0) {
      if (distance > 0) {
        return (
          left : basePosition - nearWidgetWidth * distance.abs(),
          bottom : verticalBasePosition + ((centerWidgetHeight / factor) * (distance.abs()))
        );
      } else {
        return (
          left : maxWidth - (basePosition - nearWidgetWidth * distance.abs()) - nearWidgetWidth -16,
          bottom : verticalBasePosition + ((centerWidgetHeight / factor) * (distance.abs()))
        );
      }
    } else if (distance.abs() >= 1.0 && distance.abs() <= 2.0) {
      if (distance > 0) {
        return (
          left : basePosition - nearWidgetWidth -
              (nearWidgetWidth - farWidgetWidth) * (distance.abs() - 1),
          bottom : verticalBasePosition + ((centerWidgetHeight / factor) * (distance.abs()))
        );
      } else {
        return (
          left : maxWidth - (basePosition - nearWidgetWidth - (nearWidgetWidth - farWidgetWidth) * (distance.abs() - 1)) - farWidgetWidth - 16,
          bottom : verticalBasePosition + ((centerWidgetHeight / factor) * (distance.abs()))
        );
      }
    } else if (distance.abs() > 2.0 && distance.abs() <= 3.0) {
      if (distance > 0) {
        return (
          left: basePosition - nearWidgetWidth + (farBackWidgetWidth - centerBackWidgetWidth) * (distance.abs() - 2),
          bottom: verticalBasePosition + ((centerWidgetHeight / factor) * (distance.abs()))
        );
      } else {
        return (
          left: maxWidth - (basePosition - nearWidgetWidth + (farWidgetWidth - nearBackWidgetWidth) * (distance.abs() - 2)) - nearBackWidgetWidth - 16,
          bottom: verticalBasePosition + ((centerWidgetHeight / factor) * (distance.abs()))
        );
      }
    } else if (distance.abs() > 3.0 && distance.abs() <= 4.0){
      if (distance > 0){
        return (
          left: basePosition - nearWidgetWidth + (nearWidgetWidth / 2) * (distance.abs() - 3),
          bottom: verticalBasePosition + ((centerWidgetHeight / factor) * (distance.abs()))
        );
      }else{
        return (
          left: maxWidth - (basePosition - nearWidgetWidth + (nearWidgetWidth / 2) * (distance.abs() - 3)) - farWidgetWidth - 16,
          bottom: verticalBasePosition + ((centerWidgetHeight / factor) * (distance.abs()))
        );
      }
    }else{
        if (distance > 0){
          return (
            left: basePosition + ((centerWidgetWidth - farWidgetWidth) / 2) * (distance.abs() - 4),
            bottom: verticalBasePosition + ((centerWidgetHeight / factor) * (distance.abs()))
          );
        }else{
          return (
            left: maxWidth - (basePosition + ((centerWidgetWidth - farWidgetWidth) / 2) * (distance.abs() - 4)) - farWidgetWidth - 16,
            bottom: verticalBasePosition + ((centerWidgetHeight / factor) * (distance.abs()))
          );
        }
    }
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

  final double absDistance = distance.abs(); // Use the absolute shortest distance

  if (absDistance >= 0.0 && absDistance < 1.0) {
    return centerWidgetWidth -
        (centerWidgetWidth - nearWidgetWidth) * (absDistance - absDistance.floor());
  } else if (absDistance >= 1.0 && absDistance < 2.0) {
    return nearWidgetWidth -
        (nearWidgetWidth - farWidgetWidth) * (absDistance - absDistance.floor());
  } else {
    return farWidgetWidth;
  }
}

  Widget _buildItem(CardModel item) {
    final int index = item.id;
    final width = getCardWidth(index);
    final height = maxHeight - 20 * (getCircularDistance(index)).abs();
    final position = getCardPosition(index);
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

      widgets[i].wrappedDistance = distance.abs(); // Store the wrapped absolute distance

      if (widgets[i].id == centerIndex.round()) { // Use rounded centerIndex for comparison
        widgets[i].zIndex = widgets.length.toDouble() - widgets[i].wrappedDistance;
      } else {
        widgets[i].zIndex = widgets.length.toDouble() - widgets[i].wrappedDistance - 1;
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

  double getCircularDistance(int index){
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
