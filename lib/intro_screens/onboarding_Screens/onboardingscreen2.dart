import 'package:flutter/material.dart';

import '../custom_ui/benefitcls.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffF9F2ED),
      appBar: AppBar(
        leading:
        Container(
          margin: EdgeInsets.only(
            left: screenWidth * 0.02,
            top: screenHeight * 0.008, // slightly reduced
          ),
          height: screenWidth * 0.12,
          width: screenWidth * 0.12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xffE3E3E3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              size: screenWidth * 0.06,
            ),
          ),
        ),
        toolbarHeight: screenHeight * 0.09,
        backgroundColor: const Color(0xffF9F2ED),
        flexibleSpace: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.05),
          child: Image.asset(
            "assets/images/logos/image 1.png",
            fit: BoxFit.contain,
            height: screenHeight * 0.08,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "OptionScreen");
            },
            child: Text(
              "Skip",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w400,
                color: const Color(0xff313131),
              ),
            ),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Main image section
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                        ),
                        child: Image.asset(
                          "assets/images/onboard/image (3) (1).png",
                          width: screenWidth * 0.4,
                          height: screenWidth * 0.4,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // Steps / Benefits section
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.07,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            BenefitRow(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xffE3E3E3),
                                radius: screenWidth * 0.07,
                                child: Text(
                                  "1",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              title: "Create a profile, showcase your skills",
                              subtitle: "",
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            BenefitRow(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xffE3E3E3),
                                radius: screenWidth * 0.07,
                                child: Text(
                                  "2",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              title:
                              "Browse and apply for gigs that match your interests",
                              subtitle: "",
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            BenefitRow(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xffE3E3E3),
                                radius: screenWidth * 0.07,
                                child: Text(
                                  "3",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              title:
                              "Work on and complete gigs to earn money and build your portfolio",
                              subtitle: "",
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom section with button + sign in
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08,
                        vertical: screenHeight * 0.02,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Get Started button
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.07,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, "OptionScreen");
                              },
                              child: Text(
                                "Get Started",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff004673),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.015),

                          // Sign in row
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.black,
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "LoginPage");
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.02,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: const Color(0xffEB8125),
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            ],
                          ),

                          // Bottom padding for gesture nav devices
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom > 0
                                ? MediaQuery.of(context).padding.bottom * 0.5
                                : screenHeight * 0.01,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}