import 'package:flutter/material.dart';

import '../custom_ui/benefitcls.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Color(0xffF9F2ED),
        appBar: AppBar(
          leading: Container(
            margin: EdgeInsets.only(
              left: screenWidth * 0.02,
              top: screenHeight * 0.008, // slightly reduced
            ),
            height: screenWidth * 0.008,
            width: screenWidth * 0.008,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffE3E3E3),
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
                size: screenWidth * 0.055,
              ),
            ),
          ),
          toolbarHeight: screenHeight * 0.09,
          backgroundColor: Color(0xffF9F2ED),
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
                      color: Color(0xff313131)),
                ))
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
                              vertical: screenHeight * 0.02),
                          child: Image.asset(
                            "assets/images/onboard/image (4) (1) 2.png",
                            width: screenWidth * 0.4,
                            height: screenWidth * 0.4,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Benefits section
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.07),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              BenefitRow(
                                leading: Icon(Icons.work,
                                    size: screenWidth * 0.07,
                                    color: Colors.black),
                                title: "Find freelance gigs",
                                subtitle: "Explore opportunities & earn",
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              BenefitRow(
                                leading: Icon(Icons.lightbulb_outline,
                                    size: screenWidth * 0.07,
                                    color: Colors.black),
                                title: "Build your skills",
                                subtitle: "Enhance your expertise & grow",
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              BenefitRow(
                                leading: Icon(Icons.attach_money,
                                    size: screenWidth * 0.07,
                                    color: Colors.black),
                                title: "Boost your income",
                                subtitle:
                                    "Increase earnings & experience success",
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Bottom section with button and sign in
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.08,
                              vertical: screenHeight * 0.02),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Next button
                              SizedBox(
                                width: double.infinity,
                                height: screenHeight * 0.07,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, "OnboardingScreen2");
                                  },
                                  child: Text(
                                    "Next",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xffEB8125),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16))),
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
                                        Navigator.pushReplacementNamed(
                                            context, "OptionScreen");
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.02),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        "Sign In",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: Color(0xff004673),
                                          fontSize: screenWidth * 0.04,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ))
                                ],
                              ),

                              // Add small bottom padding for devices with gesture navigation
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).padding.bottom > 0
                                          ? MediaQuery.of(context)
                                                  .padding
                                                  .bottom *
                                              0.5
                                          : screenHeight * 0.01),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
