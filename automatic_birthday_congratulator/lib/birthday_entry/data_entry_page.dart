import 'package:automatic_birthday_congratulator/birthday_entry/display_birthday_messages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:automatic_birthday_congratulator/birthday_entry/enter_birthdate.dart';
import '../app_state.dart';

class DataEntryPage extends StatefulWidget {
  @override
  State<DataEntryPage> createState() => _DataEntryPageState();
}

class _DataEntryPageState extends State<DataEntryPage> {
  bool useInputDatePicker = false;

  static const WidgetStateProperty<Icon> thumbIcon =
      WidgetStateProperty<Icon>.fromMap(<WidgetStatesConstraint, Icon>{
        WidgetState.selected: Icon(Icons.check),
        WidgetState.any: Icon(Icons.close),
      });

  bool useTextForChooseAllCustomBirthdayMessages = false;

  Color getColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.pressed,
      WidgetState.hovered,
      WidgetState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.cyan;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyAppState>(context);
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.person),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter name of recipient',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.cake),
                SizedBox(width: 10),
                Flexible(
                  fit: FlexFit.loose,
                  child: Expanded(
                    child:
                        useInputDatePicker
                            ? InputDatePickerBirthdate()
                            : DatePickerBirthdate(),
                  ),
                ),
                Switch(
                  thumbIcon: thumbIcon,
                  value: useInputDatePicker,
                  activeColor: Colors.red,
                  onChanged: (bool value) {
                    setState(() {
                      useInputDatePicker = value;
                    });
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.message),
                              SizedBox(width: 10),
                              Expanded(
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.contact_page,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        // Add your onPressed functionality here
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Expanded(child: SizedBox()),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 5,
                  fit: FlexFit.loose,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        useTextForChooseAllCustomBirthdayMessages
                            ? DisplayBirthdayMessages(appState: appState)
                            : DataTableSelectMessage(appState: appState),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
