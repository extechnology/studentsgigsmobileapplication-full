import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class EmployerPremium extends StatelessWidget {
  EmployerPremium({super.key});
  final controller = PageController(initialPage: 0);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F2ED),
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 50,
        backgroundColor: Color(0xffF9F2ED),
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xffEB8125),
                      Color(0xffc55a5f),
                      Color(0xff004673)
                    ],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcIn,
                child: Text(
                  "Unlock Your Full Potential With Premium",
                  style: TextStyle(fontFamily: "Poppins",
                      fontSize: 24, fontWeight: FontWeight.w700, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Acces exclusive job oppotunities, build your resume, and \nstand out to top employers",
                  style: TextStyle(fontFamily: "Poppins",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff000000),
                      height: 2),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white70,
                  ),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Curent Plans :",style: TextStyle(fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff000000),
                          height: 2),),
                      Text("Standard",style: TextStyle(fontFamily: "Poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff6427ce),),)
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 500,
                child: PageView(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  children: [

                  ],
                ),
              ),
              SizedBox(height: 20),

              // Page Indicator
              SmoothPageIndicator(
                controller: controller, // PageController
                count: 3, // Number of pages
                effect: ExpandingDotsEffect(
                  activeDotColor: Color(0xffEB8125),
                  dotColor: Colors.grey.shade400,
                  dotHeight: 8,
                  dotWidth: 8,
                  expansionFactor: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}