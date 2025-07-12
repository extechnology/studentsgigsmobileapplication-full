import 'package:anjalim/mainpage/Premiumemployer/premiumemployerpage.dart';
import 'package:anjalim/mainpage/profile/profileemployer/cubit/profileemployer_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Planusage/Model/model.dart';
import '../../Planusage/planusage.dart';
import '../companyinfo/companyinfo.dart';

class Profileemployer extends StatelessWidget {
  const Profileemployer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocProvider(
  create: (context) => ProfileemployerCubit(),
  child: BlocBuilder<ProfileemployerCubit, ProfileemployerState>(
  builder: (context, state) {
    final cubit = context.read<ProfileemployerCubit>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF9F2ED),
         body: Padding(
           padding:  EdgeInsets.symmetric(horizontal: 30.0),
           child: SingleChildScrollView(
             child: Column(
               children: [
                 SizedBox(height: 15,),
      
                 Row(
                   children: [
                     buildFieldTitle("Profile", width),
                   ],
                 ),
                 SizedBox(height: 11,),

                 Container(
                   width: width * 0.35,
                   height: width * 0.35,
                   decoration: BoxDecoration(
                     shape: BoxShape.circle,
                     color: const Color(0xff004673),
                   ),
                   child: ClipOval(
                     child: cubit.networkImage != null
                         ? Image.network(cubit.networkImage!, fit: BoxFit.cover)
                         : Image.asset("assets/images/others/Group 69.png", fit: BoxFit.contain),
                   ),
                 ),
                 SizedBox(height: 15,),
             
                 buildprofile(context: context, text: "Company Info", leadingIcon: Icons.work_outline, callback: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => Companyinfo(),));

                 }, bottomRight: width * 0.042, bottomLeft: width * 0.042, topRight: width * 0.042, topLeft: width * 0.042),
                 SizedBox(height: 25,),
      
                 buildprofile(context: context, text: "DashBoard", leadingIcon: Icons.apps, callback: () {
             
                 },  topRight: width * 0.042, topLeft: width * 0.042),
                 buildprofile(context: context, text: "Payment Method", leadingIcon: Icons.import_contacts_sharp, callback: () {
             
                 }, bottomRight: width * 0.042, bottomLeft: width * 0.042, ),
      
                 SizedBox(height: 25,),
      
                 buildprofile(context: context, text: "Plan Usage", leadingIcon: Icons.speed, callback: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => Planusagenew(),));

                 },  topRight: width * 0.042, topLeft: width * 0.042),
                 buildprofile(context: context, text: "Premium ", leadingIcon: Icons.emoji_events  , callback: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => Premiumemployerpage(),));

                 }, ),
                 buildprofile(context: context, text: "Settings ", leadingIcon: Icons.import_contacts_sharp, callback: () {
             
                 }, bottomRight: width * 0.042, bottomLeft: width * 0.042, ),
                 SizedBox(height: 25,),
      
                 buildprofile(context: context, text: "Log out", leadingIcon: Icons.logout, callback: () {
             
                 }, bottomRight: width * 0.042, bottomLeft: width * 0.042, topRight: width * 0.042, topLeft: width * 0.042),
                 SizedBox(height: 25,),
      
      
             
               ],
             ),
           ),
         ),
      ),
    );
  },
),
);
  }
}
Widget buildFieldTitle(String title, double width) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Text(
      title,
      style: TextStyle(
        fontFamily: 'Sora',
        fontWeight: FontWeight.w600,
        fontSize: width * 0.045,
      ),
    ),
  );
}
Widget buildprofile({
  required BuildContext context,
  required String text,
  required IconData leadingIcon,
  required VoidCallback callback,
   double ? bottomRight,
   double ? bottomLeft,
   double ? topRight,
   double ? topLeft,

}) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  return InkWell(
    onTap: callback,
    child: Container(
      width: width * 0.91, // 341/375 ≈ 0.91
      height: height * 0.082, // 67/812 ≈ 0.082
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(bottomRight ?? 0.0),
          bottomLeft: Radius.circular(bottomLeft ?? 0.0),
          topRight: Radius.circular(topRight ?? 0.0),
          topLeft: Radius.circular(topLeft ?? 0.0),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: width * 0.032),  // 12/375 ≈ 0.032
          Container(
            width: width * 0.11,           // 41/375 ≈ 0.11
            height: height * 0.050,        // 41/812 ≈ 0.050
            child: Icon(leadingIcon, size: width * 0.064), // 24/375 ≈ 0.064
          ),
          SizedBox(width: width * 0.032),  // 12/375 ≈ 0.032

          Container(
            width: width * 0.40,           // 150/375 ≈ 0.40
            height: height * 0.050,        // 41/812 ≈ 0.050
            child: Center(
              child: Row(
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: Color(0xff32343E),
                      fontFamily: 'Sen',
                      fontWeight: FontWeight.w400,
                      fontSize: width * 0.042, // 16/375 ≈ 0.042
                      height: 1.0,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: width * 0.192),   // 72/375 ≈ 0.192
          Container(
            width: width * 0.069,           // 26/375 ≈ 0.069
            height: height * 0.050,         // 41/812 ≈ 0.050
            child: Icon(Icons.keyboard_arrow_right, size: width * 0.064,color: Color(0xff747783),),
          ),
        ],
      ),
    ),
  );
}


