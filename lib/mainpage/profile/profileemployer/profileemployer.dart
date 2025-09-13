import 'package:anjalim/mainpage/Premiumemployer/premiumemployerpage.dart';
import 'package:anjalim/mainpage/profile/profileemployer/cubit/profileemployer_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../Loginpage/cubit/login_cubit.dart';
import '../../Loginpage/registerpageog.dart';
import '../../dashborad/dashborad.dart';
import '../../datapage/datapage.dart';
import '../../registerpage/loginpageog.dart';
import '../Planusage/planusage.dart';
import '../companyinfo/companyinfo.dart';
import 'cubit2/forget_cubit.dart';

class Profileemployer extends StatelessWidget {
  const Profileemployer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return MultiBlocProvider(
  providers: [
    BlocProvider(
  create: (context) => ProfileemployerCubit(),
),
    BlocProvider(
      create: (context) => LoginCubit(),
    ),
    BlocProvider(
      create: (context) => ForgetCubit(),
    ),
  ],
  child: BlocBuilder<ProfileemployerCubit, ProfileemployerState>(
  builder: (context, state) {
    final cubit = context.read<ProfileemployerCubit>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF9F2ED),
         body: Padding(
           padding: EdgeInsets.symmetric(horizontal: width * 0.075), // 7.5% of screen width
           child: RefreshIndicator(
             backgroundColor: Color(0xffFFFFFF),
             color: Color(0xff000000),
             onRefresh: () async {
               await context.read<ProfileemployerCubit>()..getcompanyinfo();
             },
             child: SingleChildScrollView(
               physics: AlwaysScrollableScrollPhysics(),
               child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   SizedBox(height: height * 0.02), // roughly 15px on a 750px screen

                   Row(
                     children: [
                       buildFieldTitle(title: "Profile",  context: context),
                     ],
                   ),
                   SizedBox(height: height * 0.014), // ≈ 11px on an 800px screen

                   Container(
                     width: width * 0.33,
                     height: width * 0.33,
                     decoration: BoxDecoration(
                       shape: BoxShape.circle,
                       color: const Color(0xff004673),
                       border: Border.all(
                         color: const Color(0xffFFFFFF),
                         width: width * 0.009,           // ✅ You can adjust the thickness here
                       ),
                     ),
                     child: ClipOval(
                       child: cubit.networkImage != null
                           ? Image.network(cubit.networkImage!, fit: BoxFit.cover)
                      : Icon(
                         Icons.person,
                         size: 48, // set your desired size
                         color: Colors.grey, // optional color
                       )  ),
                   ),
                   SizedBox(height: height * 0.01875), // 15 is ~1.875% of 800px height

                   buildprofile(context: context, text: "Company Info", leadingIcon: Icons.work_outline,color: Color(0xff000000), callback: () {
                     Navigator.pushNamed(context, "Companyinfo");
                     // Navigator.push(context, MaterialPageRoute(builder: (context) => Companyinfo(),));

                   }, bottomRight: width * 0.042, bottomLeft: width * 0.042, topRight: width * 0.042, topLeft: width * 0.042),
                   SizedBox(height: height * 0.03125), // 25 is ~3.125% of 800px



                   buildprofile(context: context, text: "Plan Usage", leadingIcon: Icons.speed,color: Color(0xffEB8125), callback: () {
                     Navigator.pushNamed(context,'Planusagenew' );
                     // Navigator.push(context, MaterialPageRoute(builder: (context) => Planusagenew(),));

                   },  topRight: width * 0.042, topLeft: width * 0.042),
                   buildprofile(context: context, text: "Premium ", leadingIcon: Icons.emoji_events  ,color: Color(0xff004673), callback: () {
                     Navigator.pushNamed(context,'Premiumemployerpage' );
                     // Navigator.push(context, MaterialPageRoute(builder: (context) => Premiumemployerpage(),));

                   }, bottomRight: width * 0.042, bottomLeft: width * 0.042),

                   SizedBox(height: height * 0.03125), // 25 is ~3.125% of 800px

                   buildprofile(context: context, text: "Log out", leadingIcon: Icons.logout,color: Color(0xff000000),
                       callback: () async {
                         final shouldLogout = await showDialog<bool>(
                           context: context,
                           builder: (context) => AlertDialog(
                             elevation: 3,
                             backgroundColor: CupertinoColors.white,
                             title: const Text("Log Out"),
                             content: const Text("Are you sure you want to log out?"),
                             actions: [
                               TextButton(
                                 onPressed: () => Navigator.pop(context, false),
                                 child: const Text("Cancel"),
                               ),
                               TextButton(
                                 onPressed: () => Navigator.pop(context, true),
                                 child: const Text("Log Out"),
                               ),
                             ],
                           ),
                         );

                         if (shouldLogout != true) return; // cancel pressed

                         // Proceed to log out
                         final token = await ApiConstantsemployer.getTokenOnly();
                         // final token2 = await ApiConstants.getTokenOnly2();

                         const FlutterSecureStorage storage = FlutterSecureStorage();
                         await storage.delete(key: 'access_token');
                         // await storage.delete(key: 'token_local');
                         await storage.deleteAll();

                         // print("🧹 Access token deleted. Logging out...");

                         if (token != null) {
                           context.read<LoginCubit>().signOut();
                           Navigator.pushReplacementNamed(context,'OptionScreen' );
                           // Navigator.pushReplacement(
                           //   context,
                           //   MaterialPageRoute(builder: (_) => Registerpage()),
                           // );
                         }
                         // else if (token2 != null) {
                         //   Navigator.pushNamed(context,'Registerpage' );
                         //
                         //   // Navigator.pushReplacement(
                         //   //   context,
                         //   //   MaterialPageRoute(builder: (_) => Registerpage()),
                         //   // );
                         // }
                         else {
                           // print("yes");
                         }
                       },
                       topRight: width * 0.042, topLeft: width * 0.042
                   ),
                   BlocListener<ForgetCubit, ForgetState>(
                     listener: (context, state) {
                       if (state is ForgetIoaded) {
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(

                               content: Text(state.message),
                               backgroundColor: Colors.green),
                         );
                       } else if (state is ForgetError) {
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text(state.error), backgroundColor: Colors.red),
                         );
                       }
                     },
                  child: buildprofile(context: context, text: "Password ", leadingIcon: Icons.lock_reset,color: Color(0xffEB8125),
                    callback: () async {
                      const storage = FlutterSecureStorage();
                      final email = await storage.read(key: 'user_email');

                      if (email != null && email.isNotEmpty) {
                        // Ask for confirmation first
                        final shouldSend = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: Color(0xffFFFFFF),

                            title: const Text("Confirm"),
                            content: Text("Do you want to send a password reset link to:\n\n$email ?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text("Send"),
                              ),
                            ],
                          ),
                        );

                        // If user confirmed
                        if (shouldSend == true) {
                          // Show loading dialog
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const AlertDialog(
                              backgroundColor: Color(0xffFFFFFF),

                              content: Row(
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(width: 16),
                                  Text("Sending reset link..."),
                                ],
                              ),
                            ),
                          );

                          // Trigger password reset
                          await context.read<ForgetCubit>().resetPassword(email: email);

                          // Close loading
                          Navigator.of(context).pop();

                          // Show success message
                          // showDialog(
                          //   context: context,
                          //   builder: (_) => AlertDialog(
                          //     backgroundColor: Color(0xffFFFFFF),
                          //     title: const Text("📩 Email Sent"),
                          //     content: Text("A reset link was sent to:\n\n$email"),
                          //     actions: [
                          //       TextButton(
                          //         onPressed: () => Navigator.of(context).pop(),
                          //         child: const Text("OK"),
                          //       ),
                          //     ],
                          //   ),
                          // );
                        }

                      } else {
                        // Email not found
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: Color(0xffFFFFFF),

                            title: const Text("❌ Error"),
                            content: const Text("Email not found in secure storage."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Close"),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                       bottomRight: width * 0.042, bottomLeft: width * 0.042,
                   ),

             ),
                    SizedBox(height: height * 0.0975), // 30 is ~3.75% of 800px
                   Center(
                     child: GestureDetector(
                       onTap: () => cubit.openUrl("https://studentsgigs.com/termscondition"),
                       child: Text(
                         "Terms & Conditions",
                         style: TextStyle(
                           fontFamily: 'Sen',
                           letterSpacing: 0.7,

                           fontWeight: FontWeight.w900,
                           fontSize: width * 0.03,
                           color: Color(0xffEB8125),
                           // clickable look
                         ),
                       ),
                     ),
                   ),
                    SizedBox(height: height * 0.006375), // roughly 6px on a 750px screen
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       GestureDetector(
                         onTap: () => cubit.openUrl("https://studentsgigs.com/privacypolicy"),
                         child: Text(
                           "Privacy Policy",
                           style: TextStyle(
                             fontFamily: 'Sen',
                             fontSize: width * 0.03,

                             letterSpacing: 0.7,
                             fontWeight: FontWeight.w900,
                             color: Color(0xffEB8125), // clickable look
                           ),
                         ),
                       ),
                       SizedBox(width: width * 0.052), // spacing between texts
                       GestureDetector(
                         onTap: () => cubit.openUrl("https://studentsgigs.com/refundpolicy"),
                         child: Text(
                           "Refund Policy",
                           style: TextStyle(
                             fontFamily: 'Sen',
                             letterSpacing: 0.7,

                             fontWeight: FontWeight.w900,
                             fontSize: width * 0.03,
                             color: Color(0xffEB8125), // clickable look

                           ),
                         ),
                       ),
                     ],
                   ),// roughly 15px on a 750px screen


                 ],
               ),
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
Widget buildFieldTitle({required BuildContext context ,String ? title, double ? width}) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  return Padding(
    padding: EdgeInsets.symmetric(vertical: height * 0.00625), // 5 is ~0.625% of 800px
    child: Text(
      title!,
      style: TextStyle(
        fontFamily: 'Sora',
        fontWeight: FontWeight.w600,
        fontSize: width * 0.04,
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
  Color ? color

}) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  return InkWell(
    onTap: callback,
    child: Material(
      elevation: 2,
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(bottomRight ?? 0.0),
        bottomLeft: Radius.circular(bottomLeft ?? 0.0),
        topRight: Radius.circular(topRight ?? 0.0),
        topLeft: Radius.circular(topLeft ?? 0.0),
      ),
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
              child: Icon(leadingIcon, size: width * 0.064,color: color), // 24/375 ≈ 0.064
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
    ),
  );
}


