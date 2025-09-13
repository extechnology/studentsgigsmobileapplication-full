import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'components/postjobdetailpagedetail.dart';
import 'cubit/posteddetaillist_cubit.dart';
import 'cubit/posteddetaillist_state.dart';
import 'model/model.dart';

class Postjobgigsdetailpage extends StatelessWidget {
  final int id;
  final String jobType;
  final String catecortyjob;


  const Postjobgigsdetailpage({super.key, required this.id, required this.jobType, required this.catecortyjob});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => DashboardCubit()..fetchApplications(jobType: jobType, id:id ),
      child: Scaffold(
        backgroundColor: Color(0xffF9F2ED),
        body: SafeArea(

          child: Padding(
            padding:  EdgeInsets.only(top: height * 0.02,
                bottom: 108.0 + MediaQuery.of(context).padding.bottom,
                left: width * 0.024,right: width * 0.024 ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   width: width * 0.4,  // Approx. 149 on 375px width
                //   height: height * 0.07,
                //   decoration: BoxDecoration(
                //   ),
                //   child:  Image.asset(
                //     "assets/images/logos/image 1.png",
                //     fit: BoxFit.contain,
                //   ),
                //
                // ),
                Padding(
                  padding:  EdgeInsets.only(left:width * 0.03),
                  child: buildFieldTitle("Application For ",width,height,Color(0xff000000)),
                ),
                Padding(
                  padding:  EdgeInsets.only(left:width * 0.03),
                  child: buildFieldTitle("$catecortyjob",width,height,Color(0xff004673)),
                ),
                SizedBox(height: height *0.01,),

                Expanded(
                  child: BlocBuilder<DashboardCubit, DashboardState>(
                    builder: (context, state) {
                      if (state is DashboardLoading) {
                        return const Center(child: SizedBox());
                      } else if (state is DashboardLoaded) {


                        final applications = state.applications;

                        if (applications.isEmpty) {
                          return const Center(child: Text('No applications found.'));
                        }

                        return RefreshIndicator(
                          backgroundColor: Color(0xffFFFFFF),
                          color: Color(0xff000000),
                          onRefresh: () async {
                            context.read<DashboardCubit>().fetchApplications(jobType: jobType, id: id);
                          },
                          child: ListView.builder(
                            itemCount: applications.length,
                            itemBuilder: (context, index) {
                              final item = applications[index];
                              return _buildApplicationCard(item,context,() {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Postjobdetailpagedetail(detailsof: item,),));
                              },);
                            },
                          ),
                        );
                      } else if (state is DashboardError) {
                        return Center(child: Text("Error: ${state.message}"));
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildApplicationCard(Postedpagelist app,BuildContext context, VoidCallback ? onTap) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:  EdgeInsets.only(top: height *0.005),
        child: Card(
          elevation: 4,


          color: Color(0xffFFFFFF),
          margin: EdgeInsets.symmetric(
            horizontal: width * 0.03, // ~12 on 400px wide screen
            vertical: height * 0.001,  // ~8 on 800px tall screen
          ),        child: ListTile(
            subtitle: Row(
              children: [

                Material(
                  elevation: 2,
                  shape:  CircleBorder(), // ✅ CircleBorder is a valid ShapeBorder

                  child: Container(
                      width: width * 0.15,   // 👈 15% of screen width
                      height: height * 0.08, //
                              decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 2,
                    ),
                    ),

                      child:
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: app.employee.profile.profilePic != null
                            ? NetworkImage(app.employee.profile.profilePic!)
                            : null,
                        child: app.employee.profile.profilePic == null
                            ? Icon(Icons.person, size: 30)
                            : null,
                      ),
                  ),
                ),
                SizedBox(width:width * 0.05 ,),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.005,),
                    Padding(
                      padding:  EdgeInsets.only(left: width * 0.05),
                      child: Text(
                      app.employee.name!,
                      style: TextStyle(

                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w600, // SemiBold = 600
                        fontSize: width * 0.027, // ~11 when width is around 400
                        height: 1.2, // 120% line-height
                        letterSpacing: 0, // 0%
                      ),
                        overflow: TextOverflow.ellipsis,

                      ),
                    ),
                    SizedBox(height: height * 0.005,),


                    Row(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_outlined,color: Color(0xffEB8125),size: 11,),
                        SizedBox(width: width * 0.005,),
                        Text(
                          breakTextEveryNChars(app.employee.preferredWorkLocation ?? '', 30),
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w400,
                            fontSize:width * 0.02,
                            height: 1.35,
                            color: Colors.black45,
                            letterSpacing: 0,
                          ),
                          overflow: TextOverflow.ellipsis,

                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.002,),

                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,color: Color(0xffEB8125),size:height * 0.0137,),
                        SizedBox(width: width * 0.005,),

                        Text(
                          "Applied On: ${app.dateApplied.toLocal().toString().split(' ')[0]}",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w400,
                            fontSize:width * 0.02,
                            height: 1.35,
                            color: Colors.black45,
                            letterSpacing: 0,
                          ),
                          overflow: TextOverflow.ellipsis,

                        ),

                      ],
                    ),
                  ],
                ),
              ],
            ),
            trailing:  Icon(Icons.arrow_forward_ios, size:width * 0.035),
          ),
        ),
      ),
    );
  }
}
Widget buildFieldTitle(String title, double width,double height,Color ?color) {
  return Padding(
    padding:  EdgeInsets.symmetric(vertical: height * 0.001),
    child: Text(
      title,
      style: TextStyle(
        color: color,
        fontFamily: 'Sora',
        fontWeight: FontWeight.w600,
        fontSize: width * 0.038,
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
