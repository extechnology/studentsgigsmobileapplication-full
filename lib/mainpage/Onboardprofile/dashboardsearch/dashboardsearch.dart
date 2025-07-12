import 'package:flutter/material.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer({super.key});

  @override
  Widget build(BuildContext context) {
    // MediaQuery for responsive sizing
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth * 0.9; // 90% of screen width
    double iconSize = screenWidth * 0.06; // 6% of screen width
    double fontSize = screenWidth * 0.045; // 4.5% of screen width

    return Scaffold(
      body: Center(
        child: Container(
          width: containerWidth,
          padding: EdgeInsets.all(screenWidth * 0.03),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Job Title / Keyword field
              InkWell(
                onTap: () {

                },
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey, size: iconSize),
                      SizedBox(width: screenWidth * 0.02),
                      Text("Job title, keywords, or company")
                    ],
                  ),
                ),
              ),
              Divider(),
              // Location field
              InkWell(
                onTap: () {

                },
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey, size: iconSize),
                      SizedBox(width: screenWidth * 0.02),
                      Text("Location")
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
