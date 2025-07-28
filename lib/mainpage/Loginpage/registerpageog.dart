import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';

import 'cubit/login_cubit.dart';

class GoogleSignInPage extends StatefulWidget {
  const GoogleSignInPage({super.key});

  @override
  State<GoogleSignInPage> createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  bool obscureText = true;
  bool isChecked = false;

  void toggleVisibility() {
    setState(() {
      obscureText = ! obscureText;
    });
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final double circleSize = MediaQuery.of(context).size.width * 0.14;

    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Scaffold(
        backgroundColor: Color(0xffF9F2ED),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state is LoginError &&
                      !state.message.contains('canceled')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is LoginIoaded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Signed in as ${state.email}')),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is LoginIoading) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24,),


                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 22.0),
                          child: Container(
                            width: width * 0.63,
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: circleSize,
                                  height: circleSize,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xffE3E3E3),
                                    ),
                                    borderRadius: BorderRadius.circular(circleSize / 2), // perfectly circular
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.keyboard_arrow_left_outlined,
                                      size: circleSize * 0.45, // responsive icon size
                                      color: Color(0xff313131),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width * 0.4,
                                  height: height * 0.07,

                                  decoration: BoxDecoration(
                                  ),
                                  child:  Image.asset(
                                    "assets/images/logos/image 1.png",
                                    fit: BoxFit.contain,
                                  ),

                                ),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 34,),
                        Center(
                          child: Text(
                            "Create your account ",
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w600, // SemiBold
                              fontSize: 26,
                              height: 32 / 26, // line-height ÷ font-size = 1.23
                              letterSpacing: 0, // 0%
                            ),
                          ),
                        ),
                        SizedBox(height: 34,),

                        Center(
                          child: Container(
                            width: 140,
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    context.read<LoginCubit>().signIn(context, "employer"); // or "employer", "admin"

                                  },
                                  child: Container(

                                    width: circleSize,
                                    height: circleSize,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                        width: 1,
                                        color: Color(0xffE3E3E3),
                                      ),
                                      borderRadius: BorderRadius.circular(circleSize / 2), // perfectly circular
                                    ),
                                    child: Center(
                                        child: Image.asset("assets/images/logos/google.png")

                                    ),
                                  ),
                                ),
                                Container(

                                  width: circleSize,
                                  height: circleSize,
                                  decoration: BoxDecoration(
                                    color: Color(0xff1B1F2F),
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xffE3E3E3),
                                    ),
                                    borderRadius: BorderRadius.circular(circleSize / 2), // perfectly circular
                                  ),
                                  child: Center(
                                      child:Image.asset("assets/images/logos/applelogo.png")
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 34,),

                        Center(
                          child: Text(
                            "OR LOG IN WITH EMAIL",
                            style: TextStyle(
                              color: Color(0xffA1A4B2),
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w400, // Regular
                              fontSize: 14,
                              height: 1.43, // Approx. "Title Medium" line-height: ~20px / 14px = 1.43
                              letterSpacing: 14 * 0.05, // 5% of font size = 0.7
                            ),
                          ),
                        ),
                        SizedBox(height: 34,),


                        Center(child: textform(hint: "Name",iconforsuffix: Icon(Icons.keyboard_arrow_right) )),
                        SizedBox(height: 24,),

                        Center(child: textform(hint: "Email",iconforsuffix: Icon(Icons.keyboard_arrow_right))),
                        SizedBox(height: 24,),


                        Center(
                          child: Material(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(15),

                            child: Container(
                              width: 324,
                              height: 54.57,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  obscureText: obscureText,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter password...',
                                    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.only(right: 8.0), // 👈 Adjust padding here
                                      child: IconButton(
                                        icon: Icon(
                                          obscureText ? Icons.visibility_off : Icons.visibility,
                                          color: Color(0xff3F414E),
                                        ),
                                        onPressed: toggleVisibility,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),

                        Center(
                          child: Container(
                            width: 320,
                            child: Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(color: Colors.black, fontFamily: 'Sora',fontSize: 15),
                                    children: [
                                      TextSpan(text: 'I have read the '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            // TODO: Open privacy policy URL or screen
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 78,),
                                StatefulBuilder(
                                  builder: (context, setState) {
                                    return Checkbox(

                                      value: isChecked,
                                      onChanged: (value) {
                                        setState(() {
                                          isChecked = value ?? false;
                                        });
                                      },
                                      activeColor: Color(0xffEB8125), // Fill color when checked
                                      checkColor: Colors.white, // Tick color
                                      side: BorderSide(color: Color(0xffEB8125), ), // Border color when unchecked
                                    );
                                  },
                                ),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24,),

                        Center(
                          child: Material(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(16),

                            child: Container(
                                width: 327,
                                height: 56,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                decoration: BoxDecoration(
                                  color: Color(0xff004673), // Full opacity
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child:Center(
                                  child: Text(
                                    "REGISTER",
                                    style: TextStyle(
                                      color:Color(0xffFFFFFF) ,
                                      fontFamily: 'Sora',
                                      fontWeight: FontWeight.w600, // 600 = SemiBold
                                      fontSize: 16,
                                      height: 1.5, // 150% line height = 1.5
                                      letterSpacing: 0, // 0% letter spacing
                                    ),
                                  ),

                                )
                            ),
                          ),
                        ),
                        SizedBox(height: 18,),

                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontSize: 18,
                                fontWeight: FontWeight.w400, // normal weight
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign In',
                                  style: TextStyle(
                                    fontFamily: 'Sora',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600, // semi-bold
                                    color: Color(0xffEB8125), // orange
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 24,),



                        // Text("Not signed in"),
                        // SizedBox(height: height * 0.0125),
                        // ElevatedButton.icon(
                        //   icon: const Icon(Icons.login),
                        //   label: const Text("Sign in with Google"),
                        //   onPressed: () {
                        //     context.read<LoginCubit>().signIn(context, "employer"); // or "employer", "admin"
                        //   },
                        // ),
                      ],
                    );
                  } else if (state is LoginIoaded) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Welcome, ${state.name}"),
                        SizedBox(height: height * 0.0125), // ~10 on a 800px height screen
                        ElevatedButton(
                          onPressed: () => context.read<LoginCubit>().signOut(),
                          child:  Text("Sign Out"),
                        ),
                      ],
                    );
                  }

                  return Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24,),


                      Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 22.0),
                    child: Container(
                      width: width * 0.63,
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: circleSize,
                            height: circleSize,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                width: 1,
                                color: Color(0xffE3E3E3),
                              ),
                              borderRadius: BorderRadius.circular(circleSize / 2), // perfectly circular
                            ),
                            child: Center(
                              child: Icon(
                                Icons.keyboard_arrow_left_outlined,
                                size: circleSize * 0.45, // responsive icon size
                                color: Color(0xff313131),
                              ),
                            ),
                          ),
                          Container(
                            width: width * 0.4,
                            height: height * 0.07,

                            decoration: BoxDecoration(
                            ),
                            child:  Image.asset(
                              "assets/images/logos/image 1.png",
                              fit: BoxFit.contain,
                            ),

                          ),

                        ],
                      ),
                    ),
                  ),
                      SizedBox(height: 34,),
                      Center(
                        child: Text(
                          "Create your account ",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600, // SemiBold
                            fontSize: 26,
                            height: 32 / 26, // line-height ÷ font-size = 1.23
                            letterSpacing: 0, // 0%
                          ),
                        ),
                      ),
                      SizedBox(height: 34,),

                      Center(
                        child: Container(
                          width: 140,
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  context.read<LoginCubit>().signIn(context, "employer"); // or "employer", "admin"

                                },
                                child: Container(

                                  width: circleSize,
                                  height: circleSize,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xffE3E3E3),
                                    ),
                                    borderRadius: BorderRadius.circular(circleSize / 2), // perfectly circular
                                  ),
                                  child: Center(
                                    child: Image.asset("assets/images/logos/google.png")

                                  ),
                                ),
                              ),
                              Container(

                                width: circleSize,
                                height: circleSize,
                                decoration: BoxDecoration(
                                  color: Color(0xff1B1F2F),
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xffE3E3E3),
                                  ),
                                  borderRadius: BorderRadius.circular(circleSize / 2), // perfectly circular
                                ),
                                child: Center(
                                  child:Image.asset("assets/images/logos/applelogo.png")
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 34,),

                      Center(
                        child: Text(
                          "OR LOG IN WITH EMAIL",
                          style: TextStyle(
                            color: Color(0xffA1A4B2),
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w400, // Regular
                            fontSize: 14,
                            height: 1.43, // Approx. "Title Medium" line-height: ~20px / 14px = 1.43
                            letterSpacing: 14 * 0.05, // 5% of font size = 0.7
                          ),
                        ),
                      ),
                      SizedBox(height: 34,),


                      Center(child: textform(hint: "Name",iconforsuffix: Icon(Icons.keyboard_arrow_right) )),
                      SizedBox(height: 24,),

                      Center(child: textform(hint: "Email",iconforsuffix: Icon(Icons.keyboard_arrow_right))),
                      SizedBox(height: 24,),


                      Center(
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(15),

                          child: Container(
                            width: 324,
                            height: 54.57,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: TextFormField(
                                obscureText: obscureText,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter password...',
                                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(right: 8.0), // 👈 Adjust padding here
                                    child: IconButton(
                                      icon: Icon(
                                        obscureText ? Icons.visibility_off : Icons.visibility,
                                        color: Color(0xff3F414E),
                                      ),
                                      onPressed: toggleVisibility,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),

                      Center(
                        child: Container(
                          width: 320,
                          child: Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(color: Colors.black, fontFamily: 'Sora',fontSize: 15),
                                  children: [
                                    TextSpan(text: 'I have read the '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // TODO: Open privacy policy URL or screen
                                        },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 78,),
                              StatefulBuilder(
                                builder: (context, setState) {
                                  return Checkbox(

                                    value: isChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        isChecked = value ?? false;
                                      });
                                    },
                                    activeColor: Color(0xffEB8125), // Fill color when checked
                                    checkColor: Colors.white, // Tick color
                                    side: BorderSide(color: Color(0xffEB8125), ), // Border color when unchecked
                                  );
                                },
                              ),

                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24,),

                      Center(
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(16),

                          child: Container(
                            width: 327,
                            height: 56,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: Color(0xff004673), // Full opacity
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child:Center(
                               child: Text(
                                 "REGISTER",
                                 style: TextStyle(
                                   color:Color(0xffFFFFFF) ,
                                   fontFamily: 'Sora',
                                   fontWeight: FontWeight.w600, // 600 = SemiBold
                                   fontSize: 16,
                                   height: 1.5, // 150% line height = 1.5
                                   letterSpacing: 0, // 0% letter spacing
                                 ),
                               ),

                            )
                          ),
                        ),
                      ),
                      SizedBox(height: 18,),

                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontSize: 18,
                              fontWeight: FontWeight.w400, // normal weight
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign In',
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600, // semi-bold
                                  color: Color(0xffEB8125), // orange
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 24,),



                      // Text("Not signed in"),
                      // SizedBox(height: height * 0.0125),
                      // ElevatedButton.icon(
                      //   icon: const Icon(Icons.login),
                      //   label: const Text("Sign in with Google"),
                      //   onPressed: () {
                      //     context.read<LoginCubit>().signIn(context, "employer"); // or "employer", "admin"
                      //   },
                      // ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
Widget textform({ TextEditingController ? controllers,String ? hint, Icon ?  iconforsuffix}){
  return
    Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(15),

      child: Container(
      width: 324,
      height: 54.57,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child:  Align(
        alignment: Alignment.center,

        child: TextFormField(
          controller: controllers,


          decoration: InputDecoration(

            border: InputBorder.none,
            hintText: hint,
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 12.0), // 👈 Adjust padding here
              child: iconforsuffix
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 14.0),

          ),

        ),
      ),
        ),
    );

}
