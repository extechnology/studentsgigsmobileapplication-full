import 'dart:io';
import 'package:anjalim/mainpage/Onboardprofile/onboardprofile4/cubit/onboardprofile4_cubit.dart';
import 'package:anjalim/mainpage/profile/companyinfo/cubit/companyinfo_cubit.dart';
import 'package:anjalim/mainpage/profile/companyinfo/model/model.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Companyinfo extends StatelessWidget {
  const Companyinfo({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => CompanyinfoCubit(),
      child: BlocBuilder<CompanyinfoCubit, CompanyinfoState>(
        builder: (context, state) {
          final cubit = context.read<CompanyinfoCubit>();
    
    
    
          return Scaffold(
            backgroundColor: const Color(0xffF9F2ED),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                child: SingleChildScrollView(
                  child: Padding(
                    padding:  EdgeInsets.only( bottom: 108.0 + MediaQuery.of(context).padding.bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.05),

                        Center(child: buildFieldTitle(title: 'Update Profile', context: context)),
                        Center(
                          child: Container(
                            child:
                                 Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          cubit.pickImageFromGallery();

                                        },
                                        child:
                                        Material(


                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(100), // makes it very round
                                          ),

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
                                                  : (cubit.networkImage != null && cubit.networkImage!.isNotEmpty
                                                  ? Image.network(
                                                cubit.networkImage!,
                                                fit: BoxFit.cover,
                                              )
                                                  : Icon(
                                                Icons.person,
                                                size: 48, // set your desired size
                                                color: Colors.grey, // optional color
                                              )
                                              ),
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
                        ),


                        SizedBox(height: height * 0.05),
                        buildField(title: 'Company Name',controller: cubit.profilecompanyname, context: context,max: 40, texr: TextInputAction.done),
                        buildField(title: 'Email',controller: cubit.profileemail, context: context,max: 40, texr: TextInputAction.done),
                        buildField(title: 'Company Info',controller: cubit.profilecompanyinfo, context: context,line: 20,fix: height* 0.2 ,texr: TextInputAction.newline),
                        buildField(title: 'Phone',controller: cubit.profilephone, context: context,max: 15, phonekeyboard: TextInputType.number, ),
                        buildField(title: 'Street',controller: cubit.profilestreet, context: context,max: 60, texr: TextInputAction.done),
                        SizedBox(height: height * 0.02),
                        buildFieldTitle(title: 'Location', context: context),
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
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.02,   // 8 is 2% of 400
                            vertical: height * 0.005,   // 4 is 0.5% of 800
                          ),                        child:
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
                                fontSize: width * 0.035, // 14 is 3.5% of 400
                                color: Colors.grey.shade500,
                                fontFamily: 'Sora',
                                fontWeight: FontWeight.w500,
                              ),


                              contentPadding: EdgeInsets.symmetric(
                                horizontal: width * 0.03,   // 12 if width ≈ 400
                                vertical: height * 0.0175,  // 14 if height ≈ 800
                              ),
                            ),
                            dialogColor: Color(0xFFF9F2ED), // Optional
                          ),
                        ),


                        SizedBox(height: height * 0.02),
                        buildField(title: 'Postal Code',controller: cubit.profilepostcode, context: context,max: 10 ,texr: TextInputAction.done),
                        SizedBox(height: height * 0.04),
                        Center(
                          child: buildFixedContainer(
                            callback: () {
                              cubit.updateEmployerProfile(int.tryParse(cubit.user ?? '0') ?? 0);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Company Profile updated successfully',
                                    style: TextStyle(color: Colors.white), // 👈 text color
                                  ),
                                  backgroundColor: Colors.green, // 👈 background color
                                  duration: Duration(seconds: 2), // Optional: how long it shows
                                ),
                              );
                            },
                            text: 'Save',
                            color: const Color(0xff004673), context: context,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget buildFieldTitle({String ?title, required BuildContext context }) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.006),
      child: Text(
        title!,
        style: TextStyle(
          fontFamily: 'Sora',
          fontWeight: FontWeight.w600,
          fontSize: width * 0.039,
        ),
      ),
    );
  }

  Widget buildField({
    required BuildContext context ,
    required String title,
    required TextEditingController controller,
    int ? max,
    int ? line,
    double ? fix ,
    TextInputType ?  phonekeyboard ,// 👈 Add this

     TextInputAction ? texr,
  void Function(CountryCode)? onCountryChange,
  String? initialCountryCode,
  }) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;


    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildFieldTitle(title: title, context: context),
          SizedBox(height: height * 0.01),
          Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: fix ?? height * 0.06,
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
              child: Row(
                children: [
                  if (title.toLowerCase() == 'phone') // Show Country Picker only for 'Phone'
                    CountryCodePicker(

                      onChanged: (country) {

                        context.read<CompanyinfoCubit>().selectedCountryCode = country;
                      },


                      initialSelection: context.read<CompanyinfoCubit>().selectedCountryCode.code,
                      // favorite: ['+91', 'IN'],
                      showFlag: true,
                      padding: EdgeInsets.only(left: width * 0.02),
                      textStyle: TextStyle(
                        fontSize: width * 0.035,
                        fontFamily: 'Sora',
                      ),

                    ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      keyboardType: phonekeyboard,
                      textInputAction: texr,
                      maxLength: max,
                      maxLines: line,
                      decoration: InputDecoration(
                        counterText: "", // hide maxLength counter
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: width * 0.03),
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


  Widget buildFixedContainer({ required BuildContext context ,required String text, required Color color,required VoidCallback callback,}) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: callback,
      child: Container(
        width: width * 0.28,     // approx. 107 if width = 375
        height: height * 0.07,
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
            style:  TextStyle(
              color: Colors.white,
              fontFamily: 'Sora',
              fontWeight: FontWeight.w600,
              fontSize: width * 0.042, // ≈ 16 when width ≈ 375
            ),
          ),
        ),
      ),
    );
  }
}
