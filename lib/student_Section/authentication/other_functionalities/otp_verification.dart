import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPVerification extends StatefulWidget {
  final String email;
  final Function(String) onVerified;
  final Function() onResend;

  const OTPVerification({
    super.key,
    required this.email,
    required this.onVerified,
    required this.onResend,
  });

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(6, (index) => FocusNode());
  bool isLoading = false;
  bool isVerifying = false; // for "Verify" button loading
  bool isResending = false; // for "Resend OTP" button loading

  String? errorMessage;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleOTPInput(int index, String value) {
    if (value.length == 1 && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    }
  }

  void _verifyOTP() async {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length == 6) {
      setState(() {
        isVerifying = true;
        errorMessage = null;
      });

      await widget
          .onVerified(otp); // Calls the function passed from register screen

      setState(() => isVerifying = false);
    } else {
      setState(() => errorMessage = "Please enter complete OTP");
    }
  }

  void _resendOTP() async {
    setState(() => isResending = true);

    await widget.onResend(); // Calls the function passed from register screen

    setState(() => isResending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            height: 350,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      CupertinoIcons.clear_circled,
                      color: Colors.black54,
                      size: 30,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Verification Required",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                      ),
                    ),
                    Icon(
                      CupertinoIcons.checkmark_shield,
                      size: 30,
                      weight: 500,
                    )
                  ],
                ),
                Text("Please enter the code sent to ${widget.email}"),
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 45,
                      child: TextFormField(
                        controller: _otpControllers[index],
                        focusNode: _otpFocusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        onChanged: (value) => _handleOTPInput(index, value),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    );
                  }),
                ),
                ElevatedButton(
                  onPressed: isVerifying ? null : _verifyOTP,
                  child: isVerifying
                      ? CircularProgressIndicator()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Verify"),
                            SizedBox(width: 8),
                            Icon(CupertinoIcons.checkmark_seal),
                          ],
                        ),
                ),
                ElevatedButton(
                  onPressed: isResending ? null : _resendOTP,
                  child: isResending
                      ? CircularProgressIndicator()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Resend OTP"),
                            SizedBox(width: 8),
                            Icon(CupertinoIcons.arrow_2_circlepath),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
