import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../homepagetextformdatahave/model2/modelforserch.dart';

class Homepagedetailpage2 extends StatelessWidget {
  const Homepagedetailpage2({super.key, required this.data});
  final Datum data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(
              data.profile.profilePic ??
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGEZghB-stFaphAohNqDAhEaXOWQJ9XvHKJw&s",
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text("User ID: ${data.user}"),
            Text("Name: ${data.name}"),
            Text("Job Title: ${data.jobTitle}"),
            Text("Location: ${data.preferredWorkLocation}"),
          ],
        ),
      ),
    );

  }
}
