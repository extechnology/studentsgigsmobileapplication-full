import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../postedsisg/components/postjobgigsdetailpage/components/resumeview.dart';
import 'cubit/homepagedetail_cubit.dart';
import 'package:intl/intl.dart';


class Homepagedetailpage extends StatelessWidget {
  final int id;
  const Homepagedetailpage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: BlocProvider(
        create: (context) =>
        HomepagedetailCubit()..fetchEmployeeDetail(id: id),
        child: BlocBuilder<HomepagedetailCubit, HomepagedetailState>(
          builder: (context, state) {
            if (state is HomepagedetailLoding) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is Homepagedetailerror) {
              return Center(child: Text("Error: ${state.error}"));
            } else if (state is HomepagedetailLoaded) {
              final data = state.data;
              final profile = data.profile;
              final additional = data.additionalInformation;
              final workPref = data.workPreferences.isNotEmpty
                  ? data.workPreferences.first
                  : null;

              final coverPhoto = profile.coverPhoto;
              final imageUrl =
                  coverPhoto ?? "https://via.placeholder.com/150";
              final profileImage =
                  profile.profilePic ?? "https://via.placeholder.com/150";

              return Scaffold(
                backgroundColor: const Color(0xffF9F2ED),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: imageUrl.isNotEmpty ? height * 0.3 : height * 0.1,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(height * 0.055),
                                bottomRight: Radius.circular(height * 0.055),
                              ),
                              child: imageUrl.isNotEmpty
                                  ? Image.network(
                                imageUrl,
                                width: width,
                                height: height * 0.26,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // In case image URL is invalid or fails to load
                                  return SizedBox();
                                },
                              )
                                  : SizedBox(


                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: height * 0.132,
                                height: height * 0.132,
                                margin: EdgeInsets.only(top: height * 0.015),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Color(0xffFFFFFF), // 🟡 Changed to yellow border
                                    width: height * 0.0055,
                                  ),
                                  color: Colors.grey[300], // fallback background color
                                ),
                                child: profileImage.isNotEmpty
                                    ? ClipOval(
                                  child: Image.network(
                                    profileImage,
                                    fit: BoxFit.cover,
                                    width: height * 0.1,
                                    height: height * 0.1,
                                    errorBuilder: (context, error, stackTrace) => const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                                    : const Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),


                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                          width: width* 0.80,
                          child: Text(
                            '${data.username}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600, // Semi Bold
                              fontSize: 16,
                              height: 23 / 16, // Line-height in px ÷ font-size = 1.4375
                              letterSpacing: 0.15, // Same as in CSS
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height* 0.01,),
                      Center(
                        child: Padding(
                          padding:  EdgeInsets.only(right: width * 0.1 ,left: width * 0.1),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.04, // responsive horizontal padding
                              vertical: height * 0.01,  // responsive vertical padding
                            ),                            decoration: BoxDecoration(

                              color: Color(0xffDAD9E3).withOpacity(0.3), // Light grey-purple background (you can tweak)
                              borderRadius: BorderRadius.circular(4), // Optional: slight rounding
                            ),
                            child: Text(
                              '${data.jobTitle}',
                              textAlign: TextAlign.center,

                              style: TextStyle(
                                color: Color(0xffD50054), // Strong pink/magenta tone
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: height * 0.01,),
                            buildes(text: "About Me", context: context),
                            buildes2(text:
                                data.about ?? 'N/A',  context: context),
                            SizedBox(height: height * 0.015), // 1.5% of screen height
                            Row(
                              children: [
                                buildes(text: "Personal Details", context: context),
                                SizedBox(width: width * 0.012), // For example, ~5px if screen width is ~400
                                const Icon(Icons.person_2_outlined)
                              ],
                            ),
                            Card(
                              elevation: 4,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(height * 0.021), // Example: ~17 on 800px height
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.1,
                                    vertical: height * 0.03,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      builde3(text: "Name", context: context),
                                      builde4(text:data.name ?? 'N/A', context: context),
                                      builde3(text: "E-mail", context: context),
                                      builde4(text:data.email ?? 'N/A', context: context),
                                      builde3(text: "Contact Number", context: context),
                                      builde4(text:data.phone ?? 'N/A', context: context),
                                      builde3(text: "Available Working Hours", context: context),
                                      builde4(text:"${data.availableWorkHours}", context: context),
                                      builde3(text: "Preferred Location", context: context),
                                      builde4(text:
                                          data.preferredWorkLocation ?? 'N/A', context: context),
                                      builde3(text: "Language Known", context: context),
                                      builde4(text:
                                        data.languages.isNotEmpty
                                            ? data.languages
                                            .map((e) => e.language ?? '')
                                            .where((lang) => lang.isNotEmpty)
                                            .join(", ")
                                            : 'N/A', context: context,
                                      ),
                                       SizedBox(height:height * 0.015),
                                      Center(
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            final resumeUrl = additional.employeeResume;

                                            if (resumeUrl != null) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => ResumePdfViewerPage(pdfUrl: resumeUrl),
                                                ),
                                              );
                                            } else {
                                              // Optional: Show error message or fallback
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text("Resume not available")),
                                              );
                                            }
                                          },
                                          icon: const Icon(Icons.download,
                                              color: Colors.white),
                                          label:  Text(
                                            'Download CV',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Sora',
                                              fontWeight: FontWeight.w600,
                                              fontSize: height * 0.02,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                            const Color(0xffEB8125),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(height * 0.02),
                                            ),
                                            fixedSize: Size(
                                              width * 0.55,  // approx 55% of screen width
                                              height * 0.05, // approx 5% of screen height
                                            ),                                        ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                             SizedBox(
                                 height: height * 0.025),
                            Row(
                              children: [
                                buildes(text: "Technical Skills", context: context),
                                SizedBox(width: width * 0.0125), // 5 if screen width ≈ 400
                                const Icon(Icons.emoji_events),
                              ],
                            ),
                            GridView.builder(
                              itemCount: data.technicalSkills.length,
                              shrinkWrap: true,
                              physics:  NeverScrollableScrollPhysics(),
                              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: height * 0.02,   // e.g., 2% of screen height
                                crossAxisSpacing: width * 0.04,   // e.g., 4% of screen width
                                childAspectRatio: width / (height * 0.20), // or tweak to get similar to 2.8
                              ),
                              itemBuilder: (context, index) {
                                final skill = data.technicalSkills[index];

                                // Map technical level to percentage
                                double percent = 0.0;
                                switch (skill.technicalLevel?.toLowerCase()) {
                                  case 'beginner':
                                    percent = 0.3;
                                    break;
                                  case 'intermediate':
                                    percent = 0.6;
                                    break;
                                  case 'expert':
                                    percent = 1.0;
                                    break;
                                  default:
                                    percent = 0.0;
                                }

                                return Container(
                                  padding: EdgeInsets.all(width * 0.03), // or use height * 0.015
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(height * 0.015), // roughly 12 on 800px height
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(crossAxisAlignment:CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: width * 0.271,

                                            child: Text(
                                              skill.technicalSkill ?? 'N/A',
                                              style:  TextStyle(
                                                fontFamily: 'Sora',
                                                fontWeight: FontWeight.w600,
                                                fontSize: height * 0.0175, // ≈14 when height is ~800
                                                color: Color(0xFF003B5B),
                                                overflow: TextOverflow.ellipsis,

                                              ),
                                            ),
                                          ),
                                          SizedBox(width: width * 0.01,),
                                          Text(
                                            "${(percent * 100).toInt()}%",
                                            style: TextStyle(
                                              fontSize: height * 0.015,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: height * 0.01), // 0.01 → ~8px on 800px screen height
                                      LinearProgressIndicator(
                                        value: percent,
                                        color: Colors.green,
                                        backgroundColor: Colors.grey[300],
                                        minHeight: height * 0.0075, // ~6px on 800px height
                                        borderRadius: BorderRadius.circular(height * 0.005), // ~4px on 800px height

                                      ),

                                    ],
                                  ),
                                );
                              },
                            ),
                            Row(
                              children: [
                                buildes(text: "Soft Skills", context: context),
                                SizedBox(width: width * 0.012), // ≈ 5px if screen width is ~400
                                const Icon(Icons.lightbulb_outline_sharp),
                              ],
                            ),
                            GridView.builder(
                              itemCount: data.softSkills.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: height * 0.02,
                                crossAxisSpacing: width * 0.04,
                                childAspectRatio: 2.5, // Try removing it or increasing the ratio (e.g. 2.5 or 3)
                              ),
                              itemBuilder: (context, index) {
                                final skill = data.softSkills[index];

                                return Material(
                                  elevation: 1,
                                  borderRadius: BorderRadius.circular(height * 0.02),

                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEAE8EF),
                                      borderRadius: BorderRadius.circular(height * 0.02),
                                    ),
                                    padding: EdgeInsets.all(height * 0.015),
                                    child: Center(
                                      child: Text(
                                        skill.softSkill ?? 'N/A',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Sora',
                                          fontWeight: FontWeight.w600,
                                          fontSize: height * 0.0175,
                                          color: const Color(0xFF003B5B),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Row(
                              children: [
                                buildes(text: "Experience", context: context),
                                SizedBox(width: width * 0.012), // Adjust multiplier as needed
                                const Icon(Icons.work_outline),
                              ],
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: data.experiences.length,
                              itemBuilder: (context, index) {
                                final use = data.experiences[index];
                                return
                                  Card(

                                    elevation: 4,
                                    child: Container(
                                      width: width *9,

                                      decoration: BoxDecoration(borderRadius:BorderRadius.circular(15),
                                        color: Color(0xffF9F2ED).withOpacity(0.80),


                                      ),
                                      child: Padding(
                                        padding:  EdgeInsets.only(bottom: height *0.01,top: height*0.015),
                                        child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Container(
                                            //   width: 1.99999915407683,
                                            //   height: 67.9999999747485622,
                                            //   decoration: BoxDecoration(
                                            //     color: Color(0xffEB8125), // Or any color you want
                                            //     borderRadius: BorderRadius.circular(5),
                                            //   ),
                                            //
                                            // ),
                                            SizedBox(width: width*0.04,),
                                            Icon(Icons.work_outline),
                                            SizedBox(width: width*0.04,),

                                            Column  (crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width : width * 0.52,


                                                  child: Text(
                                                    use.expJobTitle ??"" ,
                                                    style: TextStyle(
                                                      fontFamily: 'Sora',
                                                      fontWeight: FontWeight.w400, // Regular
                                                      fontSize: width * 0.032, // Example: 3.2% of screen width
                                                      height: 1.35, // 135% line height = 15 * 1.35 = ~20.25px
                                                      letterSpacing: 0,
                                                      color: Colors.black, // Optional: set color if needed
                                                    ),
                                                  ),
                                                ),

                                                Row(
                                                  children: [
                                                    // CircleAvatar(
                                                    //   backgroundImage:NetworkImage("")
                                                    //   ,
                                                    //   radius: 15,
                                                    // ),
                                                    SizedBox(width: width*0.002,),

                                                    Container(
                                                      width: width* 0.28,
                                                      child: Text(
                                                        '${use.expCompanyName}',
                                                        style: TextStyle(
                                                          fontFamily: 'Sora',
                                                          fontWeight: FontWeight.w700, // Bold
                                                          fontSize:width * 0.028,
                                                          height: 1.35, // 135% line height (11 * 1.35 ≈ 14.85px)
                                                          letterSpacing: 0,
                                                          color: Color(0xff004673), // Optional: adjust as needed
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: width * 0.2,),
                                                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'Present',
                                                          style: TextStyle(
                                                            fontFamily: 'Sora',
                                                            fontWeight: FontWeight.w200, // ExtraLight
                                                            fontSize: width * 0.021,
                                                            height: 1.35, // 135% line height (8 * 1.35 = 10.8)
                                                            letterSpacing: 0,
                                                            color: Colors.black, // Optional: adjust as needed
                                                          ),
                                                        ),
                                                        Container(
                                                          width: width* 0.26,
                                                          child: Text(
                                                            use.expEndDate != null
                                                                ? DateFormat('dd MMM yyyy').format(use.expEndDate!)
                                                                : 'N/A',
                                                            style:  TextStyle(
                                                              fontFamily: 'Sora',
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: width * 0.026,
                                                              height: 1.35,
                                                              letterSpacing: 0,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        ),

                                                      ],

                                                    ),


                                                  ],
                                                ),


                                              ],
                                            ),
                                            SizedBox(width: width*0.00011,),




                                          ],
                                        ),
                                      ),
                                    ),

                                  );

                              },),
                            Row(
                              children: [
                                buildes(text: "Educational Qualifications", context: context),
                                 SizedBox(width: width * 0.012),
                                const Icon(Icons.school_outlined),
                              ],
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: data.educations.length,
                              itemBuilder: (context, index) {
                                final use = data.educations[index];
                                return
                                  Card(

                                    elevation: 6,
                                    child: Container(
                                      width: width *9,

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(height * 0.018), // ~15 when height = 800
                                        color: Color(0xffF9F2ED).withOpacity(0.45),


                                      ),
                                      child: Padding(
                                        padding:  EdgeInsets.only(bottom: height *0.01,top: height*0.015),
                                        child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Container(
                                            //   width: 1.99999915407683,
                                            //   height: 67.9999999747485622,
                                            //   decoration: BoxDecoration(
                                            //     color: Color(0xffEB8125), // Or any color you want
                                            //     borderRadius: BorderRadius.circular(5),
                                            //   ),
                                            //
                                            // ),
                                            SizedBox(width: width*0.04,),
                                            SizedBox(width: width*0.04,),

                                            Column  (crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                Container(
                                                  width: width* 0.38,
                                                  child: Text(
                                                   use.fieldOfStudy ?? "",
                                                    style: TextStyle(
                                                      fontFamily: 'Sora',
                                                      fontWeight: FontWeight.w400, // Regular
                                                      fontSize: height * 0.016, // ≈13 when height = 812
                                                      height: 1.35, // 135% line height = 15 * 1.35 = ~20.25px
                                                      letterSpacing: 0,
                                                      color: Colors.black, // Optional: set color if needed
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: height*0.01,),

                                                Row(crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.account_balance,color: Color(0xff000000),size: width * 0.036,),


                                                    // CircleAvatar(
                                                    //
                                                    //   radius: height * 0.0185, // approx 15 on a 812px height screen
                                                    // ),
                                                    SizedBox(width: width*0.02,),

                                                    Container(
                                                      width: width* 0.40,
                                                      child: Text(
                                                        use.nameOfInstitution ??"",
                                                        style: TextStyle(
                                                          fontFamily: 'Sora',
                                                          fontWeight: FontWeight.w700, // Bold
                                                          fontSize: width * 0.027, // roughly 11 on a 400px width device
                                                          height: 1.35, // 135% line height (11 * 1.35 ≈ 14.85px)
                                                          letterSpacing: 0,
                                                          color: Color(0xff004673), // Optional: adjust as needed
                                                        ),
                                                      ),
                                                    )

                                                  ],
                                                ),


                                              ],
                                            ),
                                            SizedBox(width: width*0.12,),


                                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                Container(
                                                  width: width* 0.18,
                                                  child: Text(
                                                    use.expectedGraduationYear?.toString() ?? 'N/A',
                                                    style:  TextStyle(
                                                      fontFamily: 'Sora',
                                                      fontWeight: FontWeight.w400, // Regular
                                                      fontSize: width * 0.025, // roughly 10 on a 400px wide device
                                                      height: 1.35,
                                                      letterSpacing: 0,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),

                                              ],

                                            ),


                                          ],
                                        ),
                                      ),
                                    ),

                                  );

                              },),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

Widget buildes({ required BuildContext context ,String? text}) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  return Text(
    text ?? '',
    style:  TextStyle(
      color: Color(0xff3F414E),
      fontFamily: 'Sora',
      fontWeight: FontWeight.w600,
      fontSize:width * 0.043,
      height: 32 /17,
      letterSpacing: 0,
    ),
  );
}

Widget buildes2({required BuildContext context ,String? text}) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  return Text(
    text ?? '',
    style:  TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
      fontSize: width * 0.035,
      height: 24 / 12,
      letterSpacing: 0,
    ),
  );
}

String breakTextEveryNChars(String text, int chunkSize) {
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i += chunkSize) {
    buffer.writeln(text.substring(i, i + chunkSize > text.length ? text.length : i + chunkSize));
  }
  return buffer.toString();
}

Widget builde3({required BuildContext context ,String? text}) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Text(
      text ?? '',
      style:  TextStyle(
        fontFamily: 'Sora',
        fontWeight: FontWeight.w600,
        fontSize: width * 0.0385,
        height: 32 / 17,
        letterSpacing: 0,
      ),
    ),
  );
}

Widget builde4({required BuildContext context ,String? text}) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  return Text(
    text ?? '',
    style:  TextStyle(
      fontFamily: 'Sora',
      fontWeight: FontWeight.w300,
      fontSize:width * 0.031,
      height: 32 / 17,
      letterSpacing: 0,
    ),
  );
}
