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
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60),
                        ),
                        child: Image.network(
                          imageUrl,
                          width: width,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.only(top: 12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            image: DecorationImage(
                              image: NetworkImage(profileImage),
                              fit: BoxFit.cover,
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
                            buildes("About Me"),
                            buildes2(breakTextEveryNChars(
                                data.about ?? 'N/A', 49)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                buildes("Personal Details"),
                                const SizedBox(width: 5),
                                const Icon(Icons.person_2_outlined)
                              ],
                            ),
                            Card(
                              elevation: 4,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(17),
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
                                      builde3("Name"),
                                      builde4(data.name ?? 'N/A'),
                                      builde3("E-mail"),
                                      builde4(data.email ?? 'N/A'),
                                      builde3("Contact Number"),
                                      builde4(data.phone ?? 'N/A'),
                                      builde3("Available Working Hours"),
                                      builde4("${data.availableWorkHours}"),
                                      builde3("Preferred Location"),
                                      builde4(
                                          data.preferredWorkLocation ?? 'N/A'),
                                      builde3("Language Known"),
                                      builde4(
                                        data.languages.isNotEmpty
                                            ? data.languages
                                            .map((e) => e.language ?? '')
                                            .where((lang) => lang.isNotEmpty)
                                            .join(", ")
                                            : 'N/A',
                                      ),
                                      const SizedBox(height: 12),
                                      ElevatedButton.icon(
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
                                        label: const Text(
                                          'Download CV',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Sora',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          const Color(0xffEB8125),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(16),
                                          ),
                                          fixedSize: const Size(218, 40),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                buildes("Technical Skills"),
                                const SizedBox(width: 5),
                                const Icon(Icons.emoji_events),
                              ],
                            ),
                            GridView.builder(
                              itemCount: data.technicalSkills.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 2.8,
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
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAE8EF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        skill.technicalSkill ?? 'N/A',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'Sora',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Color(0xFF003B5B),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      LinearProgressIndicator(
                                        value: percent,
                                        color: Colors.green,
                                        backgroundColor: Colors.grey[300],
                                        minHeight: 6,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Row(
                              children: [
                                buildes("Soft Skills"),
                                const SizedBox(width: 5),
                                const Icon(Icons.lightbulb_outline_sharp),
                              ],
                            ),
                            GridView.builder(
                              itemCount: data.softSkills.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 2.8,
                              ),
                              itemBuilder: (context, index) {
                                final skill = data.softSkills[index];

                                // Map technical level to percentage


                                return Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAE8EF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        skill.softSkill ?? 'N/A',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'Sora',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Color(0xFF003B5B),
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                    ],
                                  ),
                                );
                              },
                            ),
                            Row(
                              children: [
                                buildes("Experience"),
                                const SizedBox(width: 5),
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

                                    elevation: 2,
                                    child: Container(
                                      width: width *9,

                                      decoration: BoxDecoration(borderRadius:BorderRadius.circular(15),
                                        color: Color(0xffFFFFFF).withOpacity(0.7),


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
                                                Text(
                                                  breakTextEveryNChars(use.expJobTitle ?? "",10),
                                                  style: TextStyle(
                                                    fontFamily: 'Sora',
                                                    fontWeight: FontWeight.w400, // Regular
                                                    fontSize: 13,
                                                    height: 1.35, // 135% line height = 15 * 1.35 = ~20.25px
                                                    letterSpacing: 0,
                                                    color: Colors.black, // Optional: set color if needed
                                                  ),
                                                ),
                                                SizedBox(height: height*0.01,),

                                                Row(
                                                  children: [
                                                    // CircleAvatar(
                                                    //   backgroundImage:NetworkImage("")
                                                    //   ,
                                                    //   radius: 15,
                                                    // ),
                                                    SizedBox(width: width*0.02,),

                                                    Text(
                                                      '${use.expCompanyName}',
                                                      style: TextStyle(
                                                        fontFamily: 'Sora',
                                                        fontWeight: FontWeight.w700, // Bold
                                                        fontSize: 11,
                                                        height: 1.35, // 135% line height (11 * 1.35 ≈ 14.85px)
                                                        letterSpacing: 0,
                                                        color: Colors.black, // Optional: adjust as needed
                                                      ),
                                                    )

                                                  ],
                                                ),


                                              ],
                                            ),
                                            SizedBox(width: width*0.22,),


                                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Present',
                                                  style: TextStyle(
                                                    fontFamily: 'Sora',
                                                    fontWeight: FontWeight.w200, // ExtraLight
                                                    fontSize: 8,
                                                    height: 1.35, // 135% line height (8 * 1.35 = 10.8)
                                                    letterSpacing: 0,
                                                    color: Colors.black, // Optional: adjust as needed
                                                  ),
                                                ),
                                                Text(
                                                  use.expEndDate != null
                                                      ? DateFormat('dd MMM yyyy').format(use.expEndDate!)
                                                      : 'N/A',
                                                  style: const TextStyle(
                                                    fontFamily: 'Sora',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 10,
                                                    height: 1.35,
                                                    letterSpacing: 0,
                                                    color: Colors.black,
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
                            Row(
                              children: [
                                buildes("Educational Qualifications"),
                                const SizedBox(width: 5),
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

                                    elevation: 2,
                                    child: Container(
                                      width: width *9,

                                      decoration: BoxDecoration(borderRadius:BorderRadius.circular(15),
                                        color: Color(0xffFFFFFF).withOpacity(0.7),


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
                                                Text(
                                                  breakTextEveryNChars(use.fieldOfStudy ?? "",10),
                                                  style: TextStyle(
                                                    fontFamily: 'Sora',
                                                    fontWeight: FontWeight.w400, // Regular
                                                    fontSize: 13,
                                                    height: 1.35, // 135% line height = 15 * 1.35 = ~20.25px
                                                    letterSpacing: 0,
                                                    color: Colors.black, // Optional: set color if needed
                                                  ),
                                                ),
                                                SizedBox(height: height*0.01,),

                                                Row(crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage:NetworkImage("")
                                                      ,
                                                      radius: 15,
                                                    ),
                                                    SizedBox(width: width*0.02,),

                                                    Text(
                                                      breakTextEveryNChars(use.nameOfInstitution ??"",20),
                                                      style: TextStyle(
                                                        fontFamily: 'Sora',
                                                        fontWeight: FontWeight.w700, // Bold
                                                        fontSize: 11,
                                                        height: 1.35, // 135% line height (11 * 1.35 ≈ 14.85px)
                                                        letterSpacing: 0,
                                                        color: Colors.black, // Optional: adjust as needed
                                                      ),
                                                    )

                                                  ],
                                                ),


                                              ],
                                            ),
                                            SizedBox(width: width*0.22,),


                                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                Text(
                                                  use.expectedGraduationYear?.toString() ?? 'N/A',
                                                  style: const TextStyle(
                                                    fontFamily: 'Sora',
                                                    fontWeight: FontWeight.w400, // Regular
                                                    fontSize: 10,
                                                    height: 1.35,
                                                    letterSpacing: 0,
                                                    color: Colors.black,
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

Widget buildes(String? text) {
  return Text(
    text ?? '',
    style: const TextStyle(
      fontFamily: 'Sora',
      fontWeight: FontWeight.w600,
      fontSize: 20,
      height: 32 / 20,
      letterSpacing: 0,
    ),
  );
}

Widget buildes2(String? text) {
  return Text(
    text ?? '',
    style: const TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 24 / 14,
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

Widget builde3(String? text) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Text(
      text ?? '',
      style: const TextStyle(
        fontFamily: 'Sora',
        fontWeight: FontWeight.w600,
        fontSize: 17,
        height: 32 / 17,
        letterSpacing: 0,
      ),
    ),
  );
}

Widget builde4(String? text) {
  return Text(
    text ?? '',
    style: const TextStyle(
      fontFamily: 'Sora',
      fontWeight: FontWeight.w300,
      fontSize: 17,
      height: 32 / 17,
      letterSpacing: 0,
    ),
  );
}
