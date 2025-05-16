import 'package:flutter/cupertino.dart';
class CardModel {
  final int id;
  final Widget child;
  double zIndex = 0.0;
  double wrappedDistance = 0.0; // Added this line

  CardModel({required this.id, required this.child});
}