import 'dart:async';
import 'package:flutter/material.dart';

class OtpCountdownText extends StatefulWidget {
  final int startSeconds; // e.g. 600 for 10 min
  const OtpCountdownText({super.key, this.startSeconds = 600});

  @override
  State<OtpCountdownText> createState() => _OtpCountdownTextState();
}

class _OtpCountdownTextState extends State<OtpCountdownText> {
  late int _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.startSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining > 0) {
        setState(() => _remaining--);
      } else {
        t.cancel();
      }
    });
  }

  String _format(int sec) {
    final m = (sec ~/ 60).toString().padLeft(2, '0');
    final s = (sec % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: "Poppins",
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        children: [
          const TextSpan(text: "OTP Expires In "),
          TextSpan(
            text: _format(_remaining),
            style: const TextStyle(
              color: Colors.red, // countdown in red
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
