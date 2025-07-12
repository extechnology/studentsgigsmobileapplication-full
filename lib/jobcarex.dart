import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NumberCheckerPage extends StatefulWidget {
  const NumberCheckerPage({super.key});

  @override
  State<NumberCheckerPage> createState() => _NumberCheckerPageState();
}

class _NumberCheckerPageState extends State<NumberCheckerPage> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      final input = _controller.text;

      setState(() {
        if (input.isEmpty) {
          _result = '';
        } else if (double.tryParse(input) != null) {
          _result = "✅ It's a number: $input";
        } else {
          _result = "❌ Not a number: $input";
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF0FF),
      appBar: AppBar(title: const Text("Number Checker")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Enter something",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _result,
              style: TextStyle(
                fontSize: 18,
                color: _result.startsWith("✅") ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}