import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onDateSelected; // Add this callback

  const CalendarInputField({
    super.key,
    required this.controller,
    this.hintText = 'Select a date',
    this.onDateSelected,
    bool? enabled, // Add this parameter
  });

  @override
  _CalendarInputFieldState createState() => _CalendarInputFieldState();
}

class _CalendarInputFieldState extends State<CalendarInputField> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      widget.controller.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      readOnly: true,
      onTap: () => _selectDate(context),
    );
  }
}
