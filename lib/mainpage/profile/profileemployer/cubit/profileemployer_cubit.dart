import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

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

  final String baseurl = "https://server.studentsgigs.com";
  final String bearerToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUyMjMyNzgwLCJpYXQiOjE3NTE2Mjc5ODAsImp0aSI6IjQzOTRkYjgyMmRlOTQ0YjJhM2ZjNzMzMjFiMDM4ZTc0IiwidXNlcl9pZCI6OTN9.XjfCED0nFwJPmaxOQUToaE49IPDTrhrLfezxdi-wWBU";

  Future<void> getcompanyinfo() async {
    final url = "$baseurl/api/employer/employer-info/";
    final response = await http.get(Uri.parse(url),headers: {
      'Authorization': 'Bearer $bearerToken',
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


      emit(ProfileemployerInitial());
      Future.delayed(Duration(milliseconds: 5000), () {
        // Trigger a fake user interaction
        emit(ProfileemployerInitial()); // Ensure rebuild (if needed)
      });

    }else {
      print("Something Wrong");
    }

  }

}
