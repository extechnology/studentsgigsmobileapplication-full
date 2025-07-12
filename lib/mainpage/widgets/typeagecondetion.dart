import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MinAgeField extends StatefulWidget {
  final TextEditingController controller;
  final int minAge;
  final String labelText;
  final String ? hinttext;
  final String ? firsttext;

  final String? initialValue;
  final void Function(String)? onChanged;

  const MinAgeField({
    super.key,
    required this.controller,
    this.minAge = 14,
    this.labelText = "Minimum Age",
    this.initialValue,
    this.onChanged, this.hinttext, this.firsttext,
  });

  @override
  State<MinAgeField> createState() => _MinAgeFieldState();
}

class _MinAgeFieldState extends State<MinAgeField> {
  String? _errorText;
  final GlobalKey _fieldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      widget.controller.text = widget.initialValue!;
      _validate(widget.initialValue!);
    }
  }

  void _validate(String value) {
    if (value.isEmpty) {
      setState(() {
        _errorText = widget.firsttext ?? "Enter Your Age";
      });
      return;
    }

    final number = int.tryParse(value);
    if (number == null) {
      setState(() {
        _errorText = 'Invalid number';
      });
    } else if (number < widget.minAge) {
      setState(() {
        _errorText = 'Value must be greater than ${widget.minAge}.';
      });
    } else {
      setState(() {
        _errorText = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final isSmall = height < 650;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              key: _fieldKey,
              height: isSmall ? 48 : 56,
              child: TextField(
                controller: widget.controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  _validate(value);
                  widget.onChanged?.call(value);
                },
                style: TextStyle(fontSize: isSmall ? 14 : 16),
                decoration: InputDecoration(
                  border: InputBorder.none,


                  hintText: widget.hinttext ?? 'Enter number',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: isSmall ? 10 : 14,
                  ),
                ),
              ),
            ),
            if (_errorText != null)
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 18, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorText!,
                        style: TextStyle(
                          color: Colors.orange.shade900,
                          fontSize: isSmall ? 11.5 : 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
