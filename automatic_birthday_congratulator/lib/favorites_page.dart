import "package:flutter/material.dart";
import 'dart:math';
import 'infi_overl_car/infinite_overlapped_carousel.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  //Generate a list of widgets. You can use another way
  List<Widget> widgets = List.generate(
    10,
    (index) => ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      child: Image.asset(
        'assets/images/$index.jpg', //Images stored in assets folder
        fit: BoxFit.fill,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blue,
      //Wrap with Center to place the carousel center of the screen
      body: Center(
        //Wrap the OverlappedCarousel widget with SizedBox to fix a height. No need to specify width.
        child: SizedBox(
          height:
              screenHeight, //min(screenWidth / 3.3 * (16 / 9), screenHeight),
          width: screenWidth,
          child: InfiniteOverlappedCarousel(
            widgets: widgets, //List of widgets
            currentIndex: widgets.length ~/ 2, //Current index of the carousel
            onClicked: (index) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("You clicked at $index")));
            },
            obscure: 0.4,
            skewAngle: 0.1,
          ),
        ),
      ),
    );
  }
}
