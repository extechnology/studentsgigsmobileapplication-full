import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:emoji_flag_converter/emoji_flag_converter.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../postedsisg/model/model.dart'; // for MediaType

part 'onboardprofile4_state.dart';

class Onboardprofile4Cubit extends Cubit<Onboardprofile4State> {
  Onboardprofile4Cubit() : super(Onboardprofile4Initial());

  TextEditingController onboardingcompanyname = TextEditingController();
  TextEditingController onboardingemail = TextEditingController();
  TextEditingController onboardingcompanyinfo = TextEditingController();
  TextEditingController onboardingphone = TextEditingController();
  TextEditingController onboardingstreet = TextEditingController();
  TextEditingController onboardingpostcode = TextEditingController();
  Country? selectedCountry;
  String? selectedState;
  String? selectedCity;
  final String bearerToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUyMjMyNzgwLCJpYXQiOjE3NTE2Mjc5ODAsImp0aSI6IjQzOTRkYjgyMmRlOTQ0YjJhM2ZjNzMzMjFiMDM4ZTc0IiwidXNlcl9pZCI6OTN9.XjfCED0nFwJPmaxOQUToaE49IPDTrhrLfezxdi-wWBU";
  final String baseurl = "https://server.studentsgigs.com";


  File? selectedImage;

  Future pickImageFromGallery() async {
    final returned = await ImagePicker().pickImage(source: ImageSource.gallery);
    selectedImage = File(returned!.path);
    print("hey");
    emit(Onboardprofile4Initial());


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
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  TextEditingController profilecompanyname = TextEditingController();
  TextEditingController profileemail = TextEditingController();
  TextEditingController profilecompanyinfo = TextEditingController();
  TextEditingController profilephone = TextEditingController();
  TextEditingController profilestreet = TextEditingController();
  TextEditingController profilepostcode = TextEditingController();

  Future<void> updateEmployerProfile(int user) async {
    print("Function is working");
    try {
      var uri = Uri.parse('$baseurl/api/employer/employer-info/?pk=$user');

      var request = http.MultipartRequest('PUT', uri);
      final countryName = countryController.text.trim();
      final alpha2Code = countryNameToCode[countryName] ?? "";


      // Pass your Bearer token here
      request.headers['Authorization'] = 'Bearer $bearerToken';

      // Form fields (update as per your form inputs)
      request.fields['company_name'] = profilecompanyname.text.trim();
      request.fields['company_info'] = profilecompanyinfo.text.trim();
      request.fields['email'] = profileemail.text.trim();
      request.fields['phone_number'] = profilephone.text.trim();
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
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.statusCode);

        print("Profile Updated Successfully");
        print('Response: $data');
      } else {
        print('Failed: ${response.statusCode}');
        print('Response: $data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }





}
