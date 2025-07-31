import 'package:anjalim/intro_screens/custom_ui/benefitcls.dart';
import 'package:flutter/material.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

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
            "lib/assets/images/logos/image 1.png",
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              child: Image.asset(
                "lib/assets/images/onboard/image (4) (1) 2.png",
                width: 161,
                height: 161,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 28, left: 28),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BenefitRow(
                      leading: Icon(Icons.work, size: 28, color: Colors.black),
                      title: "Find freelance gigs",
                      subtitle: "Explore opportunities & earn",
                    ),
                    BenefitRow(
                      leading: Icon(Icons.lightbulb_outline,
                          size: 28, color: Colors.black),
                      title: "Build your skills",
                      subtitle: "Enhance your expertise & grow",
                    ),
                    BenefitRow(
                      leading: Icon(Icons.attach_money,
                          size: 28, color: Colors.black),
                      title: "Boost your income",
                      subtitle: "Increase earnings & experience success",
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30, left: 30, top: 30),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "OnboardingScreen2");
                },
                child: Text(
                  "Next",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffEB8125),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    fixedSize: Size(MediaQuery.of(context).size.width, 56)),
              ),
            ),
            SizedBox(
              height: 14,
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
                      Navigator.pushReplacementNamed(context, "OptionScreen");
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xff004673),
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
