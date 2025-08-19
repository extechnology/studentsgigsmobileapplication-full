import 'package:anjalim/student_Section/authentication/registration/std_Registration/std_bloc/std_reg_bloc.dart';
import 'package:anjalim/student_Section/authentication/registration/std_Registration/std_bloc/std_reg_event.dart';
import 'package:anjalim/student_Section/authentication/registration/std_Registration/std_bloc/std_reg_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OTPVerificationBlocWidget extends StatefulWidget {
  final String email;
  final String username;
  final String password;

  const OTPVerificationBlocWidget({
    Key? key,
    required this.email,
    required this.username,
    required this.password,
  }) : super(key: key);

  @override
  State<OTPVerificationBlocWidget> createState() =>
      _OTPVerificationBlocWidgetState();
}

class _OTPVerificationBlocWidgetState extends State<OTPVerificationBlocWidget> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          Navigator.of(context).pop(true);
        } else if (state is VerifyOTPFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is ResendOTPSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is ResendOTPFailure) {
          // Debug log
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is RegisterFailure) {
          // Debug log
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: AlertDialog(
        title: Text(
          "OTP Verification",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Enter the OTP sent to ${widget.email}",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: "Enter OTP",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              // Debug log

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed:
                        (state is ResendOTPLoading || state is VerifyOTPLoading)
                            ? null
                            : () {
                                // Debug log
                                context.read<RegisterBloc>().add(
                                      ResendOTPRequested(email: widget.email),
                                    );
                              },
                    child: state is ResendOTPLoading
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            "Resend OTP",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Color(0xffEB8125),
                            ),
                          ),
                  ),
                  ElevatedButton(
                    onPressed: (state is VerifyOTPLoading ||
                            state is ResendOTPLoading)
                        ? null
                        : () {
                            // Add a small delay to ensure text input is complete
                            Future.delayed(Duration(milliseconds: 100), () {
                              final otpText = _otpController.text.trim();
                              // Debug log

                              if (otpText.isNotEmpty && otpText.length >= 4) {
                                // Debug log
                                context.read<RegisterBloc>().add(
                                      VerifyOTPRequested(
                                        email: widget.email,
                                        otp: otpText,
                                        username: widget.username,
                                        password: widget.password,
                                      ),
                                    );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Please enter a valid OTP (at least 4 digits)"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            });
                          },
                    child: state is VerifyOTPLoading
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Verify",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                            ),
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff004673),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
