import 'dart:io';
import 'package:anjalim/mainpage/Onboardprofile/onboardprofile4/cubit/onboardprofile4_cubit.dart';
import 'package:anjalim/mainpage/dashborad/dashborad.dart';
import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';

class OnboardProfiles extends StatefulWidget {
  const OnboardProfiles({super.key});

  @override
  State<OnboardProfiles> createState() => _OnboardProfilesState();
}

class _OnboardProfilesState extends State<OnboardProfiles> {
  final GlobalKey companyname = GlobalKey();
  final GlobalKey email = GlobalKey();
  final GlobalKey location = GlobalKey();

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: BlocProvider(
        create: (context) => Onboardprofile4Cubit()..getcompanyinfo(context),
        child: BlocBuilder<Onboardprofile4Cubit, Onboardprofile4State>(
          builder: (context, state) {
            final cubit = context.read<Onboardprofile4Cubit>();


            return Scaffold(
              backgroundColor: const Color(0xffF9F2ED),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.05),

                      Builder(

                          key: companyname,

                          builder: (context) {
                          return buildFieldTitle('Add Your Company Logo',width,"");
                        }
                      ),
                    Row(
                      children: [
                        SizedBox(
                          width: width * 0.35,
                          height: width * 0.35,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  cubit.pickImageFromGallery();
                                },
                                child:
                                Material(
                                  elevation: 4,
                                    shape:  CircleBorder(),

                                  child: Container(
                                      width: width * 0.35,
                                      height: width * 0.35,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xff004673),
                                      ),
                                      child: ClipOval(
                                        child: cubit.selectedImage != null
                                            ? Image.file(cubit.selectedImage!, fit: BoxFit.cover)
                                            : Image.asset("assets/images/others/Group 69.png", fit: BoxFit.contain),
                                      ),
                                    ),
                                ),
                              ),

                              Positioned(
                                bottom: 0,
                                right: 0,
                                child:  Container(
                                  width: width * 0.1,
                                  height: width * 0.1,
                                  decoration: const BoxDecoration(
                                    color: Color(0xffEB8125),
                                    shape: BoxShape.circle,
                                  ),
                                  child:  Center(
                                      child: Icon(Icons.edit,color: Color(0xffFFFFFF),)
                                  ),

                                ),


                              ),


                            ],
                          ),
                        ),
                      ],
                    ),


                    SizedBox(height: height * 0.05),

                      Builder(
                          key: email,

                          builder: (context) {
                          return buildField(title: 'Company Name ' ,controller: cubit.profilecompanyname, width: width, height: height,titl2: cubit.isValid == true ? "" : "required",max: 30);
                        }
                      ),
                      Builder(

                          builder: (context) {
                          return buildField(title: 'Email',controller: cubit.profileemail, width: width,height: height,titl2:cubit.isValid == true ? "" : "required",max: 40 );
                        }
                      ),
                      buildField(title: 'Company Info',controller: cubit.profilecompanyinfo, width: width,height: height,titl2: "",line: 20),
                      buildField(title: 'Phone',controller: cubit.profilephone, width: width,height: height,titl2: "",max: 15),
                      Builder(
                          key: location,

                          builder: (context) {
                          return buildField(title: 'Street',controller: cubit.profilestreet, width: width,height: height,titl2: "");
                        }
                      ),
                      SizedBox(height: height * 0.02),
                      buildFieldTitle('Location', width, cubit.isValid == true ? "" : "required"),
                      SizedBox(height: height * 0.01),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(height * 0.02),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding:  EdgeInsets.symmetric(
                          horizontal: width * 0.02,
                          vertical: height * 0.01,
                        ),
                        child:
                        CountryStateCityPicker(
                          country: cubit.countryController,
                          state: cubit.stateController,
                          city: cubit.cityController,
                          textFieldDecoration: InputDecoration(
                            border: InputBorder.none, // 🔥 Remove underline
                            enabledBorder: InputBorder.none, // 🔥 Remove underline when enabled
                            focusedBorder: InputBorder.none, //

                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: TextStyle(
                              fontSize: width * 0.035,
                              color: Colors.grey.shade500,
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w500,
                            ),

                            contentPadding:
                            EdgeInsets.symmetric(
                              horizontal: width * 0.03,
                              vertical: height * 0.015,
                            ),
                          ),
                          dialogColor: Color(0xFFF9F2ED), // Optional
                        ),
                      ),


                      SizedBox(height: height * 0.02),
                      buildField(title: 'Postal Code',controller: cubit.profilepostcode, width: width, height: height,titl2: "",max: 10),
                      SizedBox(height: height * 0.04),
                      Center(
                        child: buildFixedContainer(
                          callback: () {
                            cubit.updateEmployerProfile(context,email: email,companyname: companyname,location: location);
                            },
                          text: 'Save',
                          color: Color(0xff004673), width: width, height: height,
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildFieldTitle(String title, double width,String title2) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: width * 0.01),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Sora',
              fontWeight: FontWeight.w600,
              fontSize: width * 0.040,
            ),
          ),
          SizedBox(width: width * 0.01,),
          Text(
            title2,
            style: TextStyle(
              color: Colors.red.shade800,
              fontFamily: 'Sora',
              fontWeight: FontWeight.w600,
              fontSize: width * 0.025,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildField({
    required String title,
       required String titl2,

    required TextEditingController controller,
    required double width,
    required double height,
    void Function(CountryCode)? onCountryChange, // optional callback
    int? max, // 👈 add this
    int ? line,

  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildFieldTitle(title, width, titl2),
          SizedBox(height: height * 0.008),
          Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              height: height * 0.065,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: height * 0.008,
                    offset: Offset(0, height * 0.002),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (title == 'Phone') // Only show CountryCodePicker for phone
                    CountryCodePicker(
                      onChanged: (country) {
                        context.read<Onboardprofile4Cubit>().selectedCountryCode = country.dialCode!;
                      },
                      initialSelection: 'IN',

                      favorite: ['+91', 'IN'],
                      showFlag: true,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                      padding: EdgeInsets.zero,
                      textStyle: TextStyle(
                        fontSize: width * 0.035,
                        fontFamily: 'Sora',
                      ),

                    ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      keyboardType: title == 'Phone'
                          ? TextInputType.phone
                          : TextInputType.text,
                      maxLength: max, // 👈 apply max length here
                      maxLines: line,

                      decoration: InputDecoration(
                        counterText: "", // 👈 hides the counter display

                        contentPadding:
                        EdgeInsets.symmetric(horizontal: width * 0.04),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: width * 0.035,
                        fontFamily: 'Sora',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );  }

  Widget buildFixedContainer({
    required String text,
    required Color color,
    required VoidCallback callback,
    required double width,
    required double height,
  }) {
    return InkWell(
      onTap: callback,
      child: Container(
        width: width * 0.28,
        height: height * 0.07,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(height * 0.015),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: height * 0.01,
              offset: Offset(0, height * 0.002),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style:  TextStyle(
              color: Colors.white,
              fontFamily: 'Sora',
              fontWeight: FontWeight.w600,
              fontSize: width * 0.045,
            ),
          ),
        ),
      ),
    );
  }
}
