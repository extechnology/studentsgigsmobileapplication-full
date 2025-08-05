import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Loginpage/cubit/login_cubit.dart';
import '../Loginpage/registerpageog.dart';
import 'cubit/loginpag_cubit.dart';
import 'cubit2/resetpassword_cubit.dart';

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
        body: SingleChildScrollView(
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
                return Column(
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
                            Container(
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
                                  size:
                                      circleSize * 0.45, // responsive icon size
                                  color: Color(0xff313131),
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
                      height: height * 0.0615,
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
                      child: Container(
                        width: width * 0.389,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                context
                                    .read<LoginCubit>()
                                    .signIn(context); // or "employer", "admin"
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
                                    child: Image.asset(
                                        "assets/images/logos/google.png")),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.039,
                    ),
                    Center(
                      child: Text(
                        "OR LOG IN WITH EMAIL",
                        style: TextStyle(
                          color: Color(0xffA1A4B2),
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w400, // Regular
                          fontSize: width * 0.039,
                          height:
                              1.43, // Approx. "Title Medium" line-height: ~20px / 14px = 1.43
                          letterSpacing: 14 * 0.05, // 5% of font size = 0.7
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.075,
                    ),
                    Center(
                        child: textform(
                            hint: "Name",
                            iconforsuffix: Icon(Icons.keyboard_arrow_right),
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
                                hintText: 'Enter password...',
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
                      height: height * 0.054,
                    ),
                    Center(
                      child: Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          onTap: () {
                            context.read<LoginpagCubit>().loginUser(context,
                                username.text.trim(), password.text.trim());
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
                              child: Center(
                                child: Text(
                                  "LOG IN",
                                  style: TextStyle(
                                    color: Color(0xffFFFFFF),
                                    fontFamily: 'Sora',
                                    fontWeight:
                                        FontWeight.w600, // 600 = SemiBold
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
                          final parentContext =
                              context; // 👈 Save the outer context

                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text('Reset Password'),
                                content: TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your email',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Use parentContext instead of dialog context
                                      parentContext
                                          .read<ResetpasswordCubit>()
                                          .resetPassword(
                                            email: emailController.text.trim(),
                                          );
                                      Navigator.pop(
                                          context); // Optionally close dialog after action
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          'Forgot Password ?',
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: width * 0.034,
                            height: 1.5,
                            letterSpacing: 0.0,
                            color: Colors.blue, // Optional for clickable look
                            decoration:
                                TextDecoration.underline, // Optional underline
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GoogleSignInPage(),
                              ));
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
                );
              } else if (state is LoginIoaded)
                return Column(
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
                            Container(
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
                                  size:
                                      circleSize * 0.45, // responsive icon size
                                  color: Color(0xff313131),
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
                      height: height * 0.0615,
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
                      child: Container(
                        width: width * 0.389,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                context
                                    .read<LoginCubit>()
                                    .signIn(context); // or "employer", "admin"
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
                                    child: Image.asset(
                                        "assets/images/logos/google.png")),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.039,
                    ),
                    Center(
                      child: Text(
                        "OR LOG IN WITH EMAIL",
                        style: TextStyle(
                          color: Color(0xffA1A4B2),
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w400, // Regular
                          fontSize: width * 0.039,
                          height:
                              1.43, // Approx. "Title Medium" line-height: ~20px / 14px = 1.43
                          letterSpacing: 14 * 0.05, // 5% of font size = 0.7
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.075,
                    ),
                    Center(
                        child: textform(
                            hint: "Name",
                            iconforsuffix: Icon(Icons.keyboard_arrow_right),
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
                                hintText: 'Enter password...',
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
                      height: height * 0.054,
                    ),
                    Center(
                      child: Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          onTap: () {
                            context.read<LoginpagCubit>().loginUser(context,
                                username.text.trim(), password.text.trim());
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
                              child: Center(
                                child: Text(
                                  "LOG IN",
                                  style: TextStyle(
                                    color: Color(0xffFFFFFF),
                                    fontFamily: 'Sora',
                                    fontWeight:
                                        FontWeight.w600, // 600 = SemiBold
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
                          final parentContext =
                              context; // 👈 Save the outer context

                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text('Reset Password'),
                                content: TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your email',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Use parentContext instead of dialog context
                                      parentContext
                                          .read<ResetpasswordCubit>()
                                          .resetPassword(
                                            email: emailController.text.trim(),
                                          );
                                      Navigator.pop(
                                          context); // Optionally close dialog after action
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          'Forgot Password ?',
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: width * 0.034,
                            height: 1.5,
                            letterSpacing: 0.0,
                            color: Colors.blue, // Optional for clickable look
                            decoration:
                                TextDecoration.underline, // Optional underline
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GoogleSignInPage(),
                              ));
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
                );

              return Column(
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
                          Container(
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
                    height: height * 0.0615,
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
                    child: SizedBox(
                      width: width * 0.389,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              if (isChecked) {
                                context
                                    .read<LoginCubit>()
                                    .signIn(context); // or "employer", "admin"
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Please accept the Privacy Policy to continue."),
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
                                borderRadius: BorderRadius.circular(
                                    circleSize / 2), // perfectly circular
                              ),
                              child: Center(
                                  child: Image.asset(
                                      "assets/images/logos/google.png")),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.039,
                  ),
                  Center(
                    child: Text(
                      "OR LOG IN WITH EMAIL",
                      style: TextStyle(
                        color: Color(0xffA1A4B2),
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w400, // Regular
                        fontSize: width * 0.039,
                        height:
                            1.43, // Approx. "Title Medium" line-height: ~20px / 14px = 1.43
                        letterSpacing: 14 * 0.05, // 5% of font size = 0.7
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.075,
                  ),
                  Center(
                      child: textform(
                          hint: "Name",
                          iconforsuffix: Icon(Icons.keyboard_arrow_right),
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
                              hintText: 'Enter password...',
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
                    height: height * 0.01,
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
                                TextSpan(text: 'I have read the '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: Colors.blue,
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
                          StatefulBuilder(
                            builder: (context, setState) {
                              return Checkbox(
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value ?? false;
                                  });
                                },
                                activeColor: Color(
                                    0xffEB8125), // Fill color when checked
                                checkColor: Colors.white, // Tick color
                                side: BorderSide(
                                  color: Color(0xffEB8125),
                                ), // Border color when unchecked
                              );
                            },
                          ),
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
                          if (isChecked) {
                            context.read<LoginpagCubit>().loginUser(context,
                                username.text.trim(), password.text.trim());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Please accept the Privacy Policy to continue."),
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
                        final parentContext =
                            context; // 👈 Save the outer context

                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text('Reset Password'),
                              content: TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  hintText: 'Enter your email',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Use parentContext instead of dialog context
                                    parentContext
                                        .read<ResetpasswordCubit>()
                                        .resetPassword(
                                          email: emailController.text.trim(),
                                        );
                                    Navigator.pop(
                                        context); // Optionally close dialog after action
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        'Forgot Password ?',
                        style: TextStyle(
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w300,
                          fontSize: width * 0.034,
                          height: 1.5,
                          letterSpacing: 0.0,
                          color: Colors.blue, // Optional for clickable look
                          decoration:
                              TextDecoration.underline, // Optional underline
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
              );
            },
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

