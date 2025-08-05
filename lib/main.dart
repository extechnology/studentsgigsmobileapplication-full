import 'package:anjalim/intro_screens/onboarding_Screens/onboardingscreen1.dart';
import 'package:anjalim/intro_screens/onboarding_Screens/onboardingscreen2.dart';
import 'package:anjalim/intro_screens/optionscreen.dart';
import 'package:anjalim/intro_screens/splash/splashscreen.dart';
import 'package:anjalim/intro_screens/welcomescreen.dart';
import 'package:anjalim/student_Section/authentication/login/loginpage.dart';
import 'package:anjalim/student_Section/authentication/registration/std_Registration/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // ⬅️ Required for GlobalXxxLocalizations
import 'intro_screens/onboarding_Screens/onboardingscreen1.dart';
import 'intro_screens/onboarding_Screens/onboardingscreen2.dart';
import 'intro_screens/optionscreen.dart';
import 'mainpage/Loginpage/registerpageog.dart';
import 'mainpage/Onboardprofile/onboardprofile4/onboardprofile4.dart';
import 'mainpage/Premiumemployer/premiumemployerpage.dart';
import 'mainpage/dashborad/dashborad.dart';
import 'mainpage/homepageifdatalocation/component/searchlistapi/searchlistapi.dart';
import 'mainpage/homepageifdatalocation/homepageifdatalocation.dart';
import 'mainpage/postedsisg/postedgigs.dart';
import 'mainpage/profile/Planusage/planusage.dart';
import 'mainpage/profile/companyinfo/companyinfo.dart';
import 'mainpage/profile/profileemployer/profileemployer.dart';
import 'mainpage/registerpage/loginpageog.dart';
import 'mainpage/spashscreen/spashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Allow only portrait mode
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        "Dashborad": (context) => const Dashborad(),
        "Homepageifdatalocation": (context) => const Homepageifdatalocation(),
        "Searchlistapi": (context) => const Searchlistapi(),
        "GoogleSignInPage": (context) => const GoogleSignInPage(),
        "OnboardProfiles": (context) => const OnboardProfiles(),
        "Postedgigs": (context) => const Postedgigs(),
        "Premiumemployerpage": (context) => Premiumemployerpage(),
        "Profileemployer": (context) => const Profileemployer(),
        "Planusagenew": (context) => const Planusagenew(),
        "Companyinfo": (context) => const Companyinfo(),
        "Registerpage": (context) => const Registerpage(),
        "Spashscreen": (context) => const Spashscreen(),
        "WelcomeScreen": (context) => const Welcomescreen(),
        "OptionScreen": (context) => const OptionScreen(),
        "OnboardingScreen1": (context) => const OnboardingScreen1(),
        "OnboardingScreen2": (context) => const OnboardingScreen2(),
        "LoginPage": (context) => LoginPage(),
        "RegisterPage": (context) => RegisterPage(),
      },
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
      home: const SplashScreen(),
    );
  }
}
