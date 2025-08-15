import 'package:flutter/material.dart';

Widget buildDropdownbuttonFormField({
  required String? value,
  required List<DropdownMenuItem<String>> items,
  required ValueChanged<String?> onChanged,
  required String labeltext,
  required String? Function(String?) validator,
}) {
  return DropdownButtonFormField<String>(
    value: value,
    items: items,
    onChanged: onChanged,
    validator: validator,
    isExpanded: true,
    decoration: InputDecoration(
      labelText: labeltext,
      hintText: value ?? 'Select $labeltext',
      labelStyle: const TextStyle(fontFamily: "Poppins"),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    ),
  );
}
