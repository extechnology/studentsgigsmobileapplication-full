import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';

import '../../Onboardprofile/onboardprofile4/model/model.dart';
import '../../datapage/datapage.dart';

part 'phone_state.dart';

class PhoneCubit extends Cubit<PhoneState> {
  PhoneCubit() : super(PhoneInitial());
  late StreamSubscription<InternetStatus> _connectionSubscription;
  bool isConnected = true;
  void _monitorConnection() async {
    // Immediate check on start
    isConnected = await InternetConnection().hasInternetAccess;
    if (!isConnected) {
      emit(PhoneInitial());
    }

    // Listen for future changes
    _connectionSubscription =
        InternetConnection().onStatusChange.listen((status) {
      isConnected = (status == InternetStatus.connected);
      if (!isConnected) {
        emit(PhoneInitial());
      }
    });
  }

  final String baseurl = ApiConstantsemployer.baseUrl;
  static const _storage = FlutterSecureStorage();

  String? user;

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  static const String userType = "employer";

  /// Send OTP to mobile number
  Future<void> sendOtp(String mobile) async {
    emit(PhoneLoading());
    final url =
        Uri.parse("https://server.studentsgigs.com/api/employer/send-sms-otp/");

    try {
      // 👉 Remove "+" if present
      final cleanMobile = mobile.startsWith("+") ? mobile.substring(1) : mobile;

      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
        },
        body: {
          "mobile": cleanMobile, // ✅ send cleaned number
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == "success") {
          final otp = data["otp"];
          emit(PhoneOtpSent(otp: otp));
          // print("✅ OTP sent to $cleanMobile");
        } else {
          emit(PhoneError("Failed to send OTP"));
          // print("❌ OTP send failed: ${data.toString()}");
        }
      } else {
        emit(PhoneError("Error: ${response.statusCode}"));
        // print("❌ Backend error: ${response.statusCode}");
      }
    } catch (e) {
      emit(PhoneError("Exception: $e"));
      // print("❌ Exception: $e");
    }
  }

  /// Verify OTP
  Future<void> verifyOtp(
      BuildContext context, String mobile, String otp) async {
    emit(PhoneLoading());
    final url = Uri.parse(
        "https://server.studentsgigs.com/api/employer/verify-sms-otp/");

    try {
      // 👉 Remove "+" if present
      final cleanMobile = mobile.startsWith("+") ? mobile.substring(1) : mobile;

      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
        },
        body: {
          "mobile": cleanMobile, // ✅ send cleaned mobile
          "otp": otp,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access']; // or data['refresh'] if needed
        // print(token);
        // ✅ Save token securely
        await secureStorage.write(key: 'access_token', value: token);
        await _storage.write(key: 'user_type', value: userType);

        if (token!.isNotEmpty) {
          getcompanyinfo(context);
        } else {
          Navigator.pop(context); // ✅ Close the loading dialog

          Navigator.pushNamed(context, 'GoogleSignInPage');
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (context) => GoogleSignInPage()));
        }

        emit(PhoneVerifed2());
      } else {
        emit(PhoneError("Invalid OTP"));
      }
    } catch (e) {
      _monitorConnection();
      Navigator.pop(context); // ✅ Close the loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: isConnected
              ? Text("Something went wrong: ")
              : Text(
                  "Oops! We couldn’t load right now. \n Please check your network availability."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      emit(PhoneError("Something went wrong: $e"));
    }

    //     if (data.containsKey("access") && data.containsKey("refresh")) {
    //       final accessToken = data["access"];
    //       final refreshToken = data["refresh"];
    //       emit(PhoneVerified(accessToken: accessToken, refreshToken: refreshToken));
    //
    //       print("✅ Mobile: $cleanMobile");
    //       print("✅ OTP: $otp");
    //       print("✅ Access: $accessToken");
    //     } else {
    //       emit(PhoneError("OTP verification failed"));
    //       print("❌ OTP verification failed (no tokens returned)");
    //     }
    //   } else {
    //     emit(PhoneError("Error: ${response.statusCode}"));
    //     print("❌ Backend error: ${response.statusCode}");
    //     print("Mobile: $cleanMobile | OTP: $otp");
    //   }
    // } catch (e) {
    //   emit(PhoneError("Exception: $e"));
    //   print("❌ Exception: $e");
    // }
  }

  Future<void> getcompanyinfo(BuildContext context) async {
    await Future.delayed(
        const Duration(milliseconds: 3000)); // ⏳ 2-second delay

    final token =
        await ApiConstantsemployer.getTokenOnly(); // ✅ get actual token
    // final token2 = await ApiConstantsemployer.getTokenOnly2(); // ✅ get actual token

    final url = "$baseurl/api/employer/employer-info/";
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer ${token}',
      'Content-Type': 'application/json',
    });
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      final data = compantonboardingFromJson(response.body);
      // print(data);

      // print(token2);
      final email = data.employer!.user!.email;
      await _storage.write(key: 'user_email', value: email);

      if ((data.employer?.companyName ?? "").isNotEmpty) {
        // Navigate to dashboard if company name is empty
        Navigator.pop(context); // ✅ Close the loading dialog

        Navigator.pushReplacementNamed(context, 'Dashborad');
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => Dashborad()),
        // );
      } else {
        Navigator.pop(context); // ✅ Close the loading dialog

        Navigator.pushReplacementNamed(context, 'OnboardProfiles');

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
    } else {
      // print("Something Wrong");
    }
  }
}
