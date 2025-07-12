import 'package:anjalim/tas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // ⬅️ Required for GlobalXxxLocalizations
import 'jobcarex.dart';
import 'mainpage/Loginpage/loginpage.dart';
import 'mainpage/Onboardprofile/dashboardsearch/dashboardsearch.dart';
import 'mainpage/Onboardprofile/onboardprofile4/onboardprofile4.dart';
import 'mainpage/Onboardprofile/searchpage/searchpage.dart';
import 'mainpage/Planusage/planusage.dart';
import 'mainpage/Premiumemployer/premiumemployerpage.dart';
import 'mainpage/customtextfom.dart';
import 'mainpage/dashborad/dashborad.dart';
import 'mainpage/demo.dart';
import 'mainpage/homepageifdatalocation/component/homepagetextformdatahave/homepagetextformdatahave.dart';
import 'mainpage/homepageifdatalocation/component/searchlistapi/searchlistapi.dart';
import 'mainpage/homepageifdatalocation/homepageifdatalocation.dart';
import 'mainpage/homescreen.dart';
import 'mainpage/jobcart/jobcart.dart';
import 'mainpage/mainpage.dart';
import 'mainpage/postedsisg/components/postjobgigsdetailpage/postjobgigsdetailpage.dart';
import 'mainpage/postedsisg/postedgigs.dart';
import 'mainpage/postyourjob/postyourjob/cubit/postyourjob_cubit.dart';
import 'mainpage/postyourjob/postyourjob/postyourjob.dart';
import 'mainpage/profile/companyinfo/companyinfo.dart';
import 'mainpage/profile/profileemployer/profileemployer.dart';
import 'mainpage/razerpaydemo/razerpay.dart';
import 'textformcustom/onboardprofile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        FlutterQuillLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // Add more locales if needed
      ],
      home: GoogleSignInPage(),

    );
  }
}


