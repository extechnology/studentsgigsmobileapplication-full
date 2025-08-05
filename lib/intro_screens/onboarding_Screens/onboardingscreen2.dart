import 'package:anjalim/intro_screens/custom_ui/benefitcls.dart';
import 'package:flutter/material.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F2ED),
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.only(left: 7, top: 10),
          height: 55,
          width: 55,
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
              size: 26,
            ),
          ),
        ),
        toolbarHeight: 100,
        backgroundColor: Color(0xffF9F2ED),
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Image.asset(
            "assets/images/logos/image 1.png",
            // height: 69,
            // width: double.infinity,
            fit: BoxFit.contain,
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
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff313131)),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Image.asset(
                "assets/images/onboard/image (3) (1).png",
                height: 166,
                width: 166,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 28, left: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BenefitRow(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xffE3E3E3),
                      child: Text(
                        "1",
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      radius: 22.5,
                    ),
                    title: "Create a profile, showcase your skills",
                    subtitle: "",
                  ),
                  BenefitRow(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xffE3E3E3),
                      child: Text("2"),
                      radius: 22.5,
                    ),
                    title:
                        "Browse and apply for gigs that match your interests",
                    subtitle: "",
                  ),
                  BenefitRow(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xffE3E3E3),
                      child: Text("3"),
                      radius: 22.5,
                    ),
                    title:
                        "Work on and complete gigs to earn money and build your portfolio",
                    subtitle: "",
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 30,
                left: 30,
                top: 8,
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "OptionScreen");
                },
                child: Text(
                  "Get Started",
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
                    fixedSize: Size(327, 56)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "OptionScreen");
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xffEB8125),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
