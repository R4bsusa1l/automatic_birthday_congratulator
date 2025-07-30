import "package:flutter/material.dart";
import 'dart:math';
import 'infi_overl_car/infinite_overlapped_carousel.dart';
import 'package:automatic_birthday_congratulator/app_state.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<HomePage> {
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
    var appState = Provider.of<MyAppState>(context);

    //final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: appState.currentColorScheme.primaryFixed,
      //Wrap with Center to place the carousel center of the screen
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Wrap the OverlappedCarousel widget with SizedBox to fix a height. No need to specify width.
            SizedBox(
              height: min(screenWidth / 3.3 * (16 / 9), screenHeight * .9),
              child: InfiniteOverlappedCarousel(
                widgets: widgets, //List of widgets
                currentIndex:
                    widgets.length ~/ 2, //Current index of the carousel
                onClicked: (index) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("You clicked at $index")),
                  );
                },
                obscure: 0.4,
                skewAngle: 0.1,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.thumb_up),
                  label: Text('Like'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("You clicked next")));
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
