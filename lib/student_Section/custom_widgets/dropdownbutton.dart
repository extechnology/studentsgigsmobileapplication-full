import 'package:flutter/material.dart';

DropdownButtonFormField<String> buildDropdownButtonFormField({
  required String? value,
  required List<DropdownMenuItem<String>> items,
  required String labelText,
  required Function(String?) onChanged,
  required String? Function(String?) validator,
}) {
  // Remove duplicate items and ensure unique values
  final uniqueItems = <String, DropdownMenuItem<String>>{};
  for (final item in items) {
    if (item.value != null) {
      uniqueItems[item.value!] = item;
    }
  }
  final cleanedItems = uniqueItems.values.toList();

  // Check if the current value exists in the cleaned items
  final validValue =
      cleanedItems.any((item) => item.value == value) ? value : null;

  return DropdownButtonFormField<String>(
    value: validValue,
    decoration: InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    items: cleanedItems,
    onChanged: onChanged,
    validator: validator,
    isExpanded: true, // Prevents overflow for long text
    dropdownColor: Colors.white,
    style: const TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
  );
}

// Alternative: Helper function to create dropdown items safely
List<DropdownMenuItem<String>> createDropdownItems(List<String> options) {
  // Remove duplicates and create items
  final uniqueOptions = options.toSet().toList();

  return uniqueOptions.map((String option) {
    return DropdownMenuItem<String>(
      value: option,
      child: Text(
        option,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }).toList();
}

// Example usage function
class DropdownExample extends StatefulWidget {
  const DropdownExample({super.key});

  @override
  _DropdownExampleState createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
  String? selectedSkill;

  // Example list with potential duplicates
  final List<String> skillOptions = [
    'POWERPOINT TEMPLATE DESIGNER',
    'GRAPHIC DESIGNER',
    'WEB DEVELOPER',
    'POWERPOINT TEMPLATE DESIGNER', // Duplicate - will be removed
    'CONTENT WRITER',
    'UI/UX DESIGNER',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dropdown Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildDropdownButtonFormField(
              value: selectedSkill,
              items: createDropdownItems(skillOptions),
              labelText: 'Select Skill',
              onChanged: (String? newValue) {
                setState(() {
                  selectedSkill = newValue;
                });
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a skill';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Method 2: Direct implementation
            DropdownButtonFormField<String>(
              value: selectedSkill,
              decoration: InputDecoration(
                labelText: 'Select Skill (Direct)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: skillOptions.toSet().map((String skill) {
                return DropdownMenuItem<String>(
                  value: skill,
                  child: Text(skill),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSkill = newValue;
                });
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a skill';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            if (selectedSkill != null)
              Text(
                'Selected: $selectedSkill',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
