import 'package:anjalim/mainpage/registerpage/loginpageog.dart';
import 'package:anjalim/student_Section/authentication/login/loginpage.dart';
import 'package:flutter/material.dart';

class OptionScreen extends StatelessWidget {
  const OptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF9F2ED),
        body: Stack(
          children: [
            /// Background Image (Positioned to be in the center)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Image.asset(
                  "assets/images/onboard/image (2) 1.png",
                  fit: BoxFit.fill,
                  height: 227,
                  width: 227,
                ),
              ),
            ),

            /// Foreground Layout (Transparent Container)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white.withOpacity(0.8),
                child: Column(
                  children: [
                    /// Top Section (Welcome Text, Logo, Description)
                    Column(
                      children: [
                        const SizedBox(height: 90),
                        const Text(
                          "Welcome to",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Color(0xff000000),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Image.asset("assets/images/logos/image 1.png"),
                        Padding(
                          padding: const EdgeInsets.only(right: 16, left: 16),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "Connecting students with the best gigs and companies with top student talent—quick, easy, and hassle-free! ",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Color(0xff000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 1.1,
                                    height: 2,
                                  ),
                                ),
                                TextSpan(
                                  text: "🚀",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Expanded(child: SizedBox()),

                    // Option Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Student Option Button
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 40, left: 8, right: 8),
                            child: _buildOptionButton(
                              context: context,
                              title: "Explore Jobs",
                              backgroundColor: const Color(0xff004673),
                              imagePath:
                                  "assets/images/others/Ellipse 1498.png",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                                //_navigateToLogin(context, 'student');
                              },
                            ),
                          ),
                        ),

                        // Employer Option Button
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 40, left: 8, right: 8),
                            child: _buildOptionButton(
                              context: context,
                              title: "Hire Students",
                              backgroundColor: const Color(0xffEB8125),
                              imagePath:
                                  "assets/images/others/Ellipse 1497.png",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Registerpage(),
                                  ),
                                );
                                // _navigateToLogin(context, 'employer');
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required BuildContext context,
    required String title,
    required Color backgroundColor,
    required String imagePath,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.of(context).size.width / 2, 172),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imagePath),
            radius: 30,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Navigation method
  void _navigateToLogin(BuildContext context, String userType) {
    // print("🚀 Navigating to login with user type: $userType");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Registerpage(),
      ),
    );
  }
}
