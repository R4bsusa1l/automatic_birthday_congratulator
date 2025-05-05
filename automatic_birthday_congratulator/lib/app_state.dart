import 'package:flutter/material.dart';

import 'package:automatic_birthday_congratulator/database.dart';

class MyAppState extends ChangeNotifier {
  void getNext() {
    notifyListeners();
  }

  bool useTextForChooseAllCustomBirthdayMessages = false;

  void changeTextForChooseAllCustomBirthdayMessages(boolValue) {
    useTextForChooseAllCustomBirthdayMessages = boolValue;
    notifyListeners();
  }

  var currentDatePickerSwitchState = false;

  void changeDatePickerSwitchState(boolValue) {
    currentDatePickerSwitchState = boolValue;
    notifyListeners();
  }

  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> messages = [];

  Future<void> loadBirthdayMessages() async {
    messages = await dbHelper.fetchAllData("SELECT * FROM birthday_messages");
    notifyListeners();
  }

  var birthdayMessages = <Map<String, dynamic>>[];

  var currentColorScheme = ColorScheme.fromSeed(seedColor: Colors.deepOrange);

  void changeColorScheme(chosenColorScheme) {
    currentColorScheme = chosenColorScheme;
    notifyListeners();
  }
}
