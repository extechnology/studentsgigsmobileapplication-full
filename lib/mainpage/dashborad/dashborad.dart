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
  late String? searchText;
  @override
  void initState() {
    super.initState();
    searchText = widget.initialSearchText;
  }

  void resetSearch() {
    setState(() {
      searchText = null;
    });
  }
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Color(0xffF9F2ED),
        bottomNavigationBar: Container(
          color: Color(0xffF9F2ED),
          height:  screenHeight * 0.085 + bottomPadding,

          child:  TabBar(
            onTap: (index) {
              if (index == 0) {
                // Home tab clicked, reset the search and show default homepage
                resetSearch();
              }
            },
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
            (searchText == null || searchText!.trim().isEmpty)
                ? const Homepageifdatalocation()
                : Homepagetextformdatahave(
              searchText: searchText!.trim(),
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
