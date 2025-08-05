import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../../Loginpage/registerpageog.dart';
import '../../Onboardprofile/onboardprofile4/model/model.dart';
import '../../Onboardprofile/onboardprofile4/onboardprofile4.dart';
import '../../dashborad/dashborad.dart';
import '../../datapage/datapage.dart';

part 'loginpag_state.dart';

class LoginpagCubit extends Cubit<LoginpagState> {
  LoginpagCubit() : super(LoginpagInitial());
  final String baseurl = ApiConstants.baseUrl;
  static const _storage = FlutterSecureStorage();

  String? user;

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  static const String userType = "employer";

  Future<void> loginUser(
      BuildContext context, String name, String password) async {
    emit(LoginpagIoading());

    try {
      final response = await http.post(
        Uri.parse('https://server.studentsgigs.com/api/employer/api/token/'),
        body: {
          'username': name,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['access']; // or data['refresh'] if needed

        // ✅ Save token securely
        await secureStorage.write(key: 'token_local', value: token);
        await _storage.write(key: 'user_type', value: userType);

        if (token!.isNotEmpty) {
          getcompanyinfo(context);
        } else {
          Navigator.pushNamed(context, 'GoogleSignInPage');
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (context) => GoogleSignInPage()));
        }

        emit(LoginpagIoaded());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Check Password"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );

        emit(Loginpagerror("Invalid credentials"));
      }
    } catch (e) {
      emit(Loginpagerror("Something went wrong: $e"));
    }
  }

  Future<void> getcompanyinfo(BuildContext context) async {
    await Future.delayed(
        const Duration(milliseconds: 3000)); // ⏳ 2-second delay

    final token = await ApiConstants.getTokenOnly(); // ✅ get actual token
    final token2 = await ApiConstants.getTokenOnly2(); // ✅ get actual token

    final url = "$baseurl/api/employer/employer-info/";
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer ${token ?? token2}',
      'Content-Type': 'application/json',
    });
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      final data = compantonboardingFromJson(response.body);

      final email = data.employer!.user!.email;
      await _storage.write(key: 'user_email', value: email);

      if ((data.employer?.companyName ?? "").isNotEmpty) {
        // Navigate to dashboard if company name is empty
        Navigator.pushReplacementNamed(context, 'Dashborad');
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
    } else {}
  }
}
