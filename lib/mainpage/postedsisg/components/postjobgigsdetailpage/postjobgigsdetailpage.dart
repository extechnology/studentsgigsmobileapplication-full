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
            padding:  EdgeInsets.only(top: height * 0.05,bottom:height * 0.05,left: width * 0.05,right: width * 0.05 ),
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
                buildFieldTitle("Application For $catecortyjob",width),

                Expanded(
                  child: BlocBuilder<DashboardCubit, DashboardState>(
                    builder: (context, state) {
                      if (state is DashboardLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is DashboardLoaded) {


                        final applications = state.applications;

                        if (applications.isEmpty) {
                          return const Center(child: Text('No applications found.'));
                        }

                        return ListView.builder(
                          itemCount: applications.length,
                          itemBuilder: (context, index) {
                            final item = applications[index];
                            return _buildApplicationCard(item,context,() {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Postjobdetailpagedetail(detailsof: item,),));
                            },);
                          },
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
      child: Card(
        color: Color(0xffFFFFFF),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: ListTile(
          subtitle: Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(app.employee.profile.profilePic ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKw7CSv4kiYTGhtTwYqc6mO9uHRB9cKndI2A&s"),radius: 30,),
              SizedBox(width:width * 0.05 ,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.005,),
                  Padding(
                    padding:  EdgeInsets.only(left: width * 0.05),
                    child: Text(
                    app.employee.name,
                    style: TextStyle(

                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w600, // SemiBold = 600
                      fontSize: 11, // 11px
                      height: 1.2, // 120% line-height
                      letterSpacing: 0, // 0%
                    ),
                                    ),
                  ),
                  SizedBox(height: height * 0.005,),


                  Row(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_outlined,color: Color(0xffEB8125),size: 11,),
                      Text(
                        breakTextEveryNChars(app.employee.preferredWorkLocation ?? '', 30),
                        style: TextStyle(
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w400,
                          fontSize: 8,
                          height: 1.35,
                          color: Colors.black45,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.002,),

                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,color: Color(0xffEB8125),size: 11,),

                      Text(
                        "Applied On: ${app.dateApplied.toLocal().toString().split(' ')[0]}",
                        style: TextStyle(
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w400,
                          fontSize: 8,
                          height: 1.35,
                          color: Colors.black45,
                          letterSpacing: 0,
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        ),
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
String breakTextEveryNChars(String text, int chunkSize) {
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i += chunkSize) {
    buffer.writeln(text.substring(i, i + chunkSize > text.length ? text.length : i + chunkSize));
  }
  return buffer.toString();
}
