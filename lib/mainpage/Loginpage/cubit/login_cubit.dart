import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import '../../Onboardprofile/onboardprofile4/model/model.dart';
import '../../Onboardprofile/onboardprofile4/onboardprofile4.dart';
import '../../dashborad/dashborad.dart';
import '../../datapage/datapage.dart';
import '../../registerpage/loginpageog.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  final String baseurl = ApiConstants.baseUrl;

  String ? user;
  static const _storage = FlutterSecureStorage();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: '15124092057-q7saopofjt97svqnsd47t12n7ckn29qi.apps.googleusercontent.com',
  );



  // static const _storage = FlutterSecureStorage();
  static const String userType = "employer";

  Future<void> signIn(BuildContext context) async {
    emit(LoginIoading());

    try {
      print("🚫1. Starting Google Sign-In for userType: $userType");
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(LoginInitial()); // user canceled
        return;
      }

      print("🚫2. Getting authentication");
      final googleAuth = await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception("Google token missing");
      }

      print("🚫3. Calling backend API with userType: $userType");
      final response = await http.post(
        Uri.parse("https://server.studentsgigs.com/api/employer/api/google-auth/"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "id_token": googleAuth.idToken,
          "email": googleUser.email,
          "username": googleUser.displayName ?? "",
          "access_token": googleAuth.accessToken,
        }),
      );

      print("🚫4. Response status: ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("🚫Response Body: $data");
        await _storage.write(key: 'auth_token', value: data['token']);
        await _storage.write(key: 'access_token', value: data['access']);
        await _storage.write(key: 'refresh_token', value: data['refresh_token']);
        await _storage.write(key: 'user_type', value: userType);
        await _storage.write(key: 'user_email', value: googleUser.email);

        // if (context.mounted) {
        //   _navigateBasedOnUserType(context, userType);
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //       content: Text('Successfully signed in!'),
        //       backgroundColor: Colors.green,
        //     ),
        //   );
        // }

        emit(LoginIoaded(
          name: googleUser.displayName ?? '',
          email: googleUser.email,
        ));
        getcompanyinfo(context);
      } else {
        emit(LoginError('Server error: ${response.body}'));
      }
    } catch (e) {
      print("🚫 Authentication error: $e");
      emit(LoginError('Login failed: ${e.toString()}'));
    }
  }

  // void _navigateBasedOnUserType(
  //     BuildContext context, String userType)
  // {
  //   switch (userType.toLowerCase()) {
  //     case 'student':
  //       Navigator.push(context, MaterialPageRoute(builder: (context) => Registerpage(),));
  //       break;
  //     case 'employer':
  //       Navigator.push(context, MaterialPageRoute(builder: (context) => OnboardProfiles(),));
  //       break;
  //     // case 'admin':
  //     //   Navigator.of(context).pushReplacementNamed("AdminDashboard");
  //     //   break;
  //     // default:
  //     //   Navigator.of(context).pushReplacementNamed("OptionScreen");
  //     //   break;
  //   }
  // }
  Future<void> getcompanyinfo(BuildContext context) async {
    final token = await ApiConstants.getTokenOnly(); //  get actual token
    final token2 = await ApiConstants.getTokenOnly2(); //  get actual token

    final url = "$baseurl/api/employer/employer-info/";
    final response = await http.get(Uri.parse(url),headers: {
      'Authorization': 'Bearer ${token ?? token2}',
      'Content-Type': 'application/json',

    });
    if(response.statusCode >= 200 && response.statusCode <= 299){
      final data = compantonboardingFromJson(response.body);
      print(data);

      if ((data.employer?.companyName ?? "").isNotEmpty) {
        // Navigate to dashboard if company name is empty
        Navigator.pushNamed(context, 'Dashborad');
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => Dashborad()),
        // );
      } else {
        Navigator.pushNamed(context, 'OnboardProfiles');

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => OnboardProfiles()),
        // );
      }
      // profileemail.text = data.employer.email!;
      // profilecompanyinfo.text = data.employer.companyInfo!;
      // profilephone.text = data.employer.phoneNumber!;
      // profilestreet.text = data.employer.streetAddress!;
      // profilepostcode.text = data.employer.postalCode!;
      // countryController.text = data.employer.country?.label ?? "";
      //
      //
      // stateController.text = cleanValue(data.employer.state);
      // cityController.text = cleanValue(data.employer.city);
      // print("hey moji");
      user = data.employer!.id.toString();

      // print("networkurl$networkImage");


      // emit(CompanyinfoInitial());
      // Future.delayed(Duration(milliseconds: 5000), () {
      //   // Trigger a fake user interaction
      //   emit(CompanyinfoInitial()); // Ensure rebuild (if needed)
      // });

    }else {
      print("Something Wrong");
    }

  }


  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _storage.deleteAll();    // delete all secure tokens

    emit(LoginInitial());
  }
}
