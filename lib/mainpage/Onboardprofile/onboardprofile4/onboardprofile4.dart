import 'dart:io';
import 'package:anjalim/mainpage/Onboardprofile/onboardprofile4/cubit/onboardprofile4_cubit.dart';
import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardProfiles extends StatelessWidget {
  const OnboardProfiles({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: BlocProvider(
        create: (context) => Onboardprofile4Cubit(),
        child: BlocBuilder<Onboardprofile4Cubit, Onboardprofile4State>(
          builder: (context, state) {
            final cubit = context.read<Onboardprofile4Cubit>();



            return Scaffold(
              backgroundColor: const Color(0xffF9F2ED),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.05),

                      buildFieldTitle('Add Your Company Logo',width),
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
                                Container(
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
                                              child: Image.asset(
                                                "assets/images/logos/Group 6807.png",
                                                width: width * 0.05,
                                                height: width * 0.05,
                                                fit: BoxFit.contain,
                                              ),
                                            ),

                                        ),


                              ),


                            ],
                          ),
                        ),
                      ],
                    ),


                    SizedBox(height: height * 0.05),
                      buildField(title: 'Company Name',controller: cubit.profilecompanyname),
                      buildField(title: 'Email',controller: cubit.profileemail),
                      buildField(title: 'Company Info',controller: cubit.profilecompanyinfo),
                      buildField(title: 'Phone',controller: cubit.profilephone),
                      buildField(title: 'Street',controller: cubit.profilestreet),
                      SizedBox(height: height * 0.02),
                      buildFieldTitle('Location', width),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                              fontSize: 14,
                              color: Colors.grey.shade500,
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w500,
                            ),

                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          ),
                          dialogColor: Color(0xFFF9F2ED), // Optional
                        ),
                      ),


                      SizedBox(height: height * 0.02),
                      buildField(title: 'Postal Code',controller: cubit.profilepostcode),
                      SizedBox(height: height * 0.04),
                      Center(
                        child: buildFixedContainer(
                          callback: () {
                            // cubit.updateEmployerProfile();
                          },
                          text: 'Save',
                          color: const Color(0xff004673),
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


  Widget buildFieldTitle(String title, double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Sora',
          fontWeight: FontWeight.w600,
          fontSize: width * 0.045,
        ),
      ),
    );
  }

  Widget buildField({ required String title,required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildFieldTitle(title, 400),  // pass width directly
          SizedBox(height: 8),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child:  TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget buildFixedContainer({required String text, required Color color,required VoidCallback callback,}) {
    return InkWell(
      onTap: callback,
      child: Container(
        width: 107,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Sora',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
