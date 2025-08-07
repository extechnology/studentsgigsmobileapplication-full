import 'package:anjalim/student_Section/authentication/other_functionalities/forgot_password.dart';
import 'package:anjalim/student_Section/authentication/google_Auth/google_signup_bloc/blocevent.dart';
import 'package:anjalim/student_Section/authentication/google_Auth/google_signup_bloc/bloclogic.dart';
import 'package:anjalim/student_Section/authentication/google_Auth/google_signup_bloc/statebloc.dart';
import 'package:anjalim/student_Section/authentication/google_Auth/googlesignup.dart';
import 'package:anjalim/student_Section/authentication/login/bloc_Login/std_login_bloc.dart';
import 'package:anjalim/student_Section/authentication/login/bloc_Login/std_login_event.dart';
import 'package:anjalim/student_Section/authentication/login/bloc_Login/std_login_state.dart';
import 'package:anjalim/student_Section/authentication/login/login.dart';
import 'package:anjalim/student_Section/authentication/terms_Conditions/terms_and_condistion.dart';
import 'package:anjalim/student_Section/authentication/terms_Conditions/terms_bloc.dart';
import 'package:anjalim/student_Section/authentication/terms_Conditions/terms_event.dart';
import 'package:anjalim/student_Section/authentication/terms_Conditions/terms_state.dart';
import 'package:anjalim/student_Section/custom_widgets/CustomTextField.dart';
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xffF9F2ED),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GoogleAuthBloc(GoogleAuthService()),
          ),
          BlocProvider(
            create: (context) => LoginBloc(LoginRepository()),
          ),
          // Add the TermsBloc provider
          BlocProvider(
            create: (context) => TermsBloc(),
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<GoogleAuthBloc, GoogleAuthState>(
              listener: (context, state) {
                if (state is GoogleAuthSuccess) {
                  Navigator.pop(context);
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
                physics: MediaQuery.of(context).viewInsets.bottom > 0
                    ? AlwaysScrollableScrollPhysics()
                    : NeverScrollableScrollPhysics(),
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
                              _buildGoogleSignInButton(context),

                              // OR Text
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Text(
                                  "OR LOG IN WITH EMAIL",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xffA1A4B2)),
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

                              SizedBox(height: size.height * 0.03),

                              // Login Button with BLoC
                              _buildLoginButton(context),

                              // Forgot Password
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  onPressed: () =>
                                      _showForgotPasswordDialog(context),
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
                                padding: EdgeInsets.only(bottom: 24),
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

  Widget _buildGoogleSignInButton(BuildContext context) {
    return BlocBuilder<TermsBloc, TermsState>(
      builder: (context, termsState) {
        return GestureDetector(
          onTap: () {
            if (termsState.isAccepted) {
              context
                  .read<GoogleAuthBloc>()
                  .add(GoogleSignInRequested(context, 'student'));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Please accept the terms and conditions")),
              );
            }
          },
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xffF9F2ED),
            backgroundImage: AssetImage("assets/images/logos/Group 6807.png"),
          ),
        );
      },
    );
  }

  Widget _buildTermsAndConditions(BuildContext context, Size size) {
    return BlocBuilder<TermsBloc, TermsState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                      fontSize: size.width * 0.04, color: Colors.black),
                  children: [
                    TextSpan(
                      text: "I have read the ",
                      style: TextStyle(
                          fontFamily: "Poppins", fontWeight: FontWeight.w300),
                    ),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () => TermsAndConditionsDialog.show(context),
                        child: Text(
                          "Terms & Conditions",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Checkbox(
              value: state?.isAccepted,
              onChanged: (bool? newValue) {
                context.read<TermsBloc>().add(
                      ToggleTermsAcceptance(newValue ?? false),
                    );
              },
              side: BorderSide(color: Color(0xffEB8125), width: 2),
              activeColor: Color(0xffEB8125),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return BlocBuilder<TermsBloc, TermsState>(
          builder: (context, termsState) {
            return ElevatedButton(
              onPressed: termsState.isAccepted && loginState is! LoginLoading
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff004673),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                minimumSize: Size(double.infinity, 56),
              ),
            );
          },
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

  void _showForgotPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Forgot Password"),
          content: TextFormField(
            controller: forgotPassword,
            decoration: InputDecoration(labelText: "Enter your E-mail"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String email = forgotPassword.text.trim();
                if (email.isNotEmpty) {
                  await resetPassword(email, context);
                  forgotPassword.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter your email.")),
                  );
                }
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    userName.clear();
    password.clear();
  }
}
