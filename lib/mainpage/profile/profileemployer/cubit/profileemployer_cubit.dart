import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../dashborad/dashborad.dart';
import '../../../datapage/datapage.dart';
import '../../../registerpage/loginpageog.dart';
import '../../companyinfo/model/model.dart';

part 'profileemployer_state.dart';

class ProfileemployerCubit extends Cubit<ProfileemployerState> {
  ProfileemployerCubit() : super(ProfileemployerInitial()){
    Future.delayed(Duration(milliseconds: 3000), () {
      getcompanyinfo();
    });
  }

  File? selectedImage;
  String? networkImage;

  final String baseurl = ApiConstantsemployer.baseUrl;

  Future<void> getcompanyinfo() async {
    final token = await ApiConstantsemployer.getTokenOnly(); // ✅ get actual token
    // final token2 = await ApiConstants.getTokenOnly2(); // ✅ get actual token

    final url = "$baseurl/api/employer/employer-info/";
    final response = await http.get(Uri.parse(url),headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',

    });
    if(response.statusCode >= 200 && response.statusCode <= 299){
      print(response.statusCode);

      final data = getcompanyinfoFromJson(response.body);
      print(data);
      // profilecompanyname.text = data.employer.companyName;
      // profileemail.text = data.employer.email;
      // profilecompanyinfo.text = data.employer.companyInfo;
      // profilephone.text = data.employer.phoneNumber;
      // profilestreet.text = data.employer.streetAddress;
      // profilepostcode.text = data.employer.postalCode;
      networkImage = data.employer.logo;
      // selectedCountry = data.employer.country
      //     .replaceAll(RegExp(r'[^\x00-\x7F]'), '') // Remove emojis
      //     .trim();
      //
      // selectedState = data.employer.state.replaceAll('"', '').trim();
      // selectedCity = data.employer.city.replaceAll('"', '').trim();
      // print("hey moji");
      // print("networkurl$networkImage");

      print(networkImage);

      emit(ProfileemployerInitial());
      Future.delayed(Duration(milliseconds: 5000), () {
        // Trigger a fake user interaction
        emit(ProfileemployerInitial()); // Ensure rebuild (if needed)
      });

    }else {
      print("Something Wrong");
    }

  }
   getToken(BuildContext context) async {
    final token = await ApiConstantsemployer.getTokenOnly();    // Await the future properly
    // final tokens = await ApiConstants.getTokenOnly2();  // Await the second token as well

    if (token != null && token.isNotEmpty ) {
      Navigator.pushNamed(context, 'Dashborad');

      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => Dashborad()),
      // );
    } else {
      Navigator.pushNamed(context, 'Registerpage');

      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => Registerpage()),
      // );
    }
  }

}
