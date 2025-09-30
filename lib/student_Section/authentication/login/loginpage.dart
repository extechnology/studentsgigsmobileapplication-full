import 'package:anjalim/student_Section/authentication/Phone_Number_authentication/phone_auth_blocc/phone_auth_bloc.dart';
import 'package:anjalim/student_Section/authentication/Phone_Number_authentication/phone_auth_blocc/phone_auth_event.dart';
import 'package:anjalim/student_Section/authentication/Phone_Number_authentication/phone_auth_blocc/phone_auth_state.dart';
import 'package:anjalim/student_Section/authentication/Phone_Number_authentication/phone_auth_repository.dart';
import 'package:anjalim/student_Section/authentication/google_Auth/google_signup_bloc/blocevent.dart';
import 'package:anjalim/student_Section/authentication/google_Auth/google_signup_bloc/bloclogic.dart';
import 'package:anjalim/student_Section/authentication/google_Auth/google_signup_bloc/statebloc.dart';
import 'package:anjalim/student_Section/authentication/google_Auth/googlesignup.dart';
import 'package:anjalim/student_Section/authentication/login/Rest_password/reset_password_bloc.dart';
import 'package:anjalim/student_Section/authentication/login/Rest_password/reset_password_state.dart';
import 'package:anjalim/student_Section/authentication/login/Rest_password/rest_password_event.dart';
import 'package:anjalim/student_Section/authentication/other_functionalities/forgot_password.dart';
import 'package:anjalim/student_Section/authentication/login/bloc_Login/std_login_bloc.dart';
import 'package:anjalim/student_Section/authentication/login/bloc_Login/std_login_event.dart';
import 'package:anjalim/student_Section/authentication/login/bloc_Login/std_login_state.dart';
import 'package:anjalim/student_Section/authentication/login/login.dart';
import 'package:anjalim/student_Section/authentication/terms_Conditions/terms_and_condistion.dart';
import 'package:anjalim/student_Section/authentication/terms_Conditions/terms_bloc.dart';
import 'package:anjalim/student_Section/authentication/terms_Conditions/terms_state.dart';
import 'package:anjalim/student_Section/custom_widgets/CustomTextField.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  LoginPage({
    super.key,
  });

  // Controllers are now final - they persist during widget rebuilds
  final TextEditingController userName = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController forgotPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final size = MediaQuery.of(context).size;
    final double topPadding = screenHeight * 0.02;
    final double elementSpacing = screenHeight * 0.02;
    final double buttonHeight = screenHeight * 0.07;
    final double iconSize = screenHeight * 0.035;
    final double titleFontSize = screenHeight * 0.03;
    final double bodyFontSize = screenHeight * 0.018;

    return Scaffold(
      backgroundColor: Color(0xffF9F2ED),
      resizeToAvoidBottomInset: true,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GoogleAuthBloc(GoogleAuthService()),
          ),
          BlocProvider(
            create: (context) => LoginBloc(LoginRepository()),
          ),
          BlocProvider(
            create: (context) => TermsBloc(),
          ),
          BlocProvider(
            create: (context) => OtpAuthBloc(repository: OtpAuthRepository()),
          ),
          BlocProvider(
            create: (context) =>
                ForgotPasswordBloc(repository: ForgotPasswordRepository()),
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<GoogleAuthBloc, GoogleAuthState>(
              listener: (context, state) {
                if (state is GoogleAuthSuccess) {
                  Navigator.pushReplacementNamed(
                    context,
                    'StudentHomeScreens',
                    arguments: {"userName": "Google User"},
                  );
                } else if (state is GoogleAuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
            ),
            BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  Navigator.pushReplacementNamed(
                    context,
                    'StudentHomeScreens',
                    arguments: {"userName": userName.text},
                  );
                  _clearForm();
                } else if (state is LoginFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
            ),
          ],
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: SafeArea(
                      child: GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              // AppBar Section
                              Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffE3E3E3),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.2)),
                                        ],
                                      ),
                                      child: IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon: Icon(Icons.arrow_back, size: 24),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Image.asset(
                                          "assets/images/logos/image 1.png",
                                          height: 60,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Welcome Text
                              Padding(
                                padding: EdgeInsets.only(top: 24, bottom: 24),
                                child: Text(
                                  "Welcome Back !",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Color(0xff3F414E),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 26,
                                  ),
                                ),
                              ),

                              // Google Sign In with BLoC
                              _buildGoogleSignInButton(context, screenHeight),
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              // Phone Login Button
                              SizedBox(
                                height: buttonHeight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showPhoneNumberDialog(
                                        context, screenWidth, screenHeight);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff004673),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                screenHeight * 0.02))),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.call,
                                        color: Colors.white,
                                        size: iconSize,
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.05,
                                      ),
                                      Text(
                                        "Log in with Phone",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            color: Colors.white,
                                            fontSize: bodyFontSize,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // OR Text
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: elementSpacing),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Divider(
                                        color: Color(0xffA1A4B2),
                                        thickness: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.04),
                                      child: Text(
                                        "OR",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: bodyFontSize,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xffA1A4B2),
                                        ),
                                      ),
                                    ),
                                    const Expanded(
                                      child: Divider(
                                        color: Color(0xffA1A4B2),
                                        thickness: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Email Field
                              CustomTextField(
                                hintText: "User Name",
                                controller: userName,
                              ),
                              SizedBox(height: 16),

                              // Password Field
                              CustomTextField(
                                hintText: "password",
                                controller: password,
                                isObscured: true,
                              ),

                              SizedBox(height: size.height * 0.02),

                              // Terms and Conditions with BLoC
                              _buildTermsAndConditions(context, size),

                              // Login Button with BLoC
                              SizedBox(height: size.height * 0.03),
                              _buildLoginButton(context),

                              // Forgot Password
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  onPressed: () =>
                                      showForgotPasswordDialog(context),
                                  child: Text(
                                    "Forgot Password ?",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Color(0xff3F414E),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ),

                              // Sign Up Section
                              Padding(
                                padding: EdgeInsets.only(bottom: buttonHeight),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Not yet registered? ",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          "RegisterPage",
                                          arguments: 'student',
                                        );
                                      },
                                      child: Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: Color(0xffEB8125),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context, double screenHeight) {
    return SizedBox(
      height: screenHeight * 0.07,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff004673),
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(screenHeight * 0.02))),
        ),
        onPressed: () {
          context
              .read<GoogleAuthBloc>()
              .add(GoogleSignInRequested(context, 'student'));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage("assets/images/logos/google.png"),
              height: screenHeight * 0.030,
              width: screenHeight * 0.030,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: screenHeight * 0.03,
            ),
            Text(
              "Log in with google",
              style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.white,
                  fontSize: screenHeight * 0.018,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void showPhoneNumberDialog(
      BuildContext context, double screenWidth, double screenHeight) {
    final TextEditingController phoneNumber = TextEditingController();
    CountryCode? selectedCountryCode;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<OtpAuthBloc>(),
          child: BlocConsumer<OtpAuthBloc, OtpAuthState>(
            listener: (context, state) {
              if (state is OtpSentSuccess) {
                Navigator.of(dialogContext).pop();
                // Show OTP verification dialog
                _showPhoneAuthDialog(
                  context,
                  phoneNumber.text,
                  selectedCountryCode?.dialCode ?? '+91',
                  screenWidth,
                  screenHeight,
                );
              } else if (state is OtpAuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Enter Your Mobile Number",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: screenHeight * 0.025,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "We'll send a OTP to your Mobile Number",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: screenHeight * 0.015,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        constraints: BoxConstraints(
                          minWidth: screenWidth * 0.8,
                        ),
                        child: Row(
                          children: [
                            CountryCodePicker(
                              onChanged: (CountryCode countryCode) {
                                selectedCountryCode = countryCode;
                              },
                              initialSelection: 'IN',
                              favorite: const ['+91'],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                              showFlag: true,
                              showFlagDialog: true,
                              hideMainText: false,
                              dialogTextStyle: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: screenHeight * 0.018,
                              ),
                              textStyle: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: screenHeight * 0.018,
                                fontWeight: FontWeight.w500,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02),
                            ),
                            VerticalDivider(
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: phoneNumber,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: "Phone Number",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.04,
                                    vertical: screenHeight * 0.02,
                                  ),
                                  hintStyle: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: screenHeight * 0.018,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xffA1A4B2),
                                  ),
                                ),
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: screenHeight * 0.018,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                              phoneNumber.clear();
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.grey.shade600,
                                fontSize: screenHeight * 0.018,
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          ElevatedButton(
                            onPressed: state is OtpAuthLoading
                                ? null
                                : () {
                                    if (phoneNumber.text.isNotEmpty) {
                                      context.read<OtpAuthBloc>().add(
                                            SendOtpEvent(
                                              mobileNumber: phoneNumber.text,
                                              countryCode: selectedCountryCode
                                                      ?.dialCode ??
                                                  '+91',
                                            ),
                                          );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Please enter a phone number"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff004673),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: state is OtpAuthLoading
                                ? SizedBox(
                                    height: screenHeight * 0.02,
                                    width: screenHeight * 0.02,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    children: [
                                      Text(
                                        "send OTP",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: screenHeight * 0.018,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.verified_outlined,
                                        color: Colors.green,
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showPhoneAuthDialog(
    BuildContext context,
    String phoneNumber,
    String countryCode,
    double screenWidth,
    double screenHeight,
  ) {
    final List<TextEditingController> otpControllers =
        List.generate(6, (_) => TextEditingController());
    final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
    final fullMobileNumber = '$countryCode$phoneNumber';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<OtpAuthBloc>(),
          child: BlocConsumer<OtpAuthBloc, OtpAuthState>(
            listener: (context, state) {
              if (state is OtpVerifiedSuccess) {
                Navigator.of(dialogContext).pop();
                Navigator.pushReplacementNamed(context, 'StudentHomeScreens');
              } else if (state is OtpAuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Enter OTP",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: screenHeight * 0.025,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        "Enter the 6-digit code sent to",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: screenHeight * 0.015,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        fullMobileNumber,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: screenHeight * 0.015,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: screenWidth * 0.10,
                            child: TextField(
                              controller: otpControllers[index],
                              focusNode: focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: screenHeight * 0.025,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                counterText: "",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xff004673), width: 2),
                                ),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 5) {
                                  focusNodes[index + 1].requestFocus();
                                } else if (value.isEmpty && index > 0) {
                                  focusNodes[index - 1].requestFocus();
                                }
                              },
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                              for (var controller in otpControllers) {
                                controller.clear();
                              }
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.grey.shade600,
                                fontSize: screenHeight * 0.018,
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          ElevatedButton(
                            onPressed: state is OtpAuthLoading
                                ? null
                                : () {
                                    String otp = otpControllers
                                        .map((c) => c.text)
                                        .join();
                                    if (otp.length == 6) {
                                      context.read<OtpAuthBloc>().add(
                                            VerifyOtpEvent(
                                              mobileNumber: fullMobileNumber,
                                              otp: otp,
                                            ),
                                          );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Please enter complete OTP"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff004673),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: state is OtpAuthLoading
                                ? SizedBox(
                                    height: screenHeight * 0.02,
                                    width: screenHeight * 0.02,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "Verify",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: screenHeight * 0.018,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
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
          ),
        );
      },
    );
  }

  Widget _buildTermsAndConditions(BuildContext context, Size size) {
    return BlocBuilder<TermsBloc, TermsState>(
      builder: (context, state) {
        return Expanded(
          child: RichText(
            text: TextSpan(
              style:
                  TextStyle(fontSize: size.width * 0.03, color: Colors.black38),
              children: [
                TextSpan(
                  text: "By logging in, you agree to our  ",
                  style: TextStyle(
                      fontFamily: "Poppins", fontWeight: FontWeight.w300),
                ),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () => TermsAndConditionsDialog.show(context),
                    child: Text(
                      "Terms & Conditions",
                      style: TextStyle(
                        fontSize: size.width * 0.035,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return ElevatedButton(
          onPressed: loginState is! LoginLoading
              ? () {
                  if (_validateForm(context)) {
                    context.read<LoginBloc>().add(
                          LoginRequested(
                            username: userName.text.trim(),
                            password: password.text,
                            context: context,
                          ),
                        );
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff004673),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            minimumSize: Size(double.infinity, 56),
          ),
          child: loginState is LoginLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  "LOG IN",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
        );
      },
    );
  }

  bool _validateForm(BuildContext context) {
    if (userName.text.trim().isEmpty) {
      _showErrorSnackBar(context, "Please enter username");
      return false;
    }
    if (password.text.isEmpty) {
      _showErrorSnackBar(context, "Please enter password");
      return false;
    }
    return true;
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void showForgotPasswordDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<ForgotPasswordBloc>(),
          child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
            listener: (context, state) {
              if (state is PasswordResetOtpSent) {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
                showOtpVerificationDialog(context, emailController.text.trim(),
                    screenWidth, screenHeight);
              } else if (state is ForgotPasswordError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Reset Password",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: screenHeight * 0.025,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      Text(
                        "Enter your email to receive OTP",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: screenHeight * 0.015,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xffEB8125)),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                              emailController.clear();
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.grey.shade600,
                                fontSize: screenHeight * 0.018,
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          ElevatedButton(
                            onPressed: state is ForgotPasswordLoading
                                ? null
                                : () {
                                    String email = emailController.text.trim();
                                    if (email.isNotEmpty) {
                                      context.read<ForgotPasswordBloc>().add(
                                            SendPasswordResetOtpEvent(
                                                identifier: email),
                                          );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Please enter your email"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffEB8125),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: state is ForgotPasswordLoading
                                ? SizedBox(
                                    height: screenHeight * 0.02,
                                    width: screenHeight * 0.02,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "Send OTP",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: screenHeight * 0.018,
                                      color: Colors.white,
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
          ),
        );
      },
    );
  }

  void showOtpVerificationDialog(BuildContext context, String email,
      double screenWidth, double screenHeight) {
    final List<TextEditingController> otpControllers =
        List.generate(6, (_) => TextEditingController());
    final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<ForgotPasswordBloc>(),
          child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
            listener: (context, state) {
              if (state is PasswordResetOtpVerified) {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
                showNewPasswordDialog(
                    context, email, screenWidth, screenHeight);
              } else if (state is ForgotPasswordError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Enter OTP",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: screenHeight * 0.025,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        "Enter the 6-digit code sent to",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: screenHeight * 0.015,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        email,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: screenHeight * 0.015,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) {
                            return SizedBox(
                              width: screenWidth * 0.10,
                              child: TextField(
                                controller: otpControllers[index],
                                focusNode: focusNodes[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: screenHeight * 0.025,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  counterText: "",
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.015),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Color(0xffEB8125), width: 2),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty && index < 5) {
                                    focusNodes[index + 1].requestFocus();
                                  } else if (value.isEmpty && index > 0) {
                                    focusNodes[index - 1].requestFocus();
                                  }
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                              for (var controller in otpControllers) {
                                controller.clear();
                              }
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.grey.shade600,
                                fontSize: screenHeight * 0.018,
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          ElevatedButton(
                            onPressed: state is ForgotPasswordLoading
                                ? null
                                : () {
                                    String otp = otpControllers
                                        .map((c) => c.text)
                                        .join();
                                    if (otp.length == 6) {
                                      context.read<ForgotPasswordBloc>().add(
                                            VerifyPasswordResetOtpEvent(
                                              identifier: email,
                                              otp: otp,
                                            ),
                                          );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Please enter complete OTP"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffEB8125),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: state is ForgotPasswordLoading
                                ? SizedBox(
                                    height: screenHeight * 0.02,
                                    width: screenHeight * 0.02,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "Verify",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: screenHeight * 0.018,
                                      color: Colors.white,
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
          ),
        );
      },
    );
  }

  void showNewPasswordDialog(BuildContext context, String email,
      double screenWidth, double screenHeight) {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    bool obscurePassword = true;
    bool obscureConfirmPassword = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<ForgotPasswordBloc>(),
          child: StatefulBuilder(
            builder: (context, setState) {
              return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                listener: (context, state) {
                  if (state is PasswordResetSuccess) {
                    Navigator.of(dialogContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (state is ForgotPasswordError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Create New Password",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: screenHeight * 0.025,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              "Enter your new password",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: screenHeight * 0.015,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            TextFormField(
                              controller: passwordController,
                              obscureText: obscurePassword,
                              decoration: InputDecoration(
                                labelText: "New Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xffEB8125)),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            TextFormField(
                              controller: confirmPasswordController,
                              obscureText: obscureConfirmPassword,
                              decoration: InputDecoration(
                                labelText: "Confirm Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xffEB8125)),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      obscureConfirmPassword =
                                          !obscureConfirmPassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                    passwordController.clear();
                                    confirmPasswordController.clear();
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colors.grey.shade600,
                                      fontSize: screenHeight * 0.018,
                                    ),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.03),
                                ElevatedButton(
                                  onPressed: state is ForgotPasswordLoading
                                      ? null
                                      : () {
                                          String password =
                                              passwordController.text;
                                          String confirmPassword =
                                              confirmPasswordController.text;

                                          if (password.isEmpty ||
                                              confirmPassword.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Please fill all fields"),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          } else if (password !=
                                              confirmPassword) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Passwords do not match"),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          } else {
                                            context
                                                .read<ForgotPasswordBloc>()
                                                .add(
                                                  ResetPasswordEvent(
                                                    identifier: email,
                                                    password: password,
                                                    confirmPassword:
                                                        confirmPassword,
                                                  ),
                                                );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffEB8125),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: state is ForgotPasswordLoading
                                      ? SizedBox(
                                          height: screenHeight * 0.02,
                                          width: screenHeight * 0.02,
                                          child:
                                              const CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          "Reset Password",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: screenHeight * 0.018,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void _clearForm() {
    userName.clear();
    password.clear();
  }
}
