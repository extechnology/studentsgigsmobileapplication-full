import 'package:anjalim/intro_screens/onboarding_Screens/onboardingscreen1.dart';
import 'package:flutter/material.dart';

class Welcomescreen extends StatelessWidget {
  const Welcomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isSmallScreen = screenWidth < 360;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xffF9F2ED),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: screenHeight * 0.12, // 12% of screen height
        backgroundColor: const Color(0xffF9F2ED),
        elevation: 0,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.01,
            ),
            child: Center(
              child: Container(
                height: screenHeight * 0.08,
                child: Image.asset(
                  "assets/images/logos/image 1.png",
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 40,
                      width: 120,
                      color: Colors.grey[300],
                      child: const Center(
                        child:
                            Text('Logo', style: TextStyle(color: Colors.grey)),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: screenWidth * 0.04,
              top: screenHeight * 0.01,
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "OptionScreen");
              },
              child: Text(
                "Skip",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: isSmallScreen ? 12 : 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff313131),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight -
                  (screenHeight * 0.12) - // AppBar height
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Main Image
                    Flexible(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: screenHeight * 0.05,
                          bottom: screenHeight * 0.02,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: isLargeScreen
                              ? screenWidth * 0.15
                              : screenWidth * 0.1,
                        ),
                        child: AspectRatio(
                          aspectRatio: 1.2,
                          child: Image.asset(
                            "assets/images/onboard/image (2) 1.png",
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // Title Text
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.02,
                        ),
                        child: Text(
                          "Find freelance gigs tailored to your skills and interests",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                            fontSize: _getResponsiveFontSize(screenWidth, 24),
                            height: 1.3,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),

                    // Next Button
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.02,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.07,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OnboardingScreen1(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff004673),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            "Next",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                              fontSize: _getResponsiveFontSize(screenWidth, 16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Sign In Section
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.all(screenHeight * 0.02),
                        child: _buildSignInSection(context, screenWidth),
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
  }

  Widget _buildSignInSection(BuildContext context, double screenWidth) {
    final isSmallScreen = screenWidth < 360;

    if (isSmallScreen) {
      // Stack vertically on very small screens
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an account?",
            style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.black,
              fontSize: _getResponsiveFontSize(screenWidth, 16),
              fontWeight: FontWeight.w400,
            ),
          ),
          TextButton(
            onPressed: () {
              // print("sign In");
              // Navigate to sign in screen
              Navigator.pushNamed(context, "OptionScreen");
            },
            child: Text(
              "Sign In",
              style: TextStyle(
                fontFamily: "Poppins",
                color: const Color(0xffEB8125),
                fontSize: _getResponsiveFontSize(screenWidth, 16),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      );
    } else {
      // Row layout for normal screens
      return Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            "Already have an account? ",
            style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.black,
              fontSize: _getResponsiveFontSize(screenWidth, 18),
              fontWeight: FontWeight.w400,
            ),
          ),
          TextButton(
            onPressed: () {
              // Navigate to sign in screen
              Navigator.pushReplacementNamed(context, "OptionScreen");
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: Text(
              "Sign In",
              style: TextStyle(
                fontFamily: "Poppins",
                color: const Color(0xffEB8125),
                fontSize: _getResponsiveFontSize(screenWidth, 18),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      );
    }
  }

  double _getResponsiveFontSize(double screenWidth, double baseFontSize) {
    if (screenWidth < 360) {
      return baseFontSize * 0.85; // Smaller font for small screens
    } else if (screenWidth > 600) {
      return baseFontSize * 1.1; // Larger font for tablets
    } else {
      return baseFontSize; // Default font size
    }
  }
}
