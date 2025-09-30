import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Loginpage/cubit/login_cubit.dart';
import '../Loginpage/registerpageog.dart';
import 'cubit/loginpag_cubit.dart';
import 'cubit2/resetpassword_cubit.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pinput/pinput.dart';
import 'dart:async';

import 'cubitphone/phone_cubit.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool obscureText = true;
  bool isChecked = false;

  void toggleVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final double circleSize = MediaQuery.of(context).size.width * 0.14;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => LoginpagCubit(),
        ),
        BlocProvider(
          create: (context) => ResetpasswordCubit(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Color(0xffF9F2ED),
        body: BlocListener<ResetpasswordCubit, ResetpasswordState>(
          listener: (context, state) {

            if (state is ResetpasswordIoaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            }
            else if (state is ResetpasswordIoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Loading....."),
                  backgroundColor: Colors.green,
                ),
              );
            }else if (state is Resetpassworderror) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
  child: SingleChildScrollView(
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginError && !state.message.contains('canceled')) {
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
                return Padding(

                  padding: EdgeInsets.only(
                    bottom: 108.0 + MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.07,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.061),
                        child: Container(
                          width: width * 0.63,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
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
                                    borderRadius: BorderRadius.circular(
                                        circleSize / 2), // perfectly circular
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.keyboard_arrow_left_outlined,
                                      size: circleSize * 0.45, // responsive icon size
                                      color: Color(0xff313131),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: width * 0.4,
                                height: height * 0.07,
                                decoration: BoxDecoration(),
                                child: Image.asset(
                                  "assets/images/logos/image 1.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.0215,
                      ),
                      Center(
                        child: Text(
                          "Welcome Back !",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600, // SemiBold
                            fontSize: width * 0.072,
                            height: 32 / 26, // line-height ÷ font-size = 1.23
                            letterSpacing: 0, // 0%
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.033,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            context.read<LoginCubit>().signIn(context); // or "employer", "admin"

                          },
                          child: Container(
                              width: width * 0.85,
                              height: height * 0.0753,
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.056,
                                  vertical: height * 0.025),
                              decoration: BoxDecoration(
                                color: Color(0xff004673), // Full opacity
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: circleSize,
                                    height: circleSize,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          circleSize / 2), // perfectly circular
                                    ),
                                    child: Center(
                                        child: Image.asset(
                                            "assets/images/logos/google.png")),
                                  ),

                                  SizedBox(width: width * 0.01),

                                  Center(
                                    child: Text(
                                      "Log in with google",
                                      style: TextStyle(
                                        color: Color(0xffFFFFFF),
                                        fontFamily: 'Sora',
                                        fontWeight: FontWeight.w600, // 600 = SemiBold
                                        fontSize: width * 0.034,
                                        height: 1.5, // 150% line height = 1.5
                                        letterSpacing: 0, // 0% letter spacing
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: height*0.02,),

                      Center(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16), // ripple effect follows shape
                          onTap: () {
                            PhoneLoginDialog.show(context);

                          },
                          child: Container(
                            width: width * 0.85,
                            height: height * 0.0753,
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.056,
                              vertical: height * 0.025,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xff004673), // Full opacity
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.call,
                                  color: Colors.white,
                                  size: width * 0.04,
                                ),
                                SizedBox(width: width * 0.039),
                                Center(
                                  child: Text(
                                    "Log in with Phone",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Sora',
                                      fontWeight: FontWeight.w600,
                                      fontSize: width * 0.034,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Center(
                      //   child: SizedBox(
                      //     width: width * 0.389,
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         InkWell(
                      //           onTap: () {
                      //             if (isChecked) {
                      //               context.read<LoginCubit>().signIn(context); // or "employer", "admin"
                      //             } else {
                      //               ScaffoldMessenger.of(context).showSnackBar(
                      //                 SnackBar(
                      //                   content: Text(
                      //                       "Please accept the Privacy Policy to continue."),
                      //                   backgroundColor: Colors.redAccent,
                      //                   behavior: SnackBarBehavior.floating,
                      //                   duration: Duration(seconds: 2),
                      //                   shape: RoundedRectangleBorder(
                      //                     borderRadius: BorderRadius.circular(8),
                      //                   ),
                      //                 ),
                      //               );
                      //             }
                      //           },
                      //           child:
                      //           Container(
                      //             width: circleSize,
                      //             height: circleSize,
                      //             decoration: BoxDecoration(
                      //               color: Colors.transparent,
                      //               border: Border.all(
                      //                 width: 1,
                      //                 color: Color(0xffE3E3E3),
                      //               ),
                      //               borderRadius: BorderRadius.circular(
                      //                   circleSize / 2), // perfectly circular
                      //             ),
                      //             child: Center(
                      //                 child: Image.asset(
                      //                     "assets/images/logos/google.png")),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: height * 0.039,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: width * 0.35, // adjust line length
                            height: height * 0.001,
                            color: Colors.grey.shade400,
                          ),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal:width * 0.02 ),
                            child: Text(
                              "OR",
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: width *0.033,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            width: width * 0.35, // adjust line length
                            height: height * 0.001,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.025,
                      ),
                      Center(
                          child: textform(
                              hint: "Name",
                              controllers: username,
                              context: context)),
                      SizedBox(
                        height: height * 0.021,
                      ),
                      Center(
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: width * 0.85,
                            height: height * 0.0753,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: TextFormField(
                                controller: password,
                                obscureText: obscureText,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Password',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: height * 0.025,
                                      horizontal: width * 0.033),
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(
                                        right: width *
                                            0.022), // 👈 Adjust padding here
                                    child: IconButton(
                                      icon: Icon(
                                        obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
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
                      SizedBox(
                        height: height * 0.015,
                      ),
                      Center(
                        child: Container(
                          width: width * 0.85,

                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Sora',
                                      fontSize: width * 0.038),
                                  children: [
                                    TextSpan(text: 'By logging in, you agree to our ',style: TextStyle(fontSize: width * 0.03)),
                                    TextSpan(
                                      text: 'Terms and Conditions',
                                      style: TextStyle(
                                        fontSize: width * 0.03,
                                        color: Colors.black,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {

                                          showEmployerTermsDialog(context);                                    },
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   width: width * 0.24,
                              // ),
                              // StatefulBuilder(
                              //   builder: (context, setState) {
                              //     return Checkbox(
                              //       value: isChecked,
                              //       onChanged: (value) {
                              //         setState(() {
                              //           isChecked = value ?? false;
                              //         });
                              //       },
                              //       activeColor: Color(
                              //           0xffEB8125), // Fill color when checked
                              //       checkColor: Colors.white, // Tick color
                              //       side: BorderSide(
                              //         color: Color(0xffEB8125),
                              //       ), // Border color when unchecked
                              //     );
                              //   },
                              // ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.06,
                      ),
                      Center(
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: () {
                              context.read<LoginpagCubit>().loginUser(context, username.text.trim(), password.text.trim());
                            },
                            child:
                            Container(
                                width: width * 0.85,
                                height: height * 0.0753,
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.056,
                                    vertical: height * 0.025),
                                decoration: BoxDecoration(
                                  color: Color(0xff004673), // Full opacity
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    "LOG IN",
                                    style: TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontFamily: 'Sora',
                                      fontWeight: FontWeight.w600, // 600 = SemiBold
                                      fontSize: width * 0.034,
                                      height: 1.5, // 150% line height = 1.5
                                      letterSpacing: 0, // 0% letter spacing
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.020,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            final parentContext = context;
                            final emailController = TextEditingController();

                            // Step 1: Email Dialog
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) {
                                String? errorText; // 👈 error message holder

                                return StatefulBuilder(
                                    builder: (dialogContext,setState) {
                                      return Dialog(
                                        backgroundColor: Colors.white,

                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                16)),
                                        child: Padding(
                                          padding:  EdgeInsets.all(width * 0.05),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Reset Password",
                                                    style: TextStyle(
                                                      fontSize: width * 0.05,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Icon(Icons.vpn_key, size: width * 0.06),
                                                ],
                                              ),
                                              SizedBox(height: height * 0.02),
                                              Text(
                                                "Enter your email address linked to your account",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: width * 0.035,
                                                    color: Colors.grey[700]),
                                              ),
                                              SizedBox(height: height * 0.02),
                                              TextField(
                                                controller: emailController,
                                                decoration: InputDecoration(
                                                  hintText: ' email or Phone number ',
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(12),
                                                  ),
                                                  contentPadding:  EdgeInsets
                                                      .symmetric(
                                                    horizontal: width * 0.03,
                                                    vertical: height * 0.015,
                                                  ),
                                                ),
                                                keyboardType: TextInputType.text,
                                              ),
                                              SizedBox(height: height * 0.02),
                                              if (errorText != null) ...[
                                                SizedBox(height: height * 0.02),
                                                Text(
                                                  errorText!,
                                                  style:
                                                  TextStyle(color: Colors.red,
                                                      fontSize: width * 0.035),
                                                ),
                                              ],
                                              // Info Text
                                              Text(
                                                "A link will be sent to your email for resetting your password & username",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: width * 0.03,
                                                    color: Colors.grey[600]),
                                              ),
                                              SizedBox(height: height * 0.02),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      if (emailController.text
                                                          .trim()
                                                          .isEmpty) {
                                                        setState(() {
                                                          errorText =
                                                          "Please enter email or phone number";
                                                        });
                                                        return;

                                                      } else {
                                                        setState(() {
                                                          errorText =
                                                          null; // clear error
                                                        });
                                                        // ✅ Continue with OTP
                                                      }
                                                      final email = emailController
                                                          .text.trim();

                                                      // Step 1: Trigger resetPassword Cubit
                                                      await parentContext.read<
                                                          ResetpasswordCubit>()
                                                          .resetPassword(
                                                        email: email,
                                                        context: parentContext,
                                                      );
                                                      Navigator.pop(context);

                                                      // Step 2: OTP Dialog
                                                      final otpController = TextEditingController();
                                                      String? otpError;

                                                      showDialog(
                                                        context: parentContext,
                                                        barrierDismissible: false,
                                                        builder: (_) {
                                                          String formatTime(int seconds) {
                                                            final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
                                                            final secs = (seconds % 60).toString().padLeft(2, '0');
                                                            return "$minutes:$secs";
                                                          }
                                                          int secondsRemaining = 600; // ⏱ initial countdown
                                                          Timer? timer;
                                                          return StatefulBuilder(
                                                            builder: (context,
                                                                setState) {
                                                              timer ??= Timer.periodic(const Duration(seconds: 1), (t) {
                                                                if (secondsRemaining > 0) {
                                                                  setState(() => secondsRemaining--);
                                                                } else {
                                                                  t.cancel();
                                                                }
                                                              });
                                                              return Dialog(
                                                                backgroundColor: Colors.white,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius
                                                                        .circular(
                                                                        16)),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .all(20),
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize
                                                                        .min,
                                                                    children: [
                                                                      Text(
                                                                        'Enter OTP',
                                                                        style: TextStyle(
                                                                            fontSize: width * 0.05,
                                                                            fontWeight: FontWeight
                                                                                .bold),
                                                                      ),
                                                                      SizedBox(height: height * 0.02),

                                                                      Text(
                                                                        'A verification code has been sent to your email.',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .grey,
                                                                            fontSize: width * 0.035
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height: height * 0.02),

                                                                      // ✅ Pinput OTP (6 digits)
                                                                      Pinput(
                                                                        length: 6,
                                                                        controller: otpController,
                                                                        defaultPinTheme: PinTheme(
                                                                          width: 50,
                                                                          height: 50,
                                                                          textStyle:  TextStyle(
                                                                              fontSize: width * 0.05,
                                                                              color: Colors
                                                                                  .black),
                                                                          decoration: BoxDecoration(
                                                                            border: Border
                                                                                .all(
                                                                                color: Colors
                                                                                    .grey),
                                                                            borderRadius: BorderRadius
                                                                                .circular(
                                                                                12),
                                                                          ),
                                                                        ),
                                                                        focusedPinTheme: PinTheme(
                                                                          width: 50,
                                                                          height: 50,
                                                                          textStyle:  TextStyle(
                                                                              fontSize: width * 0.05,
                                                                              color: Colors
                                                                                  .black),
                                                                          decoration: BoxDecoration(
                                                                            border: Border
                                                                                .all(
                                                                                color: Colors
                                                                                    .blue),
                                                                            borderRadius: BorderRadius
                                                                                .circular(
                                                                                12),
                                                                          ),
                                                                        ),
                                                                        onChanged: (
                                                                            value) {
                                                                          if (otpError !=
                                                                              null) {
                                                                            setState(() {
                                                                              otpError =
                                                                              null;
                                                                            });
                                                                          }
                                                                        },
                                                                      ),


                                                                      if (otpError !=
                                                                          null)
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              top: 8),
                                                                          child: Text(
                                                                            otpError!,
                                                                            style:  TextStyle(
                                                                                color: Colors
                                                                                    .red,
                                                                                fontSize:width * 0.035 ),
                                                                          ),
                                                                        ),
                                                                      TextButton(
                                                                        onPressed: secondsRemaining == 0
                                                                            ? () async {
                                                                          // Call resend OTP API
                                                                          await parentContext
                                                                              .read<ResetpasswordCubit>()
                                                                              .resetPassword(
                                                                            email: email,
                                                                            context: parentContext,
                                                                          );

                                                                          setState(() {
                                                                            secondsRemaining = 600; // restart 10 min countdown
                                                                            timer?.cancel();
                                                                            timer = null;
                                                                          });
                                                                        }
                                                                            : null,
                                                                        child: Text(
                                                                          secondsRemaining > 0
                                                                              ? "Resend in ${formatTime(secondsRemaining)}"
                                                                              : "Resend OTP",
                                                                          style: TextStyle(
                                                                            color: secondsRemaining == 0 ? Colors.blue : Colors.grey,
                                                                          ),
                                                                        ),
                                                                      ),                                                                   SizedBox(
                                                                          height: height * 0.03),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .center,
                                                                        children: [

                                                                          InkWell(
                                                                            onTap: () async {
                                                                              final otp = otpController
                                                                                  .text
                                                                                  .trim();
                                                                              final isVerified = await parentContext
                                                                                  .read<
                                                                                  ResetpasswordCubit>()
                                                                                  .verifyOtp(
                                                                                email: email,
                                                                                otp: otp,
                                                                                context: parentContext,
                                                                              );

                                                                              if (isVerified) {
                                                                                Navigator
                                                                                    .pop(
                                                                                    parentContext);

                                                                                // Step 3: New Password Dialog
                                                                                final passController = TextEditingController();
                                                                                final confirmPassController = TextEditingController();

                                                                                showDialog(
                                                                                  context: parentContext,
                                                                                  barrierDismissible: false,
                                                                                  builder: (
                                                                                      _) {
                                                                                    return Dialog(
                                                                                      backgroundColor: Colors.white,

                                                                                      shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius
                                                                                              .circular(
                                                                                              16)),
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets
                                                                                            .all(
                                                                                            20),
                                                                                        child: Column(
                                                                                          mainAxisSize: MainAxisSize
                                                                                              .min,
                                                                                          children: [
                                                                                            Text(
                                                                                              'Set New Password',
                                                                                              style: TextStyle(
                                                                                                  fontSize: width *0.05 ,
                                                                                                  fontWeight: FontWeight
                                                                                                      .bold),
                                                                                            ),
                                                                                            SizedBox(
                                                                                                height: height * 0.02),
                                                                                            TextField(
                                                                                              controller: passController,
                                                                                              obscureText: true,
                                                                                              decoration: InputDecoration(
                                                                                                hintText: "New Password",
                                                                                                border: OutlineInputBorder(
                                                                                                    borderRadius: BorderRadius
                                                                                                        .circular(
                                                                                                        12)),
                                                                                                contentPadding:  EdgeInsets
                                                                                                    .symmetric(
                                                                                                    horizontal:width * 0.03 ,
                                                                                                    vertical: height * 0.015),
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                                height: height * 0.02),
                                                                                            TextField(
                                                                                              controller: confirmPassController,
                                                                                              obscureText: true,
                                                                                              decoration: InputDecoration(
                                                                                                hintText: "Confirm Password",
                                                                                                border: OutlineInputBorder(
                                                                                                    borderRadius: BorderRadius
                                                                                                        .circular(
                                                                                                        12)),
                                                                                                contentPadding:  EdgeInsets
                                                                                                    .symmetric(
                                                                                                    horizontal: width * 0.03,
                                                                                                    vertical: height * 0.015),
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                                height: height *0.03),
                                                                                            Row(
                                                                                              mainAxisAlignment: MainAxisAlignment
                                                                                                  .center,
                                                                                              children: [

                                                                                                InkWell(
                                                                                                  onTap: () async {
                                                                                                    await parentContext
                                                                                                        .read<
                                                                                                        ResetpasswordCubit>()
                                                                                                        .confirmPasswordChange(
                                                                                                      context: parentContext,
                                                                                                      email: email,
                                                                                                      password: passController
                                                                                                          .text
                                                                                                          .trim(),
                                                                                                      confirmPassword: confirmPassController
                                                                                                          .text
                                                                                                          .trim(),
                                                                                                    );
                                                                                                    Navigator
                                                                                                        .pop(
                                                                                                        parentContext);
                                                                                                  },
                                                                                                  child: Container(
                                                                                                    width: width *
                                                                                                        0.7,
                                                                                                    height: height *
                                                                                                        0.054,
                                                                                                    padding: EdgeInsets
                                                                                                        .symmetric(
                                                                                                        horizontal: width * 0.056,
                                                                                                        vertical: 12),
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: Colors
                                                                                                          .black,
                                                                                                      borderRadius: BorderRadius
                                                                                                          .circular(
                                                                                                          12),
                                                                                                    ),
                                                                                                    child: Center(
                                                                                                      child: Text(
                                                                                                        "Submit",
                                                                                                        style: TextStyle(
                                                                                                            color: Colors
                                                                                                                .white),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              } else {
                                                                                setState(() {
                                                                                  otpError =
                                                                                  "Invalid OTP, please try again";
                                                                                });
                                                                              }
                                                                            },
                                                                            child: Container(
                                                                              width: width *
                                                                                  0.7,
                                                                              height: height *
                                                                                  0.054,
                                                                              padding:  EdgeInsets
                                                                                  .symmetric(
                                                                                  horizontal: width * 0.056 ,
                                                                                  vertical: height * 0.015),
                                                                              decoration: BoxDecoration(
                                                                                color: Colors
                                                                                    .black,
                                                                                borderRadius: BorderRadius
                                                                                    .circular(
                                                                                    12),
                                                                              ),
                                                                              child: Center(
                                                                                child: const Text(
                                                                                  "Verify",
                                                                                  style: TextStyle(
                                                                                      color: Colors
                                                                                          .white),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Center(
                                                      child: Container(
                                                        width: width * 0.7,
                                                        height: height * 0.054,
                                                        decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius: BorderRadius
                                                              .circular(12),
                                                        ),
                                                        child: Center(
                                                          child: const Text(
                                                            "OK",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );

                                    }
                                );

                              },
                            );
                          },
                          child:  Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w400,
                              fontSize: width * 0.04,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: height * 0.029,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, 'GoogleSignInPage');
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => GoogleSignInPage(),));
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Not yet registered?  ',
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.w400, // normal weight
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                    fontFamily: 'Sora',
                                    fontSize: width * 0.045,
                                    fontWeight: FontWeight.w600, // semi-bold
                                    color: Color(0xffEB8125), // orange
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              else if (state is LoginIoaded)
                return Padding(

                  padding: EdgeInsets.only(
                    bottom: 108.0 + MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.07,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.061),
                        child: Container(
                          width: width * 0.63,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
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
                                    borderRadius: BorderRadius.circular(
                                        circleSize / 2), // perfectly circular
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.keyboard_arrow_left_outlined,
                                      size: circleSize * 0.45, // responsive icon size
                                      color: Color(0xff313131),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: width * 0.4,
                                height: height * 0.07,
                                decoration: BoxDecoration(),
                                child: Image.asset(
                                  "assets/images/logos/image 1.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.0215,
                      ),
                      Center(
                        child: Text(
                          "Welcome Back !",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600, // SemiBold
                            fontSize: width * 0.072,
                            height: 32 / 26, // line-height ÷ font-size = 1.23
                            letterSpacing: 0, // 0%
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.033,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            context.read<LoginCubit>().signIn(context); // or "employer", "admin"

                          },
                          child: Container(
                              width: width * 0.85,
                              height: height * 0.0753,
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.056,
                                  vertical: height * 0.025),
                              decoration: BoxDecoration(
                                color: Color(0xff004673), // Full opacity
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: circleSize,
                                    height: circleSize,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          circleSize / 2), // perfectly circular
                                    ),
                                    child: Center(
                                        child: Image.asset(
                                            "assets/images/logos/google.png")),
                                  ),

                                  SizedBox(width: width * 0.01),

                                  Center(
                                    child: Text(
                                      "Log in with google",
                                      style: TextStyle(
                                        color: Color(0xffFFFFFF),
                                        fontFamily: 'Sora',
                                        fontWeight: FontWeight.w600, // 600 = SemiBold
                                        fontSize: width * 0.034,
                                        height: 1.5, // 150% line height = 1.5
                                        letterSpacing: 0, // 0% letter spacing
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: height*0.02,),

                      Center(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16), // ripple effect follows shape
                          onTap: () {
                            PhoneLoginDialog.show(context);

                          },
                          child: Container(
                            width: width * 0.85,
                            height: height * 0.0753,
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.056,
                              vertical: height * 0.025,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xff004673), // Full opacity
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.call,
                                  color: Colors.white,
                                  size: width * 0.04,
                                ),
                                SizedBox(width: width * 0.039),
                                Center(
                                  child: Text(
                                    "Log in with Phone",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Sora',
                                      fontWeight: FontWeight.w600,
                                      fontSize: width * 0.034,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Center(
                      //   child: SizedBox(
                      //     width: width * 0.389,
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         InkWell(
                      //           onTap: () {
                      //             if (isChecked) {
                      //               context.read<LoginCubit>().signIn(context); // or "employer", "admin"
                      //             } else {
                      //               ScaffoldMessenger.of(context).showSnackBar(
                      //                 SnackBar(
                      //                   content: Text(
                      //                       "Please accept the Privacy Policy to continue."),
                      //                   backgroundColor: Colors.redAccent,
                      //                   behavior: SnackBarBehavior.floating,
                      //                   duration: Duration(seconds: 2),
                      //                   shape: RoundedRectangleBorder(
                      //                     borderRadius: BorderRadius.circular(8),
                      //                   ),
                      //                 ),
                      //               );
                      //             }
                      //           },
                      //           child:
                      //           Container(
                      //             width: circleSize,
                      //             height: circleSize,
                      //             decoration: BoxDecoration(
                      //               color: Colors.transparent,
                      //               border: Border.all(
                      //                 width: 1,
                      //                 color: Color(0xffE3E3E3),
                      //               ),
                      //               borderRadius: BorderRadius.circular(
                      //                   circleSize / 2), // perfectly circular
                      //             ),
                      //             child: Center(
                      //                 child: Image.asset(
                      //                     "assets/images/logos/google.png")),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: height * 0.039,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: width * 0.35, // adjust line length
                            height: height * 0.001,
                            color: Colors.grey.shade400,
                          ),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal:width * 0.02 ),
                            child: Text(
                              "OR",
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: width *0.033,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            width: width * 0.35, // adjust line length
                            height: height * 0.001,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.025,
                      ),
                      Center(
                          child: textform(
                              hint: "Name",
                              controllers: username,
                              context: context)),
                      SizedBox(
                        height: height * 0.021,
                      ),
                      Center(
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: width * 0.85,
                            height: height * 0.0753,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: TextFormField(
                                controller: password,
                                obscureText: obscureText,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Password',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: height * 0.025,
                                      horizontal: width * 0.033),
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(
                                        right: width *
                                            0.022), // 👈 Adjust padding here
                                    child: IconButton(
                                      icon: Icon(
                                        obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
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
                      SizedBox(
                        height: height * 0.015,
                      ),
                      Center(
                        child: Container(
                          width: width * 0.85,

                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Sora',
                                      fontSize: width * 0.038),
                                  children: [
                                    TextSpan(text: 'By logging in, you agree to our ',style: TextStyle(fontSize: width * 0.03)),
                                    TextSpan(
                                      text: 'Terms and Conditions',
                                      style: TextStyle(
                                        fontSize: width * 0.03,
                                        color: Colors.black,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {

                                          showEmployerTermsDialog(context);                                    },
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   width: width * 0.24,
                              // ),
                              // StatefulBuilder(
                              //   builder: (context, setState) {
                              //     return Checkbox(
                              //       value: isChecked,
                              //       onChanged: (value) {
                              //         setState(() {
                              //           isChecked = value ?? false;
                              //         });
                              //       },
                              //       activeColor: Color(
                              //           0xffEB8125), // Fill color when checked
                              //       checkColor: Colors.white, // Tick color
                              //       side: BorderSide(
                              //         color: Color(0xffEB8125),
                              //       ), // Border color when unchecked
                              //     );
                              //   },
                              // ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.06,
                      ),
                      Center(
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: () {
                              context.read<LoginpagCubit>().loginUser(context, username.text.trim(), password.text.trim());
                            },
                            child:
                            Container(
                                width: width * 0.85,
                                height: height * 0.0753,
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.056,
                                    vertical: height * 0.025),
                                decoration: BoxDecoration(
                                  color: Color(0xff004673), // Full opacity
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    "LOG IN",
                                    style: TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontFamily: 'Sora',
                                      fontWeight: FontWeight.w600, // 600 = SemiBold
                                      fontSize: width * 0.034,
                                      height: 1.5, // 150% line height = 1.5
                                      letterSpacing: 0, // 0% letter spacing
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.020,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            final parentContext = context;
                            final emailController = TextEditingController();

                            // Step 1: Email Dialog
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) {
                                String? errorText; // 👈 error message holder

                                return StatefulBuilder(
                                    builder: (dialogContext,setState) {
                                      return Dialog(
                                        backgroundColor: Colors.white,

                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                16)),
                                        child: Padding(
                                          padding:  EdgeInsets.all(width * 0.05),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Reset Password",
                                                    style: TextStyle(
                                                      fontSize: width * 0.05,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Icon(Icons.vpn_key, size: width * 0.06),
                                                ],
                                              ),
                                              SizedBox(height: height * 0.02),
                                              Text(
                                                "Enter your email address linked to your account",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: width * 0.035,
                                                    color: Colors.grey[700]),
                                              ),
                                              SizedBox(height: height * 0.02),
                                              TextField(
                                                controller: emailController,
                                                decoration: InputDecoration(
                                                  hintText: ' email or Phone number ',
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(12),
                                                  ),
                                                  contentPadding:  EdgeInsets
                                                      .symmetric(
                                                    horizontal: width * 0.03,
                                                    vertical: height * 0.015,
                                                  ),
                                                ),
                                                keyboardType: TextInputType.text,
                                              ),
                                              SizedBox(height: height * 0.02),
                                              if (errorText != null) ...[
                                                SizedBox(height: height * 0.02),
                                                Text(
                                                  errorText!,
                                                  style:
                                                  TextStyle(color: Colors.red,
                                                      fontSize: width * 0.035),
                                                ),
                                              ],
                                              // Info Text
                                              Text(
                                                "A link will be sent to your email for resetting your password & username",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: width * 0.03,
                                                    color: Colors.grey[600]),
                                              ),
                                              SizedBox(height: height * 0.02),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      if (emailController.text
                                                          .trim()
                                                          .isEmpty) {
                                                        setState(() {
                                                          errorText =
                                                          "Please enter email or phone number";
                                                        });
                                                        return;

                                                      } else {
                                                        setState(() {
                                                          errorText =
                                                          null; // clear error
                                                        });
                                                        // ✅ Continue with OTP
                                                      }
                                                      final email = emailController
                                                          .text.trim();

                                                      // Step 1: Trigger resetPassword Cubit
                                                      await parentContext.read<
                                                          ResetpasswordCubit>()
                                                          .resetPassword(
                                                        email: email,
                                                        context: parentContext,
                                                      );
                                                      Navigator.pop(context);

                                                      // Step 2: OTP Dialog
                                                      final otpController = TextEditingController();
                                                      String? otpError;

                                                      showDialog(
                                                        context: parentContext,
                                                        barrierDismissible: false,
                                                        builder: (_) {
                                                          String formatTime(int seconds) {
                                                            final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
                                                            final secs = (seconds % 60).toString().padLeft(2, '0');
                                                            return "$minutes:$secs";
                                                          }
                                                          int secondsRemaining = 600; // ⏱ initial countdown
                                                          Timer? timer;
                                                          return StatefulBuilder(
                                                            builder: (context,
                                                                setState) {
                                                              timer ??= Timer.periodic(const Duration(seconds: 1), (t) {
                                                                if (secondsRemaining > 0) {
                                                                  setState(() => secondsRemaining--);
                                                                } else {
                                                                  t.cancel();
                                                                }
                                                              });
                                                              return Dialog(
                                                                backgroundColor: Colors.white,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius
                                                                        .circular(
                                                                        16)),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .all(20),
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize
                                                                        .min,
                                                                    children: [
                                                                      Text(
                                                                        'Enter OTP',
                                                                        style: TextStyle(
                                                                            fontSize: width * 0.05,
                                                                            fontWeight: FontWeight
                                                                                .bold),
                                                                      ),
                                                                      SizedBox(height: height * 0.02),

                                                                      Text(
                                                                        'A verification code has been sent to your email.',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .grey,
                                                                            fontSize: width * 0.035
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height: height * 0.02),

                                                                      // ✅ Pinput OTP (6 digits)
                                                                      Pinput(
                                                                        length: 6,
                                                                        controller: otpController,
                                                                        defaultPinTheme: PinTheme(
                                                                          width: 50,
                                                                          height: 50,
                                                                          textStyle:  TextStyle(
                                                                              fontSize: width * 0.05,
                                                                              color: Colors
                                                                                  .black),
                                                                          decoration: BoxDecoration(
                                                                            border: Border
                                                                                .all(
                                                                                color: Colors
                                                                                    .grey),
                                                                            borderRadius: BorderRadius
                                                                                .circular(
                                                                                12),
                                                                          ),
                                                                        ),
                                                                        focusedPinTheme: PinTheme(
                                                                          width: 50,
                                                                          height: 50,
                                                                          textStyle:  TextStyle(
                                                                              fontSize: width * 0.05,
                                                                              color: Colors
                                                                                  .black),
                                                                          decoration: BoxDecoration(
                                                                            border: Border
                                                                                .all(
                                                                                color: Colors
                                                                                    .blue),
                                                                            borderRadius: BorderRadius
                                                                                .circular(
                                                                                12),
                                                                          ),
                                                                        ),
                                                                        onChanged: (
                                                                            value) {
                                                                          if (otpError !=
                                                                              null) {
                                                                            setState(() {
                                                                              otpError =
                                                                              null;
                                                                            });
                                                                          }
                                                                        },
                                                                      ),


                                                                      if (otpError !=
                                                                          null)
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              top: 8),
                                                                          child: Text(
                                                                            otpError!,
                                                                            style:  TextStyle(
                                                                                color: Colors
                                                                                    .red,
                                                                                fontSize:width * 0.035 ),
                                                                          ),
                                                                        ),
                                                                      TextButton(
                                                                        onPressed: secondsRemaining == 0
                                                                            ? () async {
                                                                          // Call resend OTP API
                                                                          await parentContext
                                                                              .read<ResetpasswordCubit>()
                                                                              .resetPassword(
                                                                            email: email,
                                                                            context: parentContext,
                                                                          );

                                                                          setState(() {
                                                                            secondsRemaining = 600; // restart 10 min countdown
                                                                            timer?.cancel();
                                                                            timer = null;
                                                                          });
                                                                        }
                                                                            : null,
                                                                        child: Text(
                                                                          secondsRemaining > 0
                                                                              ? "Resend in ${formatTime(secondsRemaining)}"
                                                                              : "Resend OTP",
                                                                          style: TextStyle(
                                                                            color: secondsRemaining == 0 ? Colors.blue : Colors.grey,
                                                                          ),
                                                                        ),
                                                                      ),                                                                   SizedBox(
                                                                          height: height * 0.03),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .center,
                                                                        children: [

                                                                          InkWell(
                                                                            onTap: () async {
                                                                              final otp = otpController
                                                                                  .text
                                                                                  .trim();
                                                                              final isVerified = await parentContext
                                                                                  .read<
                                                                                  ResetpasswordCubit>()
                                                                                  .verifyOtp(
                                                                                email: email,
                                                                                otp: otp,
                                                                                context: parentContext,
                                                                              );

                                                                              if (isVerified) {
                                                                                Navigator
                                                                                    .pop(
                                                                                    parentContext);

                                                                                // Step 3: New Password Dialog
                                                                                final passController = TextEditingController();
                                                                                final confirmPassController = TextEditingController();

                                                                                showDialog(
                                                                                  context: parentContext,
                                                                                  barrierDismissible: false,
                                                                                  builder: (
                                                                                      _) {
                                                                                    return Dialog(
                                                                                      backgroundColor: Colors.white,

                                                                                      shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius
                                                                                              .circular(
                                                                                              16)),
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets
                                                                                            .all(
                                                                                            20),
                                                                                        child: Column(
                                                                                          mainAxisSize: MainAxisSize
                                                                                              .min,
                                                                                          children: [
                                                                                            Text(
                                                                                              'Set New Password',
                                                                                              style: TextStyle(
                                                                                                  fontSize: width *0.05 ,
                                                                                                  fontWeight: FontWeight
                                                                                                      .bold),
                                                                                            ),
                                                                                            SizedBox(
                                                                                                height: height * 0.02),
                                                                                            TextField(
                                                                                              controller: passController,
                                                                                              obscureText: true,
                                                                                              decoration: InputDecoration(
                                                                                                hintText: "New Password",
                                                                                                border: OutlineInputBorder(
                                                                                                    borderRadius: BorderRadius
                                                                                                        .circular(
                                                                                                        12)),
                                                                                                contentPadding:  EdgeInsets
                                                                                                    .symmetric(
                                                                                                    horizontal:width * 0.03 ,
                                                                                                    vertical: height * 0.015),
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                                height: height * 0.02),
                                                                                            TextField(
                                                                                              controller: confirmPassController,
                                                                                              obscureText: true,
                                                                                              decoration: InputDecoration(
                                                                                                hintText: "Confirm Password",
                                                                                                border: OutlineInputBorder(
                                                                                                    borderRadius: BorderRadius
                                                                                                        .circular(
                                                                                                        12)),
                                                                                                contentPadding:  EdgeInsets
                                                                                                    .symmetric(
                                                                                                    horizontal: width * 0.03,
                                                                                                    vertical: height * 0.015),
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                                height: height *0.03),
                                                                                            Row(
                                                                                              mainAxisAlignment: MainAxisAlignment
                                                                                                  .center,
                                                                                              children: [

                                                                                                InkWell(
                                                                                                  onTap: () async {
                                                                                                    await parentContext
                                                                                                        .read<
                                                                                                        ResetpasswordCubit>()
                                                                                                        .confirmPasswordChange(
                                                                                                      context: parentContext,
                                                                                                      email: email,
                                                                                                      password: passController
                                                                                                          .text
                                                                                                          .trim(),
                                                                                                      confirmPassword: confirmPassController
                                                                                                          .text
                                                                                                          .trim(),
                                                                                                    );
                                                                                                    Navigator
                                                                                                        .pop(
                                                                                                        parentContext);
                                                                                                  },
                                                                                                  child: Container(
                                                                                                    width: width *
                                                                                                        0.7,
                                                                                                    height: height *
                                                                                                        0.054,
                                                                                                    padding: EdgeInsets
                                                                                                        .symmetric(
                                                                                                        horizontal: width * 0.056,
                                                                                                        vertical: 12),
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: Colors
                                                                                                          .black,
                                                                                                      borderRadius: BorderRadius
                                                                                                          .circular(
                                                                                                          12),
                                                                                                    ),
                                                                                                    child: Center(
                                                                                                      child: Text(
                                                                                                        "Submit",
                                                                                                        style: TextStyle(
                                                                                                            color: Colors
                                                                                                                .white),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              } else {
                                                                                setState(() {
                                                                                  otpError =
                                                                                  "Invalid OTP, please try again";
                                                                                });
                                                                              }
                                                                            },
                                                                            child: Container(
                                                                              width: width *
                                                                                  0.7,
                                                                              height: height *
                                                                                  0.054,
                                                                              padding:  EdgeInsets
                                                                                  .symmetric(
                                                                                  horizontal: width * 0.056 ,
                                                                                  vertical: height * 0.015),
                                                                              decoration: BoxDecoration(
                                                                                color: Colors
                                                                                    .black,
                                                                                borderRadius: BorderRadius
                                                                                    .circular(
                                                                                    12),
                                                                              ),
                                                                              child: Center(
                                                                                child: const Text(
                                                                                  "Verify",
                                                                                  style: TextStyle(
                                                                                      color: Colors
                                                                                          .white),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Center(
                                                      child: Container(
                                                        width: width * 0.7,
                                                        height: height * 0.054,
                                                        decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius: BorderRadius
                                                              .circular(12),
                                                        ),
                                                        child: Center(
                                                          child: const Text(
                                                            "OK",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );

                                    }
                                );

                              },
                            );
                          },
                          child:  Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w400,
                              fontSize: width * 0.04,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: height * 0.029,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, 'GoogleSignInPage');
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => GoogleSignInPage(),));
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Not yet registered?  ',
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.w400, // normal weight
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                    fontFamily: 'Sora',
                                    fontSize: width * 0.045,
                                    fontWeight: FontWeight.w600, // semi-bold
                                    color: Color(0xffEB8125), // orange
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );

              return Padding(

                padding: EdgeInsets.only(
                  bottom: 108.0 + MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.07,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.061),
                      child: Container(
                        width: width * 0.63,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
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
                                  borderRadius: BorderRadius.circular(
                                      circleSize / 2), // perfectly circular
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_left_outlined,
                                    size: circleSize * 0.45, // responsive icon size
                                    color: Color(0xff313131),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: width * 0.4,
                              height: height * 0.07,
                              decoration: BoxDecoration(),
                              child: Image.asset(
                                "assets/images/logos/image 1.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.0215,
                    ),
                    Center(
                      child: Text(
                        "Welcome Back !",
                        style: TextStyle(
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w600, // SemiBold
                          fontSize: width * 0.072,
                          height: 32 / 26, // line-height ÷ font-size = 1.23
                          letterSpacing: 0, // 0%
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.033,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          context.read<LoginCubit>().signIn(context); // or "employer", "admin"

                        },
                        child: Container(
                            width: width * 0.85,
                            height: height * 0.0753,
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.056,
                                vertical: height * 0.025),
                            decoration: BoxDecoration(
                              color: Color(0xff004673), // Full opacity
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: circleSize,
                                  height: circleSize,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        circleSize / 2), // perfectly circular
                                  ),
                                  child: Center(
                                      child: Image.asset(
                                          "assets/images/logos/google.png")),
                                ),

                                SizedBox(width: width * 0.01),

                                Center(
                                  child: Text(
                                    "Log in with google",
                                    style: TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontFamily: 'Sora',
                                      fontWeight: FontWeight.w600, // 600 = SemiBold
                                      fontSize: width * 0.034,
                                      height: 1.5, // 150% line height = 1.5
                                      letterSpacing: 0, // 0% letter spacing
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: height*0.02,),

                    Center(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16), // ripple effect follows shape
                        onTap: () {
                          PhoneLoginDialog.show(context);

                          },
                        child: Container(
                          width: width * 0.85,
                          height: height * 0.0753,
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.056,
                            vertical: height * 0.025,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xff004673), // Full opacity
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.call,
                                color: Colors.white,
                                size: width * 0.04,
                              ),
                              SizedBox(width: width * 0.039),
                              Center(
                                child: Text(
                                  "Log in with Phone",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Sora',
                                    fontWeight: FontWeight.w600,
                                    fontSize: width * 0.034,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Center(
                    //   child: SizedBox(
                    //     width: width * 0.389,
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         InkWell(
                    //           onTap: () {
                    //             if (isChecked) {
                    //               context.read<LoginCubit>().signIn(context); // or "employer", "admin"
                    //             } else {
                    //               ScaffoldMessenger.of(context).showSnackBar(
                    //                 SnackBar(
                    //                   content: Text(
                    //                       "Please accept the Privacy Policy to continue."),
                    //                   backgroundColor: Colors.redAccent,
                    //                   behavior: SnackBarBehavior.floating,
                    //                   duration: Duration(seconds: 2),
                    //                   shape: RoundedRectangleBorder(
                    //                     borderRadius: BorderRadius.circular(8),
                    //                   ),
                    //                 ),
                    //               );
                    //             }
                    //           },
                    //           child:
                    //           Container(
                    //             width: circleSize,
                    //             height: circleSize,
                    //             decoration: BoxDecoration(
                    //               color: Colors.transparent,
                    //               border: Border.all(
                    //                 width: 1,
                    //                 color: Color(0xffE3E3E3),
                    //               ),
                    //               borderRadius: BorderRadius.circular(
                    //                   circleSize / 2), // perfectly circular
                    //             ),
                    //             child: Center(
                    //                 child: Image.asset(
                    //                     "assets/images/logos/google.png")),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: height * 0.039,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: width * 0.35, // adjust line length
                          height: height * 0.001,
                          color: Colors.grey.shade400,
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal:width * 0.02 ),
                          child: Text(
                            "OR",
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: width *0.033,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          width: width * 0.35, // adjust line length
                          height: height * 0.001,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.025,
                    ),
                    Center(
                        child: textform(
                            hint: "Name",
                            controllers: username,
                            context: context)),
                    SizedBox(
                      height: height * 0.021,
                    ),
                    Center(
                      child: Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          width: width * 0.85,
                          height: height * 0.0753,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: TextFormField(
                              controller: password,
                              obscureText: obscureText,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Password',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: height * 0.025,
                                    horizontal: width * 0.033),
                                suffixIcon: Padding(
                                  padding: EdgeInsets.only(
                                      right: width *
                                          0.022), // 👈 Adjust padding here
                                  child: IconButton(
                                    icon: Icon(
                                      obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
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
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Center(
                      child: Container(
                        width: width * 0.85,

                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Sora',
                                    fontSize: width * 0.038),
                                children: [
                                  TextSpan(text: 'By logging in, you agree to our ',style: TextStyle(fontSize: width * 0.03)),
                                  TextSpan(
                                    text: 'Terms and Conditions',
                                    style: TextStyle(
                                      fontSize: width * 0.03,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {

                                        showEmployerTermsDialog(context);                                    },
                                  ),
                                ],
                              ),
                            ),
                            // SizedBox(
                            //   width: width * 0.24,
                            // ),
                            // StatefulBuilder(
                            //   builder: (context, setState) {
                            //     return Checkbox(
                            //       value: isChecked,
                            //       onChanged: (value) {
                            //         setState(() {
                            //           isChecked = value ?? false;
                            //         });
                            //       },
                            //       activeColor: Color(
                            //           0xffEB8125), // Fill color when checked
                            //       checkColor: Colors.white, // Tick color
                            //       side: BorderSide(
                            //         color: Color(0xffEB8125),
                            //       ), // Border color when unchecked
                            //     );
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.06,
                    ),
                    Center(
                      child: Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          onTap: () {
                              context.read<LoginpagCubit>().loginUser(context, username.text.trim(), password.text.trim());
                              },
                          child:
                          Container(
                              width: width * 0.85,
                              height: height * 0.0753,
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.056,
                                  vertical: height * 0.025),
                              decoration: BoxDecoration(
                                color: Color(0xff004673), // Full opacity
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  "LOG IN",
                                  style: TextStyle(
                                    color: Color(0xffFFFFFF),
                                    fontFamily: 'Sora',
                                    fontWeight: FontWeight.w600, // 600 = SemiBold
                                    fontSize: width * 0.034,
                                    height: 1.5, // 150% line height = 1.5
                                    letterSpacing: 0, // 0% letter spacing
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.020,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          final parentContext = context;
                          final emailController = TextEditingController();

                          // Step 1: Email Dialog
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              String? errorText; // 👈 error message holder

                              return StatefulBuilder(
                                builder: (dialogContext,setState) {
                                  return Dialog(
                                    backgroundColor: Colors.white,

                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            16)),
                                    child: Padding(
                                      padding:  EdgeInsets.all(width * 0.05),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text(
                                                "Reset Password",
                                                style: TextStyle(
                                                  fontSize: width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Icon(Icons.vpn_key, size: width * 0.06),
                                            ],
                                          ),
                                          SizedBox(height: height * 0.02),
                                          Text(
                                            "Enter your email address linked to your account",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: width * 0.035,
                                                color: Colors.grey[700]),
                                          ),
                                          SizedBox(height: height * 0.02),
                                          TextField(
                                            controller: emailController,
                                            decoration: InputDecoration(
                                              hintText: ' email or Phone number ',
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius
                                                    .circular(12),
                                              ),
                                              contentPadding:  EdgeInsets
                                                  .symmetric(
                                                horizontal: width * 0.03,
                                                vertical: height * 0.015,
                                              ),
                                            ),
                                            keyboardType: TextInputType.text,
                                          ),
                                          SizedBox(height: height * 0.02),
                                          if (errorText != null) ...[
                                            SizedBox(height: height * 0.02),
                                            Text(
                                              errorText!,
                                              style:
                                               TextStyle(color: Colors.red,
                                                  fontSize: width * 0.035),
                                            ),
                                          ],
                                          // Info Text
                                          Text(
                                            "A link will be sent to your email for resetting your password & username",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: width * 0.03,
                                                color: Colors.grey[600]),
                                          ),
                                          SizedBox(height: height * 0.02),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  if (emailController.text
                                                      .trim()
                                                      .isEmpty) {
                                                    setState(() {
                                                      errorText =
                                                      "Please enter email or phone number";
                                                    });
                                                    return;

                                                  } else {
                                                    setState(() {
                                                      errorText =
                                                      null; // clear error
                                                    });
                                                    // ✅ Continue with OTP
                                                  }
                                                  final email = emailController
                                                      .text.trim();

                                                  // Step 1: Trigger resetPassword Cubit
                                                  await parentContext.read<
                                                      ResetpasswordCubit>()
                                                      .resetPassword(
                                                    email: email,
                                                    context: parentContext,
                                                  );
                                                  Navigator.pop(context);

                                                  // Step 2: OTP Dialog
                                                  final otpController = TextEditingController();
                                                  String? otpError;

                                                  showDialog(
                                                    context: parentContext,
                                                    barrierDismissible: false,
                                                    builder: (_) {
                                                      String formatTime(int seconds) {
                                                        final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
                                                        final secs = (seconds % 60).toString().padLeft(2, '0');
                                                        return "$minutes:$secs";
                                                      }
                                                      int secondsRemaining = 600; // ⏱ initial countdown
                                                      Timer? timer;
                                                      return StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                          timer ??= Timer.periodic(const Duration(seconds: 1), (t) {
                                                            if (secondsRemaining > 0) {
                                                              setState(() => secondsRemaining--);
                                                            } else {
                                                              t.cancel();
                                                            }
                                                          });
                                                          return Dialog(
                                                            backgroundColor: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .circular(
                                                                    16)),
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                  .all(20),
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize
                                                                    .min,
                                                                children: [
                                                                   Text(
                                                                    'Enter OTP',
                                                                    style: TextStyle(
                                                                        fontSize: width * 0.05,
                                                                        fontWeight: FontWeight
                                                                            .bold),
                                                                  ),
                                                                  SizedBox(height: height * 0.02),

                                                                   Text(
                                                                    'A verification code has been sent to your email.',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize: width * 0.035
                                                                    ),
                                                                  ),
                                                                   SizedBox(
                                                                      height: height * 0.02),

                                                                  // ✅ Pinput OTP (6 digits)
                                                                  Pinput(
                                                                    length: 6,
                                                                    controller: otpController,
                                                                    defaultPinTheme: PinTheme(
                                                                      width: 50,
                                                                      height: 50,
                                                                      textStyle:  TextStyle(
                                                                          fontSize: width * 0.05,
                                                                          color: Colors
                                                                              .black),
                                                                      decoration: BoxDecoration(
                                                                        border: Border
                                                                            .all(
                                                                            color: Colors
                                                                                .grey),
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            12),
                                                                      ),
                                                                    ),
                                                                    focusedPinTheme: PinTheme(
                                                                      width: 50,
                                                                      height: 50,
                                                                      textStyle:  TextStyle(
                                                                          fontSize: width * 0.05,
                                                                          color: Colors
                                                                              .black),
                                                                      decoration: BoxDecoration(
                                                                        border: Border
                                                                            .all(
                                                                            color: Colors
                                                                                .blue),
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            12),
                                                                      ),
                                                                    ),
                                                                    onChanged: (
                                                                        value) {
                                                                      if (otpError !=
                                                                          null) {
                                                                        setState(() {
                                                                          otpError =
                                                                          null;
                                                                        });
                                                                      }
                                                                    },
                                                                  ),


                                                                  if (otpError !=
                                                                      null)
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top: 8),
                                                                      child: Text(
                                                                        otpError!,
                                                                        style:  TextStyle(
                                                                            color: Colors
                                                                                .red,
                                                                            fontSize:width * 0.035 ),
                                                                      ),
                                                                    ),
                                                                  TextButton(
                                                                    onPressed: secondsRemaining == 0
                                                                        ? () async {
                                                                      // Call resend OTP API
                                                                      await parentContext
                                                                          .read<ResetpasswordCubit>()
                                                                          .resetPassword(
                                                                        email: email,
                                                                        context: parentContext,
                                                                      );

                                                                      setState(() {
                                                                        secondsRemaining = 600; // restart 10 min countdown
                                                                        timer?.cancel();
                                                                        timer = null;
                                                                      });
                                                                    }
                                                                        : null,
                                                                    child: Text(
                                                                      secondsRemaining > 0
                                                                          ? "Resend in ${formatTime(secondsRemaining)}"
                                                                          : "Resend OTP",
                                                                      style: TextStyle(
                                                                        color: secondsRemaining == 0 ? Colors.blue : Colors.grey,
                                                                      ),
                                                                    ),
                                                                  ),                                                                   SizedBox(
                                                                      height: height * 0.03),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment
                                                                        .center,
                                                                    children: [

                                                                      InkWell(
                                                                        onTap: () async {
                                                                          final otp = otpController
                                                                              .text
                                                                              .trim();
                                                                          final isVerified = await parentContext
                                                                              .read<
                                                                              ResetpasswordCubit>()
                                                                              .verifyOtp(
                                                                            email: email,
                                                                            otp: otp,
                                                                            context: parentContext,
                                                                          );

                                                                          if (isVerified) {
                                                                            Navigator
                                                                                .pop(
                                                                                parentContext);

                                                                            // Step 3: New Password Dialog
                                                                            final passController = TextEditingController();
                                                                            final confirmPassController = TextEditingController();

                                                                            showDialog(
                                                                              context: parentContext,
                                                                              barrierDismissible: false,
                                                                              builder: (
                                                                                  _) {
                                                                                return Dialog(
                                                                                  backgroundColor: Colors.white,

                                                                                  shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius
                                                                                          .circular(
                                                                                          16)),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets
                                                                                        .all(
                                                                                        20),
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize
                                                                                          .min,
                                                                                      children: [
                                                                                         Text(
                                                                                          'Set New Password',
                                                                                          style: TextStyle(
                                                                                              fontSize: width *0.05 ,
                                                                                              fontWeight: FontWeight
                                                                                                  .bold),
                                                                                        ),
                                                                                         SizedBox(
                                                                                            height: height * 0.02),
                                                                                        TextField(
                                                                                          controller: passController,
                                                                                          obscureText: true,
                                                                                          decoration: InputDecoration(
                                                                                            hintText: "New Password",
                                                                                            border: OutlineInputBorder(
                                                                                                borderRadius: BorderRadius
                                                                                                    .circular(
                                                                                                    12)),
                                                                                            contentPadding:  EdgeInsets
                                                                                                .symmetric(
                                                                                                horizontal:width * 0.03 ,
                                                                                                vertical: height * 0.015),
                                                                                          ),
                                                                                        ),
                                                                                         SizedBox(
                                                                                            height: height * 0.02),
                                                                                        TextField(
                                                                                          controller: confirmPassController,
                                                                                          obscureText: true,
                                                                                          decoration: InputDecoration(
                                                                                            hintText: "Confirm Password",
                                                                                            border: OutlineInputBorder(
                                                                                                borderRadius: BorderRadius
                                                                                                    .circular(
                                                                                                    12)),
                                                                                            contentPadding:  EdgeInsets
                                                                                                .symmetric(
                                                                                                horizontal: width * 0.03,
                                                                                                vertical: height * 0.015),
                                                                                          ),
                                                                                        ),
                                                                                         SizedBox(
                                                                                            height: height *0.03),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment
                                                                                              .center,
                                                                                          children: [

                                                                                            InkWell(
                                                                                              onTap: () async {
                                                                                                await parentContext
                                                                                                    .read<
                                                                                                    ResetpasswordCubit>()
                                                                                                    .confirmPasswordChange(
                                                                                                  context: parentContext,
                                                                                                  email: email,
                                                                                                  password: passController
                                                                                                      .text
                                                                                                      .trim(),
                                                                                                  confirmPassword: confirmPassController
                                                                                                      .text
                                                                                                      .trim(),
                                                                                                );
                                                                                                Navigator
                                                                                                    .pop(
                                                                                                    parentContext);
                                                                                              },
                                                                                              child: Container(
                                                                                                width: width *
                                                                                                    0.7,
                                                                                                height: height *
                                                                                                    0.054,
                                                                                                padding: EdgeInsets
                                                                                                    .symmetric(
                                                                                                    horizontal: width * 0.056,
                                                                                                    vertical: 12),
                                                                                                decoration: BoxDecoration(
                                                                                                  color: Colors
                                                                                                      .black,
                                                                                                  borderRadius: BorderRadius
                                                                                                      .circular(
                                                                                                      12),
                                                                                                ),
                                                                                                child: Center(
                                                                                                  child: Text(
                                                                                                    "Submit",
                                                                                                    style: TextStyle(
                                                                                                        color: Colors
                                                                                                            .white),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            );
                                                                          } else {
                                                                            setState(() {
                                                                              otpError =
                                                                              "Invalid OTP, please try again";
                                                                            });
                                                                          }
                                                                        },
                                                                        child: Container(
                                                                          width: width *
                                                                              0.7,
                                                                          height: height *
                                                                              0.054,
                                                                          padding:  EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: width * 0.056 ,
                                                                              vertical: height * 0.015),
                                                                          decoration: BoxDecoration(
                                                                            color: Colors
                                                                                .black,
                                                                            borderRadius: BorderRadius
                                                                                .circular(
                                                                                12),
                                                                          ),
                                                                          child: Center(
                                                                            child: const Text(
                                                                              "Verify",
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .white),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Center(
                                                  child: Container(
                                                    width: width * 0.7,
                                                    height: height * 0.054,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius: BorderRadius
                                                          .circular(12),
                                                    ),
                                                    child: Center(
                                                      child: const Text(
                                                        "OK",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );

                                }
                              );

                            },
                          );
                        },
                        child:  Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w400,
                            fontSize: width * 0.04,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: height * 0.029,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, 'GoogleSignInPage');
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => GoogleSignInPage(),));
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Not yet registered?  ',
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontSize: width * 0.045,
                              fontWeight: FontWeight.w400, // normal weight
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontSize: width * 0.045,
                                  fontWeight: FontWeight.w600, // semi-bold
                                  color: Color(0xffEB8125), // orange
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
),
      ),
    );
  }
}

Widget textform(
    {required BuildContext context,
    TextEditingController? controllers,
    String? hint,
    Icon? iconforsuffix}) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  return Material(
    elevation: 1,
    borderRadius: BorderRadius.circular(15),
    child: Container(
      width: width * 0.85,
      height: height * 0.0753,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Align(
        alignment: Alignment.center,
        child: TextFormField(
          controller: controllers,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            suffixIcon: Padding(
                padding: EdgeInsets.only(
                    right: width * 0.033), // 👈 Adjust padding here
                child: iconforsuffix),
            contentPadding: EdgeInsets.symmetric(
                vertical: height * 0.025, horizontal: width * 0.039),

          ),
        ),
      ),
    ),
  );
}
void showEmployerTermsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Terms & Conditions for Employers',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('(Effective Date: 8/4/2025)\n'),
              Text('1. General Terms\n', style: TextStyle(fontWeight: FontWeight.bold)),
              BulletText('By registering on StudentsGigs.com, you agree to follow these terms when posting jobs or hiring students.'),
              BulletText('Employers must comply with local labor laws and ethical employment standards.'),
              BulletText('StudentsGigs.com is not responsible for candidate behavior, job performance, or damages caused by students.'),

              SizedBox(height: 12),
              Text('2. Job Posting & Recruitment Policies\n', style: TextStyle(fontWeight: FontWeight.bold)),
              BulletText('Employers must provide accurate job descriptions and salary details.'),
              BulletText('Employers must not post misleading or false job advertisements.'),
              BulletText('Employers must not demand money from students for job placements.'),
              BulletText('Employers must not offer jobs that violate labor laws or involve unsafe working conditions.'),
              BulletText('Employers must treat students professionally and fairly.'),

              SizedBox(height: 12),
              Text('3. Salary, Payments & Disputes\n', style: TextStyle(fontWeight: FontWeight.bold)),
              BulletText('Employers are fully responsible for paying students on time and as agreed.'),
              BulletText('StudentsGigs.com does not handle or guarantee salary payments.'),
              BulletText('If salary disputes arise, the student and employer must resolve them directly.'),
              BulletText('Non-payment complaints may result in employer account suspension.'),

              SizedBox(height: 12),
              Text('4. Workplace Conduct & Legal Compliance\n', style: TextStyle(fontWeight: FontWeight.bold)),
              BulletText('Employers must provide a safe and respectful workplace.'),
              BulletText('Employers must not engage in harassment, discrimination, or abuse towards students.'),
              BulletText('Employers must not force unpaid labor or unethical working conditions.'),
              BulletText('Employers must not collect personal data for non-job-related activities.'),
              BulletText('Employers are liable for any legal actions due to labor law violations.'),

              SizedBox(height: 12),
              Text('5. Employer Responsibilities & Liabilities\n', style: TextStyle(fontWeight: FontWeight.bold)),
              BulletText('If an employer misuses student contact details, they may face a ban from the platform.'),
              BulletText('If a student causes damage to company property, the employer must handle the issue directly.'),
              BulletText('StudentsGigs.com is not responsible for student misconduct or damage caused at the workplace.'),

              SizedBox(height: 12),
              Text('6. Platform Usage & Restrictions\n', style: TextStyle(fontWeight: FontWeight.bold)),
              BulletText('Employers must not post illegal, inappropriate, or misleading job listings.'),
              BulletText('Employers must not share student details with third parties.'),
              BulletText('Employers must not use the platform for non-recruitment purposes.'),
              BulletText('Repeated violations will result in a permanent ban from the platform.'),

              SizedBox(height: 12),
              Text('7. Dispute Resolution & Legal Disclaimer\n', style: TextStyle(fontWeight: FontWeight.bold)),
              BulletText('Employers and students must resolve disputes between themselves.'),
              BulletText('StudentsGigs.com only acts as an intermediary and is not responsible for disputes.'),
              BulletText('Any legal claims must be directed towards the responsible party, not StudentsGigs.com.'),

              SizedBox(height: 12),
              Text('8. Agreement & Acknowledgment\n', style: TextStyle(fontWeight: FontWeight.bold)),
              BulletText('By registering, you agree to these terms and acknowledge that StudentsGigs.com is not responsible for employment-related disputes.'),
              BulletText('Click "Agree" to continue using the platform.'),
              BulletText('Note: These terms and conditions are designed to protect both students and employers, ensuring a fair and safe environment on StudentsGigs.com.'),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}
class BulletText extends StatelessWidget {
  final String text;
  const BulletText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),

          ),
        ],
      ),

    );
  }
}



class PhoneLoginDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        bool showOtpField = false;
        String phoneNumber = "";
        String enteredOtp = "";
        int remainingSeconds = 600; // 10 minutes
        Timer? timer;

        return BlocProvider(
          create: (_) => PhoneCubit(),
          child: StatefulBuilder(
            builder: (context, setState) {
              void startTimer() {
                timer?.cancel();
                remainingSeconds = 600;
                timer = Timer.periodic(const Duration(seconds: 1), (t) {
                  if (remainingSeconds > 0) {
                    setState(() => remainingSeconds--);
                  } else {
                    t.cancel();
                  }
                });
              }

              String formatTime(int seconds) {
                final minutes = (seconds ~/ 60).toString();
                final secs = (seconds % 60).toString().padLeft(2, '0');
                return "$minutes:$secs";
              }

              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: const EdgeInsets.all(20),
                content: BlocConsumer<PhoneCubit, PhoneState>(
                  listener: (context, state) {
                    if (state is PhoneOtpSent) {
                      setState(() => showOtpField = true);
                      startTimer();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("OTP Sent ✅")),
                      );
                    }
                    if (state is PhoneVerified) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Phone Verified ✅")),
                      );

                      // 👉 You can store tokens here if needed
                      // final access = state.accessToken;
                      // final refresh = state.refreshToken;
                    }
                    if (state is PhoneError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("❌ ${state.message}")),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Title
                        Text(
                          showOtpField
                              ? "OTP Verification"
                              : "Enter Your Mobile Number",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          showOtpField
                              ? "Enter the code sent to your Mobile Number"
                              : "We’ll send an OTP to your Mobile Number",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Phone Input
                        if (!showOtpField)
                          IntlPhoneField(
                            initialCountryCode: 'IN',
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                BorderSide(color: Colors.grey.shade400),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1.2),
                              ),
                              hintText: "Enter phone number",
                            ),
                            onChanged: (phone) {
                              phoneNumber = phone.completeNumber;
                            },
                          ),

                        // OTP Field
                        if (showOtpField)
                          Pinput(
                            length: 6,
                            showCursor: true,
                            onCompleted: (otp) {
                              enteredOtp = otp;
                            },
                          ),
                        if (state is PhoneError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              state.message,
                              style: const TextStyle(color: Colors.red, fontSize: 14),
                            ),
                          ),

                        const SizedBox(height: 16),

                        // Timer
                        if (showOtpField)
                          Text(
                            remainingSeconds > 0
                                ? "OTP Expires In ${formatTime(remainingSeconds)}"
                                : "OTP Expired",
                            style: TextStyle(
                              fontSize: 14,
                              color: remainingSeconds > 0
                                  ? Colors.black
                                  : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                        const SizedBox(height: 20),

                        // Verify Button
                        if (showOtpField)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (enteredOtp.isNotEmpty) {
                                  context.read<PhoneCubit>().verifyOtp(context,phoneNumber, enteredOtp);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Please enter the OTP first")),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: state is PhoneLoading
                                  ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                                  : const Text(
                                "Verify",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                        // Send / Resend OTP Button
                        if (!showOtpField)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (phoneNumber.isNotEmpty) {
                                  context
                                      .read<PhoneCubit>()
                                      .sendOtp(phoneNumber);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Please enter a valid phone number")),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: state is PhoneLoading
                                  ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                                  : const Text(
                                "Send OTP",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                        if (showOtpField)
                          TextButton.icon(
                            onPressed: remainingSeconds == 0
                                ? () {
                              context
                                  .read<PhoneCubit>()
                                  .sendOtp(phoneNumber);
                              startTimer();
                            }
                                : null,
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text("Resend OTP"),
                          ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}



