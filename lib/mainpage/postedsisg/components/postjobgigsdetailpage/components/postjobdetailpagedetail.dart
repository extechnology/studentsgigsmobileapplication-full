import 'package:anjalim/mainpage/postedsisg/components/postjobgigsdetailpage/components/resumeview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../homepageifdatalocation/component/homepagedetailpage/homepagedetailpage.dart';
import '../model/model.dart';

class Postjobdetailpagedetail extends StatelessWidget {
  final Postedpagelist detailsof;

  const Postjobdetailpagedetail({super.key, required this.detailsof});

  @override
  Widget build(BuildContext context) {
    final profilePic = detailsof.employee?.profile?.profilePic ?? '';

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xffF9F2ED),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.02),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  left: width * 0.03,
                  bottom: 108.0 + MediaQuery.of(context).padding.bottom,
                  top: height * 0.025),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                  //   width: width * 0.4,  // ~40% of screen width
                  //   height: height * 0.07,
                  //   decoration: BoxDecoration(
                  //   ),
                  //   child:  Image.asset(
                  //     "assets/images/logos/image 1.png",
                  //     fit: BoxFit.contain,
                  //   ),
                  //
                  // ),
                  // SizedBox(height: height * 0.03,),

                  Row(
                    children: [
                      Icon(
                        Icons.insert_drive_file_outlined,
                        color: Color(0xffEB8125),
                        size: width * 0.06,
                      ),
                      SizedBox(
                        width: width * 0.015,
                      ),
                      buildFieldTitle(
                          title: "Application Details ", width: width),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),

                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: width * 0.9,
                      decoration: BoxDecoration(
                          color: Color(0xffFFFFFF),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: width * 0.03,
                            bottom: height * 0.030,
                            top: height * 0.05),
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Material(
                              elevation: 7,
                              shape: CircleBorder(),
                              shadowColor: Colors
                                  .black54, // optional: customize shadow color

                              child: Container(
                                padding: EdgeInsets.all(
                                    4), // Thickness of the border
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        Colors.yellow, // 🔶 Your border color
                                    width: 3, // Border width
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: width * 0.15,
                                  backgroundImage: (profilePic.isNotEmpty)
                                      ? NetworkImage(profilePic)
                                      : AssetImage(
                                              'assets/images/default_profile.png')
                                          as ImageProvider,
                                  onBackgroundImageError: (_, __) {
                                    //print('Failed to load image, falling back.');
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Text(
                              "${detailsof.employee.name}",
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontWeight: FontWeight.w600, // SemiBold
                                fontSize: width * 0.04, // ≈11px on 375px width
                                height: 1.2, // 120% line height
                                letterSpacing: 0, // 0%
                              ),
                            ),
                            SizedBox(
                              height: height * 0.005,
                            ),
                            Center(
                              child: Container(
                                width: width * 0.8,
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: width * 0.07,
                                        right: width *
                                            0.07), // ~27.0 when width ≈ 390
                                    child: Text(
                                      "${detailsof.employee.jobTitle}",
                                      textAlign: TextAlign
                                          .center, // 🔑 Align text within the Text widget
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: detailsof
                                  .employee.preferredJobCategories.length,
                              itemBuilder: (context, index) {
                                final category = detailsof
                                    .employee.preferredJobCategories[index];
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: height *
                                        0.01, // ~8px on 800px screen height
                                    horizontal: width *
                                        0.09, // ~16px on 400px screen width
                                  ),
                                  child: Material(
                                    elevation: 2,
                                    borderRadius:
                                        BorderRadius.circular(30), // Pill shape

                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width *
                                            0.0426, // ≈ 16 on 375px width
                                        vertical: height *
                                            0.0098, // ≈ 8 on 812px height
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(
                                            0xFFD9E9FF), // Light blue background
                                        borderRadius: BorderRadius.circular(
                                            30), // Pill shape
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${category.preferredJobCategory}",
                                          style: TextStyle(
                                            color:
                                                Color(0xFF111827), // Dark text
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily:
                                                'Sora', // Optional: match your app font
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: height * 0.05,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: width * 0.03),
                              child: Card(
                                elevation: 1,
                                child: Container(
                                  width: width * 0.8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color(0xffFFFFFF).withOpacity(0.9),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: width * 0.06,
                                        top: height * 0.05,
                                        right: width * 0.05,
                                        bottom: height * 0.05),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        rebuildof(
                                            icona: Icons.mail_outline,
                                            texta: "Email",
                                            textb:
                                                "${detailsof.employee.email}",
                                            context: context),
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        rebuildof(
                                            icona: Icons.phone_outlined,
                                            texta: "Phone",
                                            textb:
                                                "${detailsof.employee.phone}",
                                            context: context),
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        rebuildof(
                                            icona: Icons.location_on_outlined,
                                            texta: "Location",
                                            textb: detailsof
                                                .employee.preferredWorkLocation,
                                            context: context),
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        rebuildof2(
                                            icona: Icons.code_sharp,
                                            texta: "Portfolio Link",
                                            textb:
                                                "${detailsof.employee.portfolio}",
                                            context: context),
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        rebuildod(
                                          icona:
                                              Icons.insert_drive_file_outlined,
                                          texta: "Resume",
                                          textb: "${detailsof.resume}",
                                          isLink: true,
                                          context:
                                              context, // 👈 pass context here
                                        ),
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Homepagedetailpage(
                                        id: detailsof.employee.user!),
                                  ),
                                );
                              },
                              child: Material(
                                elevation: 2,
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: width * 0.72,
                                  height: height * 0.044,
                                  decoration: BoxDecoration(
                                    color: Color(
                                        0xffEB8125), // set your desired background color
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'View Profile',
                                      style: TextStyle(
                                        color: Color(0xffFFFFFF),
                                        fontFamily: 'Sora',
                                        fontWeight:
                                            FontWeight.w600, // 600 = SemiBold
                                        fontSize: width * 0.03,
                                        height: 1.5, // line-height 150%
                                        letterSpacing: 0, // 0%
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget rebuildof2({
  required BuildContext context,
  String? texta,
  String? textb,
  IconData? icona,
}) {
  final width = MediaQuery.of(context).size.width;

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icona!, color: Color(0xff004673)),
      SizedBox(width: width * 0.02),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              texta ?? '',
              style: TextStyle(color: Color(0xff3F414E)),
            ),
            InkWell(
              onTap: () async {
                if (textb != null && await canLaunchUrl(Uri.parse(textb))) {
                  await launchUrl(Uri.parse(textb),
                      mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Could not open the link.")),
                  );
                }
              },
              child: Text(
                textb ?? "Not Available",
                style: TextStyle(
                  color: Color(0xffEB8125),
                  decoration: TextDecoration.underline,
                  fontSize: width * 0.04,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget rebuildof(
    {required BuildContext context,
    String? texta,
    String? textb,
    IconData? icona}) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  return Container(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icona ?? Icons.info_outline, color: Color(0xff004673)),

        SizedBox(width: width * 0.02), // roughly 7 if screen width is ~350
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(texta ?? "", style: TextStyle(color: Color(0xff3F414E))),
            Container(
              width: width * 0.6,
              child: Text(
                textb ?? "Not Available",
                style: TextStyle(
                  color: Color(0xff000000),
                  fontSize: width * 0.04,
                ),
              ),
            ),
          ],
        )
      ],
    ),
  );
}

Widget rebuildod({
  String? texta,
  String? textb,
  IconData? icona,
  bool isLink = false,
  required BuildContext context,

  // pass context to push
}) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  return InkWell(
    onTap: isLink && textb != null //&& context != null
        ? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ResumePdfViewerPage(pdfUrl: textb),
              ),
            );
          }
        : null,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icona, color: Color(0xff004673)),
          SizedBox(width: width * 0.015),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(texta ?? "", style: TextStyle(color: Color(0xff3F414E))),
                Row(
                  children: [
                    Text(
                      isLink ? 'Resume' : (textb ?? ""),
                      style: TextStyle(
                        color: isLink ? Color(0xffEB8125) : Color(0xff3F414E),

                        decoration: isLink ? TextDecoration.underline : null,
                        fontSize: width * 0.0375, // 15px on 400px screen
                      ),
                    ),
                    Icon(
                      Icons.ads_click,
                      color: Color(0xffEB8125),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget buildFieldTitle({String? title, required double width}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Text(
      title!,
      style: TextStyle(
        fontFamily: 'Sora',
        fontWeight: FontWeight.w600,
        fontSize: width * 0.045,
      ),
    ),
  );
}

String breakTextEveryNChars(String text, int chunkSize) {
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i += chunkSize) {
    buffer.writeln(text.substring(
        i, i + chunkSize > text.length ? text.length : i + chunkSize));
  }
  return buffer.toString();
}
