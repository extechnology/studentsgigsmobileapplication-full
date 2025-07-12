import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/postjobgigsdetailpage/postjobgigsdetailpage.dart';
import 'cubit/getpostjob_cubit.dart';

class Postedgigs extends StatelessWidget {
  const Postedgigs({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
  create: (context) => GetpostjobCubit(),
  child: BlocBuilder<GetpostjobCubit, GetpostjobState>(
  builder: (context, state) {
    final cubit = context.read<GetpostjobCubit>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF9F2ED),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + height * 0.1,right: width *0.07,left: width * 0.07,top: MediaQuery.of(context).viewInsets.top + height * 0.03 ),
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start ,
              children: [
                buildFieldTitle("Posted Gigs",width),
                SizedBox(height: height * 0.03,),
                if (state is GetpostjobIoading)
                  Center(child: CircularProgressIndicator())
                else if (state is Getpostjoberror)
                  Text(state.message)
                else if (state is GetpostjobIoaded)

                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(), // important!

                  itemCount: state.jobs.length,
                  itemBuilder: (context, index) {
                    final job = state.jobs[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Postjobgigsdetailpage(id: job.id ,jobType: job.jobType! ,catecortyjob: job.category!,),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                         width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xffFFFFFF)
                        ),
                        child: Padding(
                          padding:  EdgeInsets.only(bottom: height * 0.02,top: height * 0.02,left: width * 0.04,right:  width * 0.04,),
                          child: Column(
                            children: [
                              Row(

                                children: [


                                     Container(
                                      width: 160,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(job.jobTitle ?? "Unknown Title",
                                            style: TextStyle(
                                              fontFamily: 'Sora',
                                              fontWeight: FontWeight.w400, // Normal weight
                                              fontSize: 15,                // 15px font size
                                              height: 1.35,                // Line height = 135%
                                              letterSpacing: 0.0,          // No letter spacing
                                              color: Colors.black,         // Optional
                                            ),
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                          )
                                        ],
                                      ),


                                    ),
                                        SizedBox(width: width * 0.01,),

                                        Row(
                                          children: [

                                            Container(
                                              width: 48,
                                              height: 15,
                                              decoration: BoxDecoration(
                                                color: Color(0xff9FEBA8),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Center(
                                                child:
                                                Padding(
                                                  padding:  EdgeInsets.only(bottom: height * 0.001,top: height * 0.001,left: width * 0.001,right:  width * 0.001,),
                                                  child: Text(
                                                    job.jobType ?? "Unknown",
                                                    style: TextStyle(
                                                      fontFamily: 'Sora',
                                                      fontWeight: FontWeight.w400, // Regular weight
                                                      fontSize: 11,
                                                      height: 1.35,                // Line height = 135%
                                                      letterSpacing: 0.0,
                                                      color: Colors.black,         // Optional
                                                    ),
                                                  ),
                                                )
                                              ),

                                            ),
                                            SizedBox(
                                              width: width * 0.2,
                                            ),

                                            Icon(
                                              Icons.favorite,
                                              size: 25,
                                              color: Colors.red,
                                            ),

                                          ],
                                        ),






                                ],
                              ),
                              SizedBox(height: height * 0.01,),
                              Row(
                                children: [
                                  CircleAvatar(

                                    radius: 12,
                                    backgroundImage:NetworkImage(job.company!.logo ?? "") ,
                                  ),
                                  SizedBox(width: width * 0.01,),
                                  Column(
                                    children: [
                                      Text(
                                        job.company!.companyName ?? 'Unknown Company' ,
                                        style: TextStyle(
                                          fontFamily: 'Sora',
                                          fontWeight: FontWeight.w700, // Bold
                                          fontSize: 11,                // 11px
                                          height: 1.35,                // 135% line height
                                          letterSpacing: 0.0,          // No extra spacing
                                          color: Colors.black,         // Optional
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: height * 0.01,),

                              Row(
                                children: [
                                  Text(
                                    'Gig Pay',
                                    style: TextStyle(
                                      fontFamily: 'Sora',
                                      fontWeight: FontWeight.w200, // Thin
                                      fontSize: 8,
                                      height: 1.35, // This is 135% line height
                                      letterSpacing: 0.0,
                                      color: Colors.black, // optional
                                    ),
                                  ) ,
                                  SizedBox(width: width * 0.33,),
                                  Text(
                                    'Experience Level',
                                    style: TextStyle(
                                      fontFamily: 'Sora',
                                      fontWeight: FontWeight.w200, // Thin
                                      fontSize: 8,
                                      height: 1.35, // This is 135% line height
                                      letterSpacing: 0.0,
                                      color: Colors.black, // optional
                                    ),
                                  )

                                ],
                              ),
                              SizedBox(height: height * 0.01,),

                              Row(
                                children: [
                                  Container(
                                    width: width * 0.4,
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "₹${job.payStructure ?? ""} - ${job.salaryType ?? ""}",
                                          style: TextStyle(
                                            fontFamily: 'Sora',
                                            fontWeight: FontWeight.w400, // Regular
                                            fontSize: 10,                // 10px
                                            height: 1.35,                // Line height = 135%
                                            letterSpacing: 0.0,         // No extra spacing
                                            color: Colors.black,        // Optional
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Text(
                                    'Middle',
                                    style: TextStyle(
                                      fontFamily: 'Sora',
                                      fontWeight: FontWeight.w400, // Regular
                                      fontSize: 10,                // 10px
                                      height: 1.35,                // Line height = 135%
                                      letterSpacing: 0.0,         // No extra spacing
                                      color: Colors.black,        // Optional
                                    ),
                                  ),
                                  SizedBox(width: width * 0.15,),
                                  Text(
                                    '${job.postedDate!.difference(DateTime.now()).inDays.abs()} days ago',                                  style: TextStyle(
                                      fontFamily: 'Sora',
                                      fontWeight: FontWeight.w400, // Regular
                                      fontSize: 10,                // 10px
                                      height: 1.35,                // Line height = 135%
                                      letterSpacing: 0.0,         // No extra spacing
                                      color: Colors.black,        // Optional
                                    ),
                                  ),



                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },)
                
              ],
            ),
          ),
        ),
      ),
    );
  },
),
);
  }
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

