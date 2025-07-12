import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xffEB8125),
                    Color(0xffc55a5f),
                    Color(0xff004673)
                  ],
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcIn,
              child: Text(
                "Unlock Your Full Potential With Premium",
                style: TextStyle(fontFamily: "Poppins",
                    fontSize: 24, fontWeight: FontWeight.w700, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
