import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../datapage/datapage.dart';
import '../widgets/neterror.dart';
import 'components/postjobgigsdetailpage/postjobgigsdetailpage.dart';
import 'cubit/getpostjob_cubit.dart';
import 'cubit2/delete_cubit.dart';

class Postedgigs extends StatelessWidget {
  const Postedgigs({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return MultiBlocProvider(
  providers: [
    BlocProvider(
  create: (context) => GetpostjobCubit(),
),
    BlocProvider(
      create: (context) => DeleteCubit(),
    ),
  ],
  child: BlocBuilder<GetpostjobCubit, GetpostjobState>(
  builder: (context, state) {
    final cubit = context.read<GetpostjobCubit>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF9F2ED),
        body: RefreshIndicator(
          backgroundColor: Color(0xffFFFFFF),
          color: Color(0xff000000),
          onRefresh: ()async {
            await cubit.fetchJobPosts();      // optional: clear old cache
          },

          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + height * 0.1,right: width *0.07,left: width * 0.07,top: MediaQuery.of(context).viewInsets.top + height * 0.014 ),
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start ,
                children: [
                  buildFieldTitle("Posted Gigs",width,height),
                  SizedBox(height: height * 0.015,),
                  if (state is GetpostjobIoading)
                    Center(child: CircularProgressIndicator())
                  else if (state is Getpostjoberror)
                    const NoInternetWidget(

                    )
                  else if (state is GetpostjobIoaded)
                      if (state.jobs.isEmpty)
                        buildEmptyState(context)
                    else

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
                            builder: (_) => Postjobgigsdetailpage(id: job.id! ,jobType: job.jobType! ,catecortyjob: job.category!,),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.005),
                        child:
                        Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(width * 0.04),

                          child: Container(
                            width: width * 0.9,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(width * 0.04),
                              color: Color(0xffFFFFFF)
                            ),
                            child: Padding(
                              padding:  EdgeInsets.only(bottom: height * 0.02,top: height * 0.02,left: width * 0.04,right:  width * 0.04,),
                              child: Column(
                                children: [
                                  Row(

                                    children: [


                                         Container(
                                           width: width * 0.45,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(job.jobTitle ?? "Unknown Title",
                                                style: TextStyle(
                                                  fontFamily: 'Sora',
                                                  fontWeight: FontWeight.w400, // Normal weight
                                                  fontSize: width * 0.038,
                                                  height: 1.35,                // Line height = 135%
                                                  letterSpacing: 0.0,          // No letter spacing
                                                  color: Colors.black,         // Optional
                                                ),
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,

                                              )
                                            ],
                                          ),


                                        ),
                                            SizedBox(width: width * 0.01,),

                                            Row(
                                              children: [

                                                Material(

                                                  elevation: 2,
                                                  borderRadius: BorderRadius.circular(width * 0.0125), // ~5 on 400px width

                                                  child: Container(
                                                    width: width * 0.12,   // roughly 48 on 400px screen
                                                    height: height * 0.018,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff9FEBA8),
                                                      borderRadius: BorderRadius.circular(width * 0.0125), // ~5 on 400px width
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
                                                            fontSize: width * 0.0275, // ~11 on 400px width
                                                            height: 1.35,                // Line height = 135%
                                                            letterSpacing: 0.0,
                                                            color: Colors.black,         // Optional
                                                          ),
                                                        ),
                                                      )
                                                    ),

                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width * 0.13,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    final token = await ApiConstantsemployer.getTokenOnly(); // ✅ get actual token
                                                    // final token2 = await ApiConstants.getTokenOnly2(); // ✅ get actual token

                                                    final tokens = token; // ✅ Replace with secure storage or cubit
                                                    // final token3 = token2; // ✅ Replace with secure storage or cubit

                                                    final deleteCubit = context.read<DeleteCubit>();

                                                    // ✅ Optional: Show confirmation dialog
                                                    final confirm = await showDialog<bool>(
                                                      context: context,
                                                      builder: (ctx) => AlertDialog(
                                                        backgroundColor: Color(0xffFFFFFF),
                                                        title: Text("Confirm Delete"),
                                                        content: Text("Are you sure you want to delete this gig?"),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.pop(ctx, false),
                                                            child: Text("Cancel"),
                                                          ),
                                                          TextButton(
                                                            onPressed: () => Navigator.pop(ctx, true),
                                                            child: Text("Delete"),
                                                          ),
                                                        ],
                                                      ),
                                                    );

                                                    if (confirm == true) {
                                                      await deleteCubit.deleteJob(
                                                        type: job.jobType ?? "online",
                                                        pk: job.id!,
                                                        token: tokens!,
                                                      );

                                                      final deleteState = deleteCubit.state;
                                                      if (deleteState is DeleteobSucces) {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text("Job deleted successfully")),
                                                        );
                                                        // ✅ Reload the jobs
                                                        context.read<GetpostjobCubit>().fetchJobPosts(); // Adjust based on your method name
                                                      } else if (deleteState is DeletejobError) {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text(deleteState.message)),
                                                        );
                                                      }
                                                    }
                                                  },
                                                  child: Icon(Icons.delete),
                                                ),




                                              ],
                                            ),






                                    ],
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Row(
                                    children: [
                                      CircleAvatar(

                                        radius: width * 0.03, // ~12 when width is 400
                                        backgroundColor: Colors.grey[200],
                                        backgroundImage: (job.company?.logo != null && job.company!.logo!.isNotEmpty)
                                            ? NetworkImage(job.company!.logo!)
                                            : null,
                                        child: (job.company?.logo == null || job.company!.logo!.isEmpty)
                                            ? Icon(Icons.person, size: 14, color: Colors.grey)
                                            : null,                                      ),
                                      SizedBox(width: width * 0.01,),
                                      Column(
                                        children: [
                                          Text(
                                            job.company!.companyName ?? 'Unknown Company' ,
                                            style: TextStyle(
                                              fontFamily: 'Sora',
                                              fontWeight: FontWeight.w700, // Bold
                                              fontSize: width * 0.0275, // ≈ 11 when width is 400
                                              height: 1.35,                // 135% line height
                                              letterSpacing: 0.0,          // No extra spacing
                                              color: Colors.black,
                          // Optional
                                            ),
                                            overflow: TextOverflow.ellipsis,

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
                                          fontSize: width * 0.02, // ~8px when width is 400
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
                                          fontSize: width * 0.02, // ~8px when width is 400
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
                                                fontSize: width * 0.025, // ≈ 10px when width is ~400
                                                height: 1.35,                // Line height = 135%
                                                letterSpacing: 0.0,         // No extra spacing
                                                color: Colors.black,        // Optional
                                              ),
                                              overflow: TextOverflow.ellipsis,

                                            ),
                                          ],
                                        ),
                                      ),

                                      Text(
                                        'Middle',
                                        style: TextStyle(
                                          fontFamily: 'Sora',
                                          fontWeight: FontWeight.w400, // Regular
                                          fontSize: width * 0.025,                // 10px
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
                                          fontSize: width * 0.025,                // 10px
                                          height: 1.35,                // Line height = 135%
                                          letterSpacing: 0.0,         // No extra spacing
                                          color: Colors.black,        // Optional
                                        ),
                                        overflow: TextOverflow.ellipsis,

                                      ),



                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                   },
                  )


                ],
              ),
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
Widget buildFieldTitle(String title, double width,double height ) {
  return Padding(
    padding:  EdgeInsets.symmetric(vertical: height * 0.00625,),
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

Widget buildEmptyState(BuildContext context) {
  return Center(
    child: Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.work_off_rounded,
            size: 64,
            color: Colors.orange[300],
          ),
          const SizedBox(height: 16),
          Text(
            "You Haven’t Posted Any Jobs",
            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Post a job now to attract skilled employees and grow your company team.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}
