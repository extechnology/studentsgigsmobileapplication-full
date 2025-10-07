import 'dart:async';
import 'package:anjalim/student_Section/student_blocs/Delete_Account/delete_bloc.dart';
import 'package:anjalim/student_Section/student_blocs/Delete_Account/delete_event.dart';
import 'package:anjalim/student_Section/student_blocs/Delete_Account/delete_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({Key? key}) : super(key: key);

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _showOtpField = false;
  Timer? _otpTimer;
  int _otpCountdownSeconds = 600; // 10 minutes in seconds
  bool _isResendEnabled = false;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _otpTimer?.cancel();
    super.dispose();
  }

  void _startOtpTimer() {
    // Reset timer values
    _otpCountdownSeconds = 600; // 10 minutes
    _isResendEnabled = false;
    _otpTimer?.cancel();

    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_otpCountdownSeconds > 0) {
        setState(() {
          _otpCountdownSeconds--;
        });
      } else {
        setState(() {
          _isResendEnabled = true;
        });
        timer.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeleteAccountBloc(),
      child: BlocConsumer<DeleteAccountBloc, DeleteAccountState>(
        listener: (context, state) {
          if (state is OtpSentSuccess) {
            setState(() {
              _showOtpField = true;
            });
            _startOtpTimer();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: const TextStyle(
                      fontFamily: "Poppins", color: Colors.green),
                ),
                backgroundColor: Colors.white,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          } else if (state is OtpVerifiedSuccess) {
            _otpTimer?.cancel();
            //print(state.message);
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext ctx) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  content: Text(
                    state.message,
                    style:
                        TextStyle(fontFamily: "Poppins", color: Colors.black),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text("ok"),
                    ),
                  ],
                );
              },
            );
          } else if (state is DeleteAccountError) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error,
                  style:
                      const TextStyle(fontFamily: "Poppins", color: Colors.red),
                ),
                backgroundColor: Colors.white,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.delete_forever,
                              color: Colors.red, size: 24),
                          SizedBox(width: 8),
                          Text(
                            "Delete Account",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Description
                      Text(
                        _showOtpField
                            ? "Enter the OTP sent to your email"
                            : "To delete your account, please enter your email address. We will send an OTP for verification.",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        enabled:
                            !_showOtpField && state is! DeleteAccountLoading,
                        decoration: InputDecoration(
                          labelText: "Email address",
                          labelStyle: const TextStyle(fontFamily: "Poppins"),
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2),
                          ),
                          filled: !_showOtpField ? false : true,
                          fillColor:
                              _showOtpField ? Colors.grey.shade100 : null,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontFamily: "Poppins"),
                      ),

                      // OTP Field
                      if (_showOtpField) ...[
                        const SizedBox(height: 25),

                        // OTP Label
                        Text(
                          "Enter 6-digit OTP",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Pinput
                        Pinput(
                          controller: _otpController,
                          length: 6,
                          defaultPinTheme: PinTheme(
                            width: 50,
                            height: 55,
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey.shade400, width: 1.5),
                            ),
                          ),
                          focusedPinTheme: PinTheme(
                            width: 50,
                            height: 55,
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey.shade600, width: 1.8),
                            ),
                          ),
                          submittedPinTheme: PinTheme(
                            width: 50,
                            height: 55,
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey.shade400, width: 1.5),
                            ),
                          ),
                          showCursor: true,
                          cursor: Container(
                              width: 2, height: 30, color: Color(0xff004673)),
                          keyboardType: TextInputType.number,
                          hapticFeedbackType: HapticFeedbackType.lightImpact,
                          animationDuration: const Duration(milliseconds: 300),
                          animationCurve: Curves.easeInOut,
                          errorPinTheme: PinTheme(
                            width: 50,
                            height: 55,
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey.shade400, width: 1.5),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Countdown Timer - Shows 10:00 to 00:00
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _isResendEnabled
                                    ? "OTP expired"
                                    : "OTP expires in ${_formatTime(_otpCountdownSeconds)}",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Resend OTP Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: _isResendEnabled &&
                                    state is! DeleteAccountLoading
                                ? () {
                                    if (_emailController.text.isNotEmpty) {
                                      context.read<DeleteAccountBloc>().add(
                                            ResendOtpEvent(
                                                _emailController.text),
                                          );
                                      _startOtpTimer();
                                    }
                                  }
                                : null,
                            icon: Icon(
                              Icons.refresh,
                              size: 18,
                              color: _isResendEnabled &&
                                      state is! DeleteAccountLoading
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            label: Text(
                              "Resend OTP",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: _isResendEnabled &&
                                        state is! DeleteAccountLoading
                                    ? Colors.red
                                    : Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 25),

                      // Loading Indicator
                      if (state is DeleteAccountLoading)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: CircularProgressIndicator(
                            color: Colors.red,
                            strokeWidth: 3,
                          ),
                        ),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: state is DeleteAccountLoading
                                ? null
                                : () {
                                    _otpTimer?.cancel();
                                    Navigator.of(context).pop();
                                  },
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: state is DeleteAccountLoading
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: state is DeleteAccountLoading
                                ? null
                                : () {
                                    if (!_showOtpField) {
                                      // Validate email
                                      final email =
                                          _emailController.text.trim();
                                      if (email.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                              'Please enter your email',
                                              style: TextStyle(
                                                  fontFamily: "Poppins"),
                                            ),
                                            backgroundColor: Colors.orange,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      // Basic email validation
                                      if (!RegExp(
                                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                          .hasMatch(email)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                              'Please enter a valid email',
                                              style: TextStyle(
                                                  fontFamily: "Poppins"),
                                            ),
                                            backgroundColor: Colors.red[900],
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      // Send OTP
                                      context.read<DeleteAccountBloc>().add(
                                            SendOtpEvent(email),
                                          );
                                    } else {
                                      // Verify OTP
                                      if (_otpController.text.length != 6) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                              'Please enter valid 6-digit OTP',
                                              style: TextStyle(
                                                  fontFamily: "Poppins"),
                                            ),
                                            backgroundColor: Colors.orange,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      context.read<DeleteAccountBloc>().add(
                                            VerifyOtpEvent(
                                              _emailController.text,
                                              _otpController.text,
                                            ),
                                          );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff004673),
                              disabledBackgroundColor: Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: Text(
                              _showOtpField ? "Verify" : "Send OTP",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                color: state is DeleteAccountLoading
                                    ? Colors.grey.shade600
                                    : Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
