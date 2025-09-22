import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:emoji_flag_converter/emoji_flag_converter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../dashborad/dashborad.dart';
import '../../../datapage/datapage.dart';
import '../../../postedsisg/model/model.dart' as onboard;
import '../model/model.dart'as posted;

part 'onboardprofile4_state.dart';

class Onboardprofile4Cubit extends Cubit<Onboardprofile4State> {
  Onboardprofile4Cubit() : super(Onboardprofile4Initial());
  String selectedCountryCode = "+91"; // Default value

  TextEditingController onboardingcompanyname = TextEditingController();
  TextEditingController onboardingemail = TextEditingController();
  TextEditingController onboardingcompanyinfo = TextEditingController();
  TextEditingController onboardingphone = TextEditingController();
  TextEditingController onboardingstreet = TextEditingController();
  TextEditingController onboardingpostcode = TextEditingController();
  posted.Country? selectedCountry;
  String? selectedState;
  String? selectedCity;
  final String baseurl = ApiConstantsemployer.baseUrl;

  String ? user;

  File? selectedImage;

  final secureStorage = FlutterSecureStorage();

  Future<void> pickImageFromGallery() async {
    try {
      final returned = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (returned != null) {
        selectedImage = File(returned.path);
      }

      emit(Onboardprofile4Initial());
    } catch (e) {
      emit(Onboardprofile4Initial());
    }
  }
  Map<String, String> countryNameToCode = {
    'Aruba': 'AW',
    'Afghanistan': 'AF',
    'Angola': 'AO',
    'Anguilla': 'AI',
    'Åland Islands': 'AX',
    'Albania': 'AL',
    'Andorra': 'AD',
    'United Arab Emirates': 'AE',
    'Argentina': 'AR',
    'Armenia': 'AM',
    'American Samoa': 'AS',
    'Antarctica': 'AQ',
    'French Southern Territories': 'TF',
    'Antigua and Barbuda': 'AG',
    'Australia': 'AU',
    'Austria': 'AT',
    'Azerbaijan': 'AZ',
    'Burundi': 'BI',
    'Belgium': 'BE',
    'Benin': 'BJ',
    'Bonaire, Sint Eustatius and Saba': 'BQ',
    'Burkina Faso': 'BF',
    'Bangladesh': 'BD',
    'Bulgaria': 'BG',
    'Bahrain': 'BH',
    'Bahamas': 'BS',
    'Bosnia and Herzegovina': 'BA',
    'Saint Barthélemy': 'BL',
    'Belarus': 'BY',
    'Belize': 'BZ',
    'Bermuda': 'BM',
    'Bolivia, Plurinational State of': 'BO',
    'Brazil': 'BR',
    'Barbados': 'BB',
    'Brunei Darussalam': 'BN',
    'Bhutan': 'BT',
    'Bouvet Island': 'BV',
    'Botswana': 'BW',
    'Central African Republic': 'CF',
    'Canada': 'CA',
    'Cocos (Keeling) Islands': 'CC',
    'Switzerland': 'CH',
    'Chile': 'CL',
    'China': 'CN',
    'Côte d\'Ivoire': 'CI',
    'Cameroon': 'CM',
    'Congo, The Democratic Republic of the': 'CD',
    'Congo': 'CG',
    'Cook Islands': 'CK',
    'Colombia': 'CO',
    'Comoros': 'KM',
    'Cabo Verde': 'CV',
    'Costa Rica': 'CR',
    'Cuba': 'CU',
    'Curaçao': 'CW',
    'Christmas Island': 'CX',
    'Cayman Islands': 'KY',
    'Cyprus': 'CY',
    'Czechia': 'CZ',
    'Germany': 'DE',
    'Djibouti': 'DJ',
    'Dominica': 'DM',
    'Denmark': 'DK',
    'Dominican Republic': 'DO',
    'Algeria': 'DZ',
    'Ecuador': 'EC',
    'Egypt': 'EG',
    'Eritrea': 'ER',
    'Western Sahara': 'EH',
    'Spain': 'ES',
    'Estonia': 'EE',
    'Ethiopia': 'ET',
    'Finland': 'FI',
    'Fiji': 'FJ',
    'Falkland Islands (Malvinas)': 'FK',
    'France': 'FR',
    'Faroe Islands': 'FO',
    'Micronesia, Federated States of': 'FM',
    'Gabon': 'GA',
    'United Kingdom': 'GB',
    'Georgia': 'GE',
    'Guernsey': 'GG',
    'Ghana': 'GH',
    'Gibraltar': 'GI',
    'Guinea': 'GN',
    'Guadeloupe': 'GP',
    'Gambia': 'GM',
    'Guinea-Bissau': 'GW',
    'Equatorial Guinea': 'GQ',
    'Greece': 'GR',
    'Grenada': 'GD',
    'Greenland': 'GL',
    'Guatemala': 'GT',
    'French Guiana': 'GF',
    'Guam': 'GU',
    'Guyana': 'GY',
    'Hong Kong': 'HK',
    'Honduras': 'HN',
    'Croatia': 'HR',
    'Haiti': 'HT',
    'Hungary': 'HU',
    'Indonesia': 'ID',
    'India': 'IN',
    'Ireland': 'IE',
    'Iran, Islamic Republic of': 'IR',
    'Iraq': 'IQ',
    'Iceland': 'IS',
    'Israel': 'IL',
    'Italy': 'IT',
    'Jamaica': 'JM',
    'Japan': 'JP',
    'Jordan': 'JO',
    'Kazakhstan': 'KZ',
    'Kenya': 'KE',
    'Kuwait': 'KW',
    'Kyrgyzstan': 'KG',
    'Cambodia': 'KH',
    'Kiribati': 'KI',
    'Korea, Republic of': 'KR',
    'Lao People\'s Democratic Republic': 'LA',
    'Lebanon': 'LB',
    'Liberia': 'LR',
    'Libya': 'LY',
    'Liechtenstein': 'LI',
    'Lithuania': 'LT',
    'Luxembourg': 'LU',
    'Latvia': 'LV',
    'Macao': 'MO',
    'North Macedonia': 'MK',
    'Madagascar': 'MG',
    'Malawi': 'MW',
    'Malaysia': 'MY',
    'Maldives': 'MV',
    'Mali': 'ML',
    'Malta': 'MT',
    'Mexico': 'MX',
    'Moldova, Republic of': 'MD',
    'Monaco': 'MC',
    'Mongolia': 'MN',
    'Montenegro': 'ME',
    'Morocco': 'MA',
    'Mozambique': 'MZ',
    'Myanmar': 'MM',
    'Namibia': 'NA',
    'Nepal': 'NP',
    'Netherlands': 'NL',
    'New Zealand': 'NZ',
    'Nicaragua': 'NI',
    'Niger': 'NE',
    'Nigeria': 'NG',
    'Norway': 'NO',
    'Oman': 'OM',
    'Pakistan': 'PK',
    'Panama': 'PA',
    'Paraguay': 'PY',
    'Peru': 'PE',
    'Philippines': 'PH',
    'Poland': 'PL',
    'Portugal': 'PT',
    'Qatar': 'QA',
    'Romania': 'RO',
    'Russia': 'RU',
    'Rwanda': 'RW',
    'Saudi Arabia': 'SA',
    'Senegal': 'SN',
    'Serbia': 'RS',
    'Singapore': 'SG',
    'Slovakia': 'SK',
    'Slovenia': 'SI',
    'Somalia': 'SO',
    'South Africa': 'ZA',
    'South Korea': 'KR',
    'South Sudan': 'SS',
    'Sri Lanka': 'LK',
    'Sudan': 'SD',
    'Suriname': 'SR',
    'Sweden': 'SE',
    'Switzerland': 'CH',
    'Syrian Arab Republic': 'SY',
    'Tajikistan': 'TJ',
    'Tanzania, United Republic of': 'TZ',
    'Thailand': 'TH',
    'Togo': 'TG',
    'Trinidad and Tobago': 'TT',
    'Tunisia': 'TN',
    'Turkey': 'TR',
    'Turkmenistan': 'TM',
    'Uganda': 'UG',
    'Ukraine': 'UA',
    'United States': 'US',
    'Uruguay': 'UY',
    'Uzbekistan': 'UZ',
    'Venezuela, Bolivarian Republic of': 'VE',
    'Viet Nam': 'VN',
    'Yemen': 'YE',
    'Zambia': 'ZM',
    'Zimbabwe': 'ZW',
  };
  bool isCategoryValid = true;
  bool isValid = true;

  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  TextEditingController profilecompanyname = TextEditingController();
  TextEditingController profileemail = TextEditingController();
  TextEditingController profilecompanyinfo = TextEditingController();
  TextEditingController profilephone = TextEditingController();
  TextEditingController profilestreet = TextEditingController();
  TextEditingController profilepostcode = TextEditingController();

  Future<void> updateEmployerProfile( BuildContext context ,{
    required GlobalKey email,
    required GlobalKey companyname,
    required GlobalKey location,


  })
  async {
    isValid = true;
    GlobalKey? firstInvalidKey;

    if (profilecompanyname.text.trim().isEmpty) {
      isValid = false;
      firstInvalidKey ??= companyname;
    }

    if (profileemail.text.trim().isEmpty) {
      isValid = false;
      firstInvalidKey ??= email;
    }

    if (stateController.text.trim().isEmpty) {
      isValid = false;
      firstInvalidKey ??= location;
    }

    if (!isValid) {
      emit(Onboardprofile4Initial());
      scrollToField(firstInvalidKey!);
      return;
    }


    // print("Function is working");
    // print("Function is working $user");

    try {
      final token = await ApiConstantsemployer.getTokenOnly(); // ✅ get actual token
      // final token2 = await ApiConstants.getTokenOnly2(); // ✅ get actual token

      var uri = Uri.parse('$baseurl/api/employer/employer-info/?pk=$user');

      var request = http.MultipartRequest('PUT', uri);
      final countryName = countryController.text.trim();
      final alpha2Code = countryNameToCode[countryName] ?? "";


      // Pass your Bearer token here
      request.headers['Authorization'] = 'Bearer $token';

      // Form fields (update as per your form inputs)
      request.fields['company_name'] = profilecompanyname.text.trim();
      request.fields['company_info'] = profilecompanyinfo.text.trim();
      request.fields['email'] = profileemail.text.trim();
      request.fields['phone_number'] = '$selectedCountryCode${profilephone.text.trim()}';
      request.fields['street_address'] = profilestreet.text.trim();
      request.fields['state'] = stateController.text.trim();  // ✅ FIXED
      request.fields['city'] = cityController.text.trim();    // ✅ FIXED
      request.fields['postal_code'] = profilepostcode.text.trim();
      request.fields['country'] = jsonEncode({
        "value": alpha2Code,
        "label": countryName,
        "flag": EmojiConverter.fromAlpha2CountryCode(alpha2Code) ?? ""
      });
      // Handle optional image upload
      if (selectedImage != null) {
        final photoFile = await http.MultipartFile.fromPath(
          'logo',  // <-- this must match your backend field name for image
          selectedImage!.path,
          contentType: MediaType('image', 'jpeg'), // or MediaType('image', 'png') based on your image type
        );
        request.files.add(photoFile);
      }

      // Send request
      final response = await request.send();

      // Process response
      final responseBody = await response.stream.bytesToString();
      final data = json.decode(responseBody);
      // print(response.statusCode);
      if (response.statusCode == 200) {
        // print(response.statusCode);
        //
        // print("Profile Updated Successfully");
        // print('Response: $data');
        Navigator.pushReplacementNamed(context,"Dashborad" );
        // Navigator.push(context, MaterialPageRoute(builder: (context) => Dashborad(),));
      } else {
        // print('Failed: ${response.statusCode}');
        // print('Response: $data');
      }
    } catch (e) {
      // print('Error: $e');
    }
  }
  void scrollToField(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }
  void parsePhoneNumber(String fullPhoneNumber) {
    if (fullPhoneNumber.startsWith('+')) {
      // List of all country codes from the package
      final allCountryCodes =
      codes.map((c) => CountryCode.fromJson(c)).toList();

      // Sort by length of dial code in descending order to match longest first
      allCountryCodes
          .sort((a, b) => b.dialCode!.length.compareTo(a.dialCode!.length));

      for (final code in allCountryCodes) {
        if (fullPhoneNumber.startsWith(code.dialCode!)) {
          selectedCountryCode = code.dialCode!;
          profilephone.text = fullPhoneNumber.substring(code.dialCode!.length);
          return;
        }
      }
    }
    profilephone.text = fullPhoneNumber;
  }

  Future<void> getcompanyinfo(BuildContext context) async {
    final token = await ApiConstantsemployer.getTokenOnly(); // ✅ get actual token
    // final token2 = await ApiConstants.getTokenOnly2(); // ✅ get actual token

    final url = "$baseurl/api/employer/employer-info/";
    final response = await http.get(Uri.parse(url),headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',

    });
    if(response.statusCode >= 200 && response.statusCode <= 299){
      final data = posted.compantonboardingFromJson(response.body);
      // print(data);

      if (data.employer?.companyName?.isNotEmpty == true) {
        // Navigate to dashboard if company name is empty
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashborad()),
        );
      } else {

        // print("object no va");
        // print("1${user}");


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
      // print(" 2${  user}");
      profileemail.text = data.employer?.user?.email ?? "";
      // print(data.employer?.user?.email);
      // print("networkurl$networkImage");


      // emit(CompanyinfoInitial());
      // Future.delayed(Duration(milliseconds: 5000), () {
      //   // Trigger a fake user interaction
      //   emit(CompanyinfoInitial()); // Ensure rebuild (if needed)
      // });

    }else {
      // print("Something Wrong");
    }

  }




}
