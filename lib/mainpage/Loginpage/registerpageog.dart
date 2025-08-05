import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';

import '../registerpage/loginpageog.dart';
import 'cubit/login_cubit.dart';
import 'cubit2/postregister_cubit.dart';
import 'cubit3/otp_cubit.dart';
import 'cubit4/resentotp_cubit.dart';

class GoogleSignInPage extends StatefulWidget {
  const GoogleSignInPage({super.key});

  @override
  State<GoogleSignInPage> createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  int remainingSeconds = 0;  // <-- Move here
  Timer? timer;
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final List<TextEditingController> controllers =
  List.generate(6, (_) => TextEditingController());
  bool obscureText = true;
  bool obscureTextconformpassword = true;

  bool isChecked = false;

  void toggleVisibility() {
    setState(() {
      obscureText = ! obscureText;
    });
  }
  void toggleVisibilityconformpasswrd() {
    setState(() {
      obscureTextconformpassword = ! obscureTextconformpassword;
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
      create: (_) => LoginCubit(),
),
    BlocProvider(
      create: (context) => PostregisterCubit(),
    ),
    BlocProvider(
      create: (context) => OtpCubit(),
    ),
    BlocProvider(
      create: (context) => ResentotpCubit(),
    ),
  ],
  child: Scaffold(
        backgroundColor: Color(0xffF9F2ED),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: MultiBlocListener(
               listeners: [
               BlocListener<PostregisterCubit, PostregisterState>(
                listener: (context, state) {
                  if (state is Postregisterloaded) {
                    int secondsRemaining = 0;
                    bool isTimerActive = false;
                    Timer? timer;

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: context.read<OtpCubit>()),
                          BlocProvider.value(value: context.read<ResentotpCubit>()),
                        ],
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            void startTimer() {
                              timer?.cancel();
                              setState(() {
                                isTimerActive = true;
                                secondsRemaining = 5;
                              });

                              timer = Timer.periodic(Duration(seconds: 1), (t) {
                                if (secondsRemaining <= 1) {
                                  t.cancel();
                                  setState(() {
                                    isTimerActive = false;
                                    secondsRemaining = 0;
                                  });
                                } else {
                                  setState(() {
                                    secondsRemaining--;
                                  });
                                }
                              });
                            }

                            return Dialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.06, // ≈24 on 400px wide screen
                                  vertical: height * 0.035, // ≈28 on 800px tall screen
                                ),                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          timer?.cancel();
                                          Navigator.pop(context);
                                        },
                                        child: Icon(Icons.close, color: Colors.grey[600]),
                                      ),
                                    ),
                                     SizedBox(height:height * 0.015),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:  [
                                        Text(
                                          'Verification Required',
                                          style: TextStyle(
                                            fontSize: width * 0.05,
                                            fontFamily: 'Sora',
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: width * 0.02),
                                        Icon(Icons.verified_outlined, color: Colors.black, size: width * 0.055),
                                      ],
                                    ),
                                     SizedBox(height: height * 0.015),
                                    Text(
                                      'Please enter the code sent to\n${emailController.text.trim()}',
                                      textAlign: TextAlign.center,
                                      style:  TextStyle(
                                        fontFamily: 'Sora',
                                        fontSize: width * 0.035,
                                        color: Colors.black87,
                                      ),
                                    ),
                                     SizedBox(height: height * 0.025),

                                    /// OTP Input
                                    OtpInputRow(controllers: controllers),
                                     SizedBox(height: height * 0.025),

                                    /// ✅ Verify Button
                                    ElevatedButton.icon(
                                      onPressed: isTimerActive
                                          ? null
                                          : () {
                                        context.read<OtpCubit>().verifyOtp(
                                          username: usernameController.text.trim(),
                                          password: passwordController.text.trim(),
                                          email: emailController.text.trim(),
                                          otp: controllers.map((c) => c.text).join().trim(),
                                        );
                                        startTimer();
                                      },
                                      icon:  Icon(Icons.verified, size: width * 0.045),
                                      label: Text(
                                        isTimerActive ? "Wait ${secondsRemaining}s" : "Verify",
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFF1E8FF),
                                        foregroundColor: Colors.deepPurple,
                                        minimumSize:  Size(double.infinity, height * 0.06),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                     SizedBox(height: height * 0.015),

                                    /// 🔁 Resend OTP Button
                                    OutlinedButton.icon(
                                      onPressed: isTimerActive
                                          ? null
                                          : () {
                                        context.read<ResentotpCubit>().resendOtp(emailController.text.trim());
                                        startTimer();
                                      },
                                      icon:  Icon(Icons.refresh, size: width * 0.045),
                                      label: Text(
                                        isTimerActive ? "Resend in ${secondsRemaining}s" : "Resend OTP",
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.deepPurple,
                                        minimumSize:  Size(double.infinity, height * 0.06),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        side: const BorderSide(color: Color(0xFFF1E8FF)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                  else if (state is Postregistererror) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: Color(0xffFFFFFF),
                        title: const Text("❌ Error"),
                        content: Text(state.error),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // close the dialog
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  }
                },
               ),
           BlocListener<OtpCubit, OtpState>(
        listener: (context, state) {
          if (state is OtpIoaded){
            print("hey shamil");
            Navigator.pop(context);

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                contentPadding: EdgeInsets.zero,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ✅ Green header with check icon
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),

                    // ✅ Success text and subtext
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      child: Column(
                        children: const [
                          Text(
                            'Success',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Transaction Completed Successfully!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ✅ Okay Button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        child: const Text(
                          'Okay',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }else if (state is Otperror){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ),
                backgroundColor: Colors.red,
              ),
            );

          }
        },
    ),
       ],
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
                  if (state is LoginIoading)
                    return Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.03,),


                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: width * 0.055),
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
                        SizedBox(height: height * 0.042,),
                        Center(
                          child: Text(
                            "Create your account ",
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w600, // SemiBold
                              fontSize: width * 0.065,
                              height: 32 / 26, // line-height ÷ font-size = 1.23
                              letterSpacing: 0, // 0%
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.04,),

                        Center(
                          child: Container(
                            width: width * 0.35,
                            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if(isChecked){
                                      context.read<LoginCubit>().signIn(context); // or "employer", "admin"

                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Please accept the Privacy Policy to continue."),
                                          backgroundColor: Colors.redAccent,
                                          behavior: SnackBarBehavior.floating,
                                          duration: Duration(seconds: 2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      );

                                    }

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

                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.04,),

                        Center(
                          child: Text(
                            "OR LOG IN WITH EMAIL",
                            style: TextStyle(
                              color: Color(0xffA1A4B2),
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w400, // Regular
                              fontSize: width * 0.035,
                              height: 1.43, // Approx. "Title Medium" line-height: ~20px / 14px = 1.43
                              letterSpacing: 14 * 0.05, // 5% of font size = 0.7
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.04,),


                        Center(child: textform(hint: "Name",iconforsuffix: Icon(Icons.keyboard_arrow_right),
                          controllers : usernameController, context: context,
                        )),
                        SizedBox(height: height * 0.028,),

                        Center(child: textform(hint: "Email",iconforsuffix: Icon(Icons.keyboard_arrow_right),controllers: emailController, context: context,
                        )),
                        SizedBox(height: height * 0.028,),


                        Center(
                          child: Material(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(15),

                            child: Container(
                              width: width * 0.85,
                              height: height * 0.065,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  controller: passwordController,
                                  obscureText: obscureText,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter password...',
                                    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.only(right: width * 0.02), // 👈 Adjust padding here
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
                        SizedBox(height: height * 0.018,),


                        Center(
                          child: Material(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(15),

                            child: Container(
                              width: width * 0.85,
                              height: height * 0.07,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  controller: confirmPasswordController,
                                  obscureText: obscureTextconformpassword,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'conform password...',
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: height * 0.02,  // ~16 on 800px height
                                      horizontal: width * 0.03, // ~12 on 400px width
                                    ),                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(right: width * 0.02), // 👈 Adjust padding here
                                    child: IconButton(
                                      icon: Icon(
                                        obscureTextconformpassword ? Icons.visibility_off : Icons.visibility,
                                        color: Color(0xff3F414E),
                                      ),
                                      onPressed: toggleVisibilityconformpasswrd,
                                    ),
                                  ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.018,),

                        Center(
                          child: Container(
                            width: width * 0.85,
                            child: Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(color: Colors.black, fontFamily: 'Sora',fontSize: width * 0.038),
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
                                SizedBox(width: width * 0.24,),
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
                        SizedBox(height: height * 0.03,),

                        Center(
                          child: Material(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(16),

                            child: InkWell(

                              onTap: () {
                                if(isChecked){
                                  context.read<PostregisterCubit>().registerUser(conformpassword:confirmPasswordController.text.trim(),email: emailController.text.trim(),password: passwordController.text.trim(),username: usernameController.text.trim() );
                                }
                                else {
                                  // Show alert if not checked
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Please accept the Privacy Policy to continue."),
                                      backgroundColor: Colors.redAccent,
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(seconds: 2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );

                                }
                              },
                              child: Container(
                                  width: width * 0.85,
                                  height: height * 0.07,
                                  padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
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
                                        fontSize: width * 0.04,
                                        height: 1.5, // 150% line height = 1.5
                                        letterSpacing: 0, // 0% letter spacing
                                      ),
                                    ),

                                  )
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.022,),

                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Registerpage(),));
                            },
                            child: RichText(
                              text: TextSpan(
                                text: 'Already have an account? ',
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontSize: width * 0.045,
                                  fontWeight: FontWeight.w400, // normal weight
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign In',
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

                        SizedBox(height: height * 0.03,),



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
                  else if (state is LoginIoaded)
                    return Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.03,),


                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: width * 0.055),
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
                        SizedBox(height: height * 0.042,),
                        Center(
                          child: Text(
                            "Create your account ",
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w600, // SemiBold
                              fontSize: width * 0.065,
                              height: 32 / 26, // line-height ÷ font-size = 1.23
                              letterSpacing: 0, // 0%
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.04,),

                        Center(
                          child: Container(
                            width: width * 0.35,
                            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if(isChecked){
                                      context.read<LoginCubit>().signIn(context); // or "employer", "admin"

                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Please accept the Privacy Policy to continue."),
                                          backgroundColor: Colors.redAccent,
                                          behavior: SnackBarBehavior.floating,
                                          duration: Duration(seconds: 2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      );

                                    }

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

                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.04,),

                        Center(
                          child: Text(
                            "OR LOG IN WITH EMAIL",
                            style: TextStyle(
                              color: Color(0xffA1A4B2),
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w400, // Regular
                              fontSize: width * 0.035,
                              height: 1.43, // Approx. "Title Medium" line-height: ~20px / 14px = 1.43
                              letterSpacing: 14 * 0.05, // 5% of font size = 0.7
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.04,),


                        Center(child: textform(hint: "Name",iconforsuffix: Icon(Icons.keyboard_arrow_right),
                          controllers : usernameController, context: context,
                        )),
                        SizedBox(height: height * 0.028,),

                        Center(child: textform(hint: "Email",iconforsuffix: Icon(Icons.keyboard_arrow_right),controllers: emailController, context: context,
                        )),
                        SizedBox(height: height * 0.028,),


                        Center(
                          child: Material(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(15),

                            child: Container(
                              width: width * 0.85,
                              height: height * 0.065,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  controller: passwordController,
                                  obscureText: obscureText,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter password...',
                                    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.only(right: width * 0.02), // 👈 Adjust padding here
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
                        SizedBox(height: height * 0.018,),


                        Center(
                          child: Material(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(15),

                            child: Container(
                              width: width * 0.85,
                              height: height * 0.07,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  controller: confirmPasswordController,
                                  obscureText: obscureTextconformpassword,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'conform password...',
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: height * 0.02,  // ~16 on 800px height
                                      horizontal: width * 0.03, // ~12 on 400px width
                                    ),                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(right: width * 0.02), // 👈 Adjust padding here
                                    child: IconButton(
                                      icon: Icon(
                                        obscureTextconformpassword ? Icons.visibility_off : Icons.visibility,
                                        color: Color(0xff3F414E),
                                      ),
                                      onPressed: toggleVisibilityconformpasswrd,
                                    ),
                                  ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.018,),

                        Center(
                          child: Container(
                            width: width * 0.85,
                            child: Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(color: Colors.black, fontFamily: 'Sora',fontSize: width * 0.038),
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
                                SizedBox(width: width * 0.24,),
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
                        SizedBox(height: height * 0.03,),

                        Center(
                          child: Material(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(16),

                            child: InkWell(

                              onTap: () {
                                if(isChecked){
                                  context.read<PostregisterCubit>().registerUser(conformpassword:confirmPasswordController.text.trim(),email: emailController.text.trim(),password: passwordController.text.trim(),username: usernameController.text.trim() );
                                }
                                else {
                                  // Show alert if not checked
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Please accept the Privacy Policy to continue."),
                                      backgroundColor: Colors.redAccent,
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(seconds: 2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );

                                }
                              },
                              child: Container(
                                  width: width * 0.85,
                                  height: height * 0.07,
                                  padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
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
                                        fontSize: width * 0.04,
                                        height: 1.5, // 150% line height = 1.5
                                        letterSpacing: 0, // 0% letter spacing
                                      ),
                                    ),

                                  )
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.022,),

                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Registerpage(),));
                            },
                            child: RichText(
                              text: TextSpan(
                                text: 'Already have an account? ',
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontSize: width * 0.045,
                                  fontWeight: FontWeight.w400, // normal weight
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign In',
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

                        SizedBox(height: height * 0.03,),



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


                  return Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.03,),


                      Padding(
                    padding:  EdgeInsets.symmetric(horizontal: width * 0.055),
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
                      SizedBox(height: height * 0.042,),
                      Center(
                        child: Text(
                          "Create your account ",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600, // SemiBold
                            fontSize: width * 0.065,
                            height: 32 / 26, // line-height ÷ font-size = 1.23
                            letterSpacing: 0, // 0%
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.04,),

                      Center(
                        child: Container(
                          width: width * 0.35,
                          child: Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  if(isChecked){
                                    context.read<LoginCubit>().signIn(context); // or "employer", "admin"

                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Please accept the Privacy Policy to continue."),
                                        backgroundColor: Colors.redAccent,
                                        behavior: SnackBarBehavior.floating,
                                        duration: Duration(seconds: 2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    );

                                  }

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

                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.04,),

                      Center(
                        child: Text(
                          "OR LOG IN WITH EMAIL",
                          style: TextStyle(
                            color: Color(0xffA1A4B2),
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w400, // Regular
                            fontSize: width * 0.035,
                            height: 1.43, // Approx. "Title Medium" line-height: ~20px / 14px = 1.43
                            letterSpacing: 14 * 0.05, // 5% of font size = 0.7
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.04,),


                      Center(child: textform(hint: "Name",iconforsuffix: Icon(Icons.keyboard_arrow_right),
                  controllers : usernameController, context: context,
                  )),
                      SizedBox(height: height * 0.028,),

                      Center(child: textform(hint: "Email",iconforsuffix: Icon(Icons.keyboard_arrow_right),controllers: emailController, context: context,
                  )),
                      SizedBox(height: height * 0.028,),


                      Center(
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(15),

                          child: Container(
                            width: width * 0.85,
                            height: height * 0.065,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: obscureText,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter password...',
                                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(right: width * 0.02), // 👈 Adjust padding here
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
                      SizedBox(height: height * 0.018,),


                      Center(
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(15),

                          child: Container(
                            width: width * 0.85,
                            height: height * 0.07,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: TextFormField(
                                controller: confirmPasswordController,
                                obscureText: obscureTextconformpassword,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'conform password...',
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: height * 0.02,  // ~16 on 800px height
                                    horizontal: width * 0.03, // ~12 on 400px width
                                  ),                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(right: width * 0.02), // 👈 Adjust padding here
                                    child: IconButton(
                                      icon: Icon(
                                        obscureTextconformpassword ? Icons.visibility_off : Icons.visibility,
                                        color: Color(0xff3F414E),
                                      ),
                                      onPressed: toggleVisibilityconformpasswrd,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.018,),

                      Center(
                        child: Container(
                          width: width * 0.85,
                          // color: Colors.red,
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(color: Colors.black, fontFamily: 'Sora',fontSize: width * 0.038),
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
                                          showEmployerTermsDialog(context);                                        },
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(width: width * 0.22,),
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
                      SizedBox(height: height * 0.03,),

                      Center(
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(16),

                          child: InkWell(

                            onTap: () {
                              if(isChecked){
                                context.read<PostregisterCubit>().registerUser(conformpassword:confirmPasswordController.text.trim(),email: emailController.text.trim(),password: passwordController.text.trim(),username: usernameController.text.trim() );
                              }
                              else {
                                // Show alert if not checked
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Please accept the Privacy Policy to continue."),
                                    backgroundColor: Colors.redAccent,
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );

                              }
                            },
                            child: Container(
                              width: width * 0.85,
                              height: height * 0.07,
                              padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
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
                                     fontSize: width * 0.04,
                                     height: 1.5, // 150% line height = 1.5
                                     letterSpacing: 0, // 0% letter spacing
                                   ),
                                 ),

                              )
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.022,),

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'Registerpage');
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => Registerpage(),));
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.w400, // normal weight
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign In',
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

                      SizedBox(height: height * 0.03,),



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
      ),
);
  }
}
Widget textform({ TextEditingController ? controllers,String ? hint, Icon ?  iconforsuffix, required BuildContext context}){
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  return
    Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(15),

      child: Container(
      width: width * 0.85,
      height: height * 0.07,
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
              padding: EdgeInsets.only(right: width * 0.03), // 👈 Adjust padding here
              child: iconforsuffix
            ),
            contentPadding: EdgeInsets.symmetric(vertical: height * 0.02,  horizontal: width * 0.035),

          ),

        ),
      ),
        ),
    );

}

class OtpInputRow extends StatefulWidget {
  final List<TextEditingController> controllers;

  const OtpInputRow({Key? key, required this.controllers}) : super(key: key);

  @override
  _OtpInputRowState createState() => _OtpInputRowState();
}

class _OtpInputRowState extends State<OtpInputRow> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {

    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return Container(
          width: width * 0.11,
          height: height * 0.075,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: widget.controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style:  TextStyle(fontSize: width * 0.055, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              counterText: "",
              border: InputBorder.none,
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                _focusNodes[index + 1].requestFocus();
              }
              if (value.isEmpty && index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
            },
          ),
        );
      }),
    );
  }
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