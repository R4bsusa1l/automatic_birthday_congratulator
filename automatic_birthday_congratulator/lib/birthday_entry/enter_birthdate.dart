import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerBirthdate extends StatefulWidget {
  const DatePickerBirthdate({super.key});

  @override
  State<DatePickerBirthdate> createState() => _DatePickerBirthdateState();
}

class _DatePickerBirthdateState extends State<DatePickerBirthdate> {
  DateTime? selectedDate;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  Future<void> _selectDate() async {
    DateTime initialDateTime = DateTime.now(); // Example date
    String formattedInitialDate = _dateFormat.format(initialDateTime);
    DateTime parsedInitialDate = _dateFormat.parse(formattedInitialDate);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: parsedInitialDate,
      firstDate: DateTime.utc(1900),
      lastDate: DateTime.utc(2100),
      initialDatePickerMode: DatePickerMode.year,
    );

    setState(() {
      selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 20,
        children: <Widget>[
          OutlinedButton(
            onPressed: _selectDate,
            child: const Text('Select Date'),
          ),
          Text(
            selectedDate != null
                ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                : 'No date selected',
          ),
        ],
      ),
    );
  }
}

class InputDatePickerBirthdate extends StatefulWidget {
  const InputDatePickerBirthdate({super.key});

  @override
  State<InputDatePickerBirthdate> createState() =>
      _InputDatePickerBirthdateState();
}

class _InputDatePickerBirthdateState extends State<InputDatePickerBirthdate> {
  DateTime? selectedDate;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    // Creating the initial date and formatting it.
    DateTime initialDateTime = DateTime.now(); // Example date
    String formattedInitialDate = _dateFormat.format(initialDateTime);
    DateTime parsedInitialDate = _dateFormat.parse(formattedInitialDate);
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: InputDatePickerFormField(
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              initialDate: parsedInitialDate,
              onDateSubmitted: (DateTime date) {
                setState(() {
                  selectedDate = date;
                });
              },
              onDateSaved: (DateTime date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              selectedDate != null
                  ? 'Selected date: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}'
                  : 'No date selected',
            ),
          ),
        ],
      ),
    );
  }
}
