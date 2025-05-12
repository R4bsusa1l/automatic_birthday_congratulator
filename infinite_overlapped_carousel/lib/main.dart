import 'package:flutter/material.dart';
import 'dart:math';
import 'infinite_overlapped_carousel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Infinite Overlapped Carousel'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
          height: min(screenWidth / 3.3 * (16 / 9), screenHeight * .9),
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
