import 'package:flutter/material.dart';
import 'package:automatic_birthday_congratulator/database.dart';
import '../app_state.dart';
import 'package:provider/provider.dart';

class DisplayBirthdayMessages extends StatefulWidget {
  final MyAppState appState;
  DisplayBirthdayMessages({required this.appState});
  @override
  State<DisplayBirthdayMessages> createState() =>
      _DisplayBirthdayMessagesState();
}

class _DisplayBirthdayMessagesState extends State<DisplayBirthdayMessages> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> birthdayMessages = [];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyAppState>(context);
    final birthdayMessages = appState.messages;

    return birthdayMessages.isEmpty
        ? Center(child: Text('No birthday messages found'))
        : ListView.builder(
          itemCount: birthdayMessages.length,
          itemBuilder: (context, index) {
            final message = birthdayMessages[index];
            return ListTile(
              title: Text(message['messageid'].toString()),
              subtitle: Text(message['birthdaymessage']),
            );
          },
        );
  }
}

class DataTableSelectMessage extends StatefulWidget {
  final MyAppState appState;
  const DataTableSelectMessage({super.key, required this.appState});

  @override
  State<DataTableSelectMessage> createState() => _DataTableSelectMessageState();
}

class _DataTableSelectMessageState extends State<DataTableSelectMessage> {
  static const int numItems = 20; //getAllMessages().Length;
  List<bool> selected = List<bool>.generate(numItems, (int index) => false);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columns: const <DataColumn>[DataColumn(label: Text('Number'))],
        rows: List<DataRow>.generate(
          numItems, //itterate through all messages
          (int index) => DataRow(
            //by index which can be used to get the message
            color: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              // All rows will have the same selected color.
              if (states.contains(WidgetState.selected)) {
                return Theme.of(context).colorScheme.primary.withOpacity(0.08);
              }
              // Even rows will have a grey color.
              if (index.isEven) {
                return Colors.grey..withOpacity(0.3);
              }
              return null; // Use default value for other states and odd rows.
            }),
            cells: <DataCell>[DataCell(Text('Row $index'))],
            selected: selected[index],
            onSelectChanged: (bool? value) {
              setState(() {
                selected[index] = value!;
                //change
              });
            },
          ),
        ),
      ),
    );
  }
}
