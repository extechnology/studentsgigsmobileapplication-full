import 'package:anjalim/mainpage/postedsisg/components/postjobgigsdetailpage/components/resumeview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../../../homepageifdatalocation/component/homepagedetailpage/homepagedetailpage.dart';
import '../model/model.dart';

class Postjobdetailpagedetail extends StatelessWidget {
  final Postedpagelist  detailsof ;

  const Postjobdetailpagedetail({super.key, required this.detailsof});

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF9F2ED),
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.only(left: width * 0.03,bottom: height* 0.090,top: height* 0.05),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 149,
                    height: 57,
                    decoration: BoxDecoration(
                    ),
                    child:  Image.asset(
                      "assets/images/logos/image 1.png",
                      fit: BoxFit.contain,
                    ),

                  ),
                  SizedBox(height: height * 0.03,),

                  buildFieldTitle("Application Details ",width),
                  SizedBox(height: height * 0.03,),

                  Container(
                    width: width *0.9,
                    decoration: BoxDecoration(
                      color: Color(0xffFFFFFF),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Padding(
                      padding:  EdgeInsets.only(left: width * 0.03,bottom: height* 0.030,top: height* 0.05),
                      child: Column(
                        children: [
                          SizedBox(height: height* 0.03,),
                          CircleAvatar(

                            backgroundImage: NetworkImage(detailsof.employee!.profile!.profilePic ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKw7CSv4kiYTGhtTwYqc6mO9uHRB9cKndI2A&s"

                            ),
                            radius: 30,
                          ),
                          SizedBox(height: height* 0.01,),

                          Text(
                            "${detailsof.employee.name}",
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w600, // SemiBold
                              fontSize: 11, // 11px
                              height: 1.2, // 120% line height
                              letterSpacing: 0, // 0%
                            ),
                          ),
                          Text("${detailsof.employee.jobTitle}"),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: detailsof.employee!.preferredJobCategories.length,
                            itemBuilder: (context, index) {
                              final category = detailsof.employee!.preferredJobCategories[index];
                              return Container(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                child: Text(
                                    category.preferredJobCategory,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: height * 0.05,),
                          Container(
                            width: width * 0.8,
                            decoration: BoxDecoration(

                              borderRadius:  BorderRadius.circular(15),
                              color: Color(0xffDAD9E3).withOpacity(0.1),

                            ),
                            child: Padding(
                              padding:  EdgeInsets.only(left: width * 0.06,top: height * 0.05,right: width * 0.05,bottom: height*0.05
                              ),
                              child:Column(
                                  children: [
                                    SizedBox(height: height* 0.02,),

                                    rebuildof(icona: Icons.mail_outline,texta: "Email",textb: "${detailsof.employee!.email}"),
                                    SizedBox(height: height* 0.02,),

                                    rebuildof(icona: Icons.phone_outlined,texta: "Phone",textb: "${detailsof.employee!.phone}"),
                                    SizedBox(height: height* 0.02,),

                                    rebuildof(icona: Icons.location_on_outlined,texta: "Location",textb: breakTextEveryNChars(detailsof.employee.preferredWorkLocation,24)),
                                    SizedBox(height: height* 0.02,),

                                    rebuildof(icona: Icons.code_sharp,texta: "Portfolio Link",textb: "${detailsof.employee!.portfolio}"),
                                    SizedBox(height: height* 0.02,),

                                    rebuildod(
                                      icona: Icons.insert_drive_file_outlined,
                                      texta: "Resume",
                                      textb: "${detailsof.resume}",
                                      isLink: true,
                                      context: context, // 👈 pass context here

                                    ),
                                    SizedBox(height: height* 0.02,),


                                  ],
                                ),
                            ),
                          ),
                          SizedBox(height: height* 0.03,),

                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Homepagedetailpage(id: detailsof.employee.user),
                                ),
                              );
                            },
                            child: Container(
                              width: 129,
                              height: 27,
                              decoration: BoxDecoration(
                                color: Color(0xffEB8125), // set your desired background color
                                borderRadius: BorderRadius.circular(8),

                              ),
                              child: Center(
                                child: Text(
                                  'View Profile',
                                  style: TextStyle(
                                    fontFamily: 'Sora',
                                    fontWeight: FontWeight.w600, // 600 = SemiBold
                                    fontSize: 8,
                                    height: 1.5, // line-height 150%
                                    letterSpacing: 0, // 0%
                                  ),
                                ),

                              ),

                            ),
                          )


                        ],
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
Widget rebuildof({String ? texta,String ? textb,IconData ? icona}){
  return Container(
    child: Row(crossAxisAlignment: CrossAxisAlignment.start,
      children: [

            Icon(icona!,color: Color(0xff004673),),

        SizedBox(width: 7,),
        Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(texta!,style: TextStyle(color: Color(0xff3F414E)),),
            Text(textb!,style: TextStyle(color: Color(0xff000000),fontSize: 15),),

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
  BuildContext? context,

  // pass context to push
}) {
  return InkWell(
    onTap: isLink && textb != null && context != null
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icona, color: Color(0xff004673)),
          SizedBox(width: 6),
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
                          fontSize: 15
                    
                      ),
                    ),
                    Icon(Icons.ads_click,color: Color(0xffEB8125),),
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

Widget buildFieldTitle(String title, double width) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Text(
      title,
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
    buffer.writeln(text.substring(i, i + chunkSize > text.length ? text.length : i + chunkSize));
  }
  return buffer.toString();
}