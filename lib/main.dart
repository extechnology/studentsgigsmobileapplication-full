import 'package:anjalim/intro_screens/onboarding_Screens/onboardingscreen1.dart';
import 'package:anjalim/intro_screens/onboarding_Screens/onboardingscreen2.dart';
import 'package:anjalim/intro_screens/optionscreen.dart';
import 'package:anjalim/intro_screens/splash/splashscreen.dart';
import 'package:anjalim/intro_screens/welcomescreen.dart';
import 'package:anjalim/student_Section/authentication/login/loginpage.dart';
import 'package:anjalim/student_Section/authentication/registration/std_Registration/registration_screen.dart';
import 'package:anjalim/student_Section/services/profile_update_searvices/experience_functions.dart';
import 'package:anjalim/student_Section/services/singlesearch.dart';
import 'package:anjalim/student_Section/student_Screens/gigsdetail.dart';
import 'package:anjalim/student_Section/student_Screens/home_Screens/std_Searchscreens/SearchScreen1.dart';
import 'package:anjalim/student_Section/student_Screens/home_Screens/std_Searchscreens/searchscreen2.dart';
import 'package:anjalim/student_Section/student_Screens/home_Screens/student_Homescreens.dart';
import 'package:anjalim/student_Section/student_Screens/profile_Screens/Experience.dart/experience.dart';
import 'package:anjalim/student_Section/student_Screens/profile_Screens/Experience.dart/experience_show.dart';
import 'package:anjalim/student_Section/student_Screens/profile_Screens/additional_info.dart';
import 'package:anjalim/student_Section/student_Screens/profile_Screens/categoriesed.dart';
import 'package:anjalim/student_Section/student_Screens/profile_Screens/education_Details_Ui/educationalInfo.dart';
import 'package:anjalim/student_Section/student_Screens/profile_Screens/education_Details_Ui/educationalInformationAdd.dart';
import 'package:anjalim/student_Section/student_Screens/profile_Screens/language.dart';
import 'package:anjalim/student_Section/student_Screens/profile_Screens/premiumscreen.dart';
import 'package:anjalim/student_Section/student_Screens/profile_Screens/softSkill.dart';
import 'package:anjalim/student_Section/student_Screens/profile_Screens/technicalSkill.dart';
import 'package:anjalim/student_Section/student_Screens/profile_Screens/updateprofile.dart';
import 'package:anjalim/student_Section/student_Screens/profile_Screens/userplan.dart';
import 'package:anjalim/student_Section/student_Screens/profile_Screens/workPreference.dart';
import 'package:anjalim/student_Section/student_blocs/search/search_bloc.dart';
import 'package:anjalim/student_Section/student_blocs/std_wrk_experience/experience_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // ⬅️ Required for GlobalXxxLocalizations
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
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<SearchBloc>(
            create: (context) => SearchBloc(SearchService()),
          ),
          BlocProvider(
            create: (context) => ExperienceBloc(ExperienceService()),
          )
        ],
        child: const MyApp(),
      ),
    );
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
        "StudentHomeScreens": (context) => const StudentHomeScreens(),
        "SearchScreen1": (context) => SearchScreen1(),
        "SearchScreen2": (context) => const SearchScreen2(),
        "GigsDetailScreen": (context) => const GigsDetailScreen(),
        "ProfileEditScreen": (context) => const ProfileEditScreen(),
        "WorkPreference": (context) => StudentWorkPreference(),
        "CategoryDropdownFormField": (context) => CategoryDropdownFormField(),
        "Technicalskill": (context) => const Technicalskill(),
        "LanguageDropdown": (context) => LanguageDropdown(),
        "SoftSkillScreen": (context) => const SoftSkillScreen(),
        "EducationalInfoSection": (context) => const EducationAddPage(),
        "EducationPage": (context) => const EducationPage(),
        "ExperinceScreen": (context) => const ExperinceScreen(),
        "ShowExperience": (context) => const ShowExperience(),
        "PremiumPlansScreen": (context) => PremiumPlansScreen(),
        "PlanUsagePage": (context) => const PlanUsagePage(),
        "AdditionalInformationScreen": (context) =>
            const AdditionalInformationScreen(),
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
