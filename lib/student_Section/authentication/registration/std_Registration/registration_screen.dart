import 'package:anjalim/student_Section/authentication/google_Auth/google_signup_bloc/blocevent.dart';
import 'package:anjalim/student_Section/authentication/google_Auth/google_signup_bloc/bloclogic.dart';
import 'package:anjalim/student_Section/authentication/google_Auth/google_signup_bloc/statebloc.dart';
import 'package:anjalim/student_Section/authentication/google_Auth/googlesignup.dart';
import 'package:anjalim/student_Section/authentication/registration/otp_verification.dart';
import 'package:anjalim/student_Section/authentication/registration/std_Registration/register.dart';
import 'package:anjalim/student_Section/authentication/registration/std_Registration/std_bloc/std_reg_bloc.dart';
import 'package:anjalim/student_Section/authentication/registration/std_Registration/std_bloc/std_reg_event.dart';
import 'package:anjalim/student_Section/authentication/registration/std_Registration/std_bloc/std_reg_state.dart';
import 'package:anjalim/student_Section/authentication/terms_Conditions/terms_and_condistion.dart';
import 'package:anjalim/student_Section/authentication/terms_Conditions/terms_bloc.dart';
import 'package:anjalim/student_Section/authentication/terms_Conditions/terms_event.dart';
import 'package:anjalim/student_Section/authentication/terms_Conditions/terms_state.dart';
import 'package:anjalim/student_Section/custom_widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController userName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.08;

    return Scaffold(
      backgroundColor: const Color(0xffF9F2ED),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: Padding(
          padding:
              EdgeInsets.only(left: size.width * 0.02, top: size.height * 0.02),
          child: CircleAvatar(
            backgroundColor: const Color(0xffE3E3E3),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, size: size.width * 0.06),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        toolbarHeight: size.height * 0.12,
        backgroundColor: const Color(0xffF9F2ED),
        flexibleSpace: Padding(
          padding: EdgeInsets.only(top: size.height * 0.08),
          child: Image.asset("assets/images/logos/image 1.png",
              fit: BoxFit.contain),
        ),
      ),
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => GoogleAuthBloc(GoogleAuthService()),
            ),
            BlocProvider(
              create: (context) => RegisterBloc(RegisterRepository()),
            ),
            BlocProvider(
              create: (context) => TermsBloc(),
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
              BlocListener<RegisterBloc, RegisterState>(
                listener: (context, state) {
                  if (state is SendOTPSuccess) {
                    _showOTPDialog(context, state);
                  } else if (state is SendOTPFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (state is RegisterFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: padding,
                right: padding,
                bottom: MediaQuery.of(context).viewInsets.bottom +
                    (size.height *
                        0.02), // keeps content above keyboard/system nav
              ),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.04),
                  Text(
                    "Create your account",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: const Color(0xff3F414E),
                      fontWeight: FontWeight.w600,
                      fontSize: size.width * 0.07,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  _buildGoogleSignInButton(context),
                  SizedBox(height: size.height * 0.03),
                  Text(
                    "OR REGISTER WITH EMAIL",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: size.width * 0.035,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xffA1A4B2),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  CustomTextField(
                    hintText: "User Name",
                    controller: userName,
                  ),
                  SizedBox(height: size.height * 0.02),
                  CustomTextField(
                    hintText: "E-Mail",
                    controller: email,
                  ),
                  SizedBox(height: size.height * 0.02),
                  CustomTextField(
                    hintText: "Password",
                    controller: password,
                    isObscured: true,
                  ),
                  SizedBox(height: size.height * 0.02),
                  CustomTextField(
                    hintText: "Confirm Password",
                    controller: confirmPassword,
                    isObscured: true,
                  ),
                  SizedBox(height: size.height * 0.02),
                  _buildTermsAndConditions(context, size),
                  SizedBox(height: size.height * 0.03),
                  _buildRegisterButton(context, size),
                  SizedBox(height: size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: size.width * 0.045,
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, "LoginPage"),
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: const Color(0xffEB8125),
                            fontSize: size.width * 0.045,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //SizedBox(height: size.height * 0.06),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    return BlocBuilder<TermsBloc, TermsState>(
      builder: (context, termsState) {
        return BlocBuilder<GoogleAuthBloc, GoogleAuthState>(
          builder: (context, authState) {
            return GestureDetector(
              onTap: () {
                if (termsState.isAccepted) {
                  if (authState is! GoogleAuthLoading) {
                    context
                        .read<GoogleAuthBloc>()
                        .add(GoogleSignInRequested(context, 'student'));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            const Text("Please accept terms and conditions")),
                  );
                }
              },
              child: authState is GoogleAuthLoading
                  ? const CircularProgressIndicator()
                  : const CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xffF9F2ED),
                      backgroundImage:
                          AssetImage("assets/images/logos/Group 6807.png"),
                    ),
            );
          },
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
                    fontSize: size.width * 0.04,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(
                      text: "I have read the ",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () => TermsAndConditionsDialog.show(context),
                        child: const Text(
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
              value: state.isAccepted,
              onChanged: (bool? newValue) {
                context.read<TermsBloc>().add(
                      ToggleTermsAcceptance(newValue ?? false),
                    );
              },
              side: const BorderSide(color: Color(0xffEB8125), width: 2),
              activeColor: const Color(0xffEB8125),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRegisterButton(BuildContext context, Size size) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, registerState) {
        return BlocBuilder<TermsBloc, TermsState>(
          builder: (context, termsState) {
            return ElevatedButton(
              onPressed: termsState.isAccepted &&
                      registerState is! RegisterLoading &&
                      registerState is! SendOTPLoading
                  ? () {
                      if (_validateForm(context)) {
                        context.read<RegisterBloc>().add(
                              RegisterRequested(
                                email: email.text.trim(),
                                username: userName.text.trim(),
                                password: password.text,
                                confirmPassword: confirmPassword.text,
                                context: context,
                              ),
                            );
                      }
                    }
                  : null,
              child: (registerState is RegisterLoading ||
                      registerState is SendOTPLoading)
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      "REGISTER",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                        fontSize: size.width * 0.045,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff004673),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                fixedSize: Size(size.width * 0.8, size.height * 0.07),
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
    if (email.text.trim().isEmpty) {
      _showErrorSnackBar(context, "Please enter email");
      return false;
    }
    if (password.text.isEmpty) {
      _showErrorSnackBar(context, "Please enter password");
      return false;
    }
    if (confirmPassword.text.isEmpty) {
      _showErrorSnackBar(context, "Please confirm password");
      return false;
    }
    if (password.text != confirmPassword.text) {
      _showErrorSnackBar(context, "Passwords do not match");
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

  void _showOTPDialog(BuildContext context, SendOTPSuccess state) {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<RegisterBloc>(),
        child: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              // Close the dialog first
              Navigator.of(dialogContext).pop(true);

              // Then navigate to login page
              Navigator.pushReplacementNamed(context, 'LoginPage');

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Registration successful! Please login."),
                  backgroundColor: Colors.green,
                ),
              );

              // Clear the form
              _clearForm();
            }
          },
          child: OTPVerificationBlocWidget(
            email: state.email,
            username: state.username,
            password: state.password,
          ),
        ),
      ),
    );
  }

  void _clearForm() {
    userName.clear();
    email.clear();
    password.clear();
    confirmPassword.clear();
  }
}
