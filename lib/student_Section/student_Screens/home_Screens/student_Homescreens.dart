import 'package:anjalim/student_Section/student_Screens/home_Screens/homepage.dart';
import 'package:anjalim/student_Section/student_Screens/home_Screens/profilescreen.dart';
import 'package:anjalim/student_Section/student_Screens/home_Screens/saved_JobScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentHomeScreens extends StatefulWidget {
  const StudentHomeScreens({super.key});

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<StudentHomeScreens>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Widget> _screens = [
    const EmployeeHome(),
    const EmployeeHome(),
    //SearchScreen1(),
    const SavedJobScreen(),

    const ProfileScreen(),
  ];

  final List<Tab> _tabs = [
    const Tab(icon: Icon(Icons.home_outlined)),
    const Tab(icon: Icon(CupertinoIcons.search)),
    const Tab(icon: Icon(Icons.bookmark_border_rounded)),
    const Tab(icon: Icon(Icons.person_2_outlined)),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _screens.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: const Color(0xffF9F2ED),
        child: TabBar(
          controller: _tabController,
          isScrollable: false, // Changed to false for even spacing
          indicatorColor: Colors.transparent, // Hide the underline
          labelColor: const Color(0xffEB8125),
          unselectedLabelColor: const Color(0xff4d4747),
          indicatorSize: TabBarIndicatorSize.tab,
          labelPadding: const EdgeInsets.symmetric(
              horizontal: 20.0), // Add spacing between icons
          tabs: _tabs,
        ),
      ),
    );
  }
}
