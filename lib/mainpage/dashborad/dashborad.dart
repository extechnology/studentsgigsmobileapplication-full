import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../homepageifdatalocation/component/homepagetextformdatahave/homepagetextformdatahave.dart';
import '../homepageifdatalocation/homepageifdatalocation.dart';
import '../postedsisg/postedgigs.dart';
import '../postyourjob/postyourjob/postyourjob.dart';
import '../profile/profileemployer/profileemployer.dart';

class Dashborad extends StatefulWidget {
  final String ? initialSearchText;

  const Dashborad({super.key,  this.initialSearchText });

  @override
  State<Dashborad> createState() => _DashboradState();
}

class _DashboradState extends State<Dashborad> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          color: Colors.white,
          height: 70,
          child: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: "Home"),
              Tab(icon: Icon(Icons.work_outline ), text: "Posted"),
              Tab(icon: Icon(Icons.add), text: "Post Job"),
              Tab(icon: Icon(Icons.person), text: "Profile"),

            ],
            unselectedLabelColor: Colors.black,
            labelColor: Color(0xffEB8125),
            indicatorColor: Colors.transparent,
          ),
        ),
        body: TabBarView(
          children: [
            (widget.initialSearchText == null || widget.initialSearchText!.trim().isEmpty)
                ? const Homepageifdatalocation()
                : Homepagetextformdatahave(
              searchText: widget.initialSearchText!.trim(),
            ),
            Postedgigs(),
            Postyourjob(),
            Profileemployer(),
          ],
        ),
      ),
    );

  }
}
