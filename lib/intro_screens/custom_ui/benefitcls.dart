import 'package:flutter/material.dart';

class BenefitRow extends StatelessWidget {
  final Widget leading; // Accepts Icon or CircleAvatar
  final String title;
  final String subtitle;

  const BenefitRow({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start, // Align elements properly
        children: [
          leading, // Can be an Icon or CircleAvatar
          SizedBox(width: 10),
          Expanded(
            // Ensures text wraps properly
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18, // Adjusted size
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                Text(
                  textAlign: TextAlign.start,
                  subtitle,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  softWrap: true, // Ensures wrapping
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
