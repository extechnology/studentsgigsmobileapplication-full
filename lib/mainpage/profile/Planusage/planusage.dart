import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'cubit/planusage_cubit.dart';


class Planusagenew extends StatelessWidget {
  const Planusagenew({super.key});
  String formatPercent(double value) {
    // Check if value is a whole number like 14.0
    if (value % 1 == 0) {
      return "${value.toInt()}%"; // No decimal part, show as 14%
    } else {
      return "${value.toStringAsFixed(0)}%"; // Has decimal, show as 14.5%
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      backgroundColor: Color(0xffF9F2ED),
      body: BlocProvider(
      create: (context) => PlanusageCubit(),
      child: BlocBuilder<PlanusageCubit, PlanusageState>(
        builder: (context, state) {

          if (state is PlanusageIoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is Planusageerror) {
            return Center(child: Text(state.message));
          } else if (state is PlanusageIoaded) {
            final plan = state.data;
            final created = DateFormat('dd MMM yyyy').format(plan.planCreatedDate);
            final expiry = DateFormat('dd MMM yyyy').format(plan.planExpiryDate);
            final days = plan.planExpiryDate.difference(plan.planCreatedDate).inDays;
            final remaining = plan.planExpiryDate.difference(DateTime.now()).inDays;

              int profileaccess = 0;
              double profileaccessPercent = 0;
              int profileaccess2 = 0;
              double profileaccess2Percent = 0;

              if (plan.planFeatures.isNotEmpty) {
                final limitStr = plan.planFeatures[0].limit.toString();
                final usedStr = plan.planFeatures[0].used.toString();

                final limit = int.tryParse(limitStr);
                final used = int.tryParse(usedStr);

                if (limit != null && used != null && limit > 0) {
                  profileaccess = limit - used;
                  profileaccessPercent = (used / limit) * 100;
                }

                print("Feature 1 → Remaining: $profileaccess, Used: ${profileaccessPercent.toStringAsFixed(1)}%");
              }

              if (plan.planFeatures.isNotEmpty) {
                final limitStr = plan.planFeatures[1].limit.toString();
                final usedStr = plan.planFeatures[1].used.toString();

                final limit = int.tryParse(limitStr);
                final used = int.tryParse(usedStr);

                if (limit != null && used != null && limit > 0) {
                  profileaccess2 = limit - used;
                  profileaccess2Percent = (used / limit) * 100;
                }

                print("Feature 2 → Remaining: $profileaccess2, Used: ${profileaccess2Percent.toStringAsFixed(1)}%");
              }
            return SafeArea(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: width *0.05),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.03),
                      SizedBox(height: height * 0.005),

                      Padding(
                        padding:  EdgeInsets.only(left: width *0.05),
                        child: Text(
                          "Plan Usage",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600, // 600 weight
                            fontSize: 19,
                            height: 32 / 20, // Flutter's height is a multiple of font size
                            letterSpacing: 0,
                            color: Color(0xff3F414E), // Optional
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.015),

                      Container(


                        width: width * 0.9,
                        decoration: BoxDecoration(
                          color: Color(0x0DEB8125),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.black12, // 👈 border color
                            width: width * 0.002, // 👈 Responsive border width (~0.8px on 400px screen)
                          ),

                        ),
                        child: Padding(
                          padding:  EdgeInsets.only(right: width *0.05,left: width * 0.04,top: height * 0.04,bottom: height * 0.04),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Container(
                                width: width * 0.42,
                                height: height * 0.05,
                                decoration: BoxDecoration(
                                  color: Color(0xffEB8125), // 5% orange background
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x40000000), // 25% black = hex 40 alpha
                                      offset: Offset(0, 4),
                                      blurRadius: 4,
                                      spreadRadius: 0, // softer downward shadow
                                    ),
                                  ],
                                ),

                                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.emoji_events, color: Colors.white),
                                    SizedBox(width:width * 0.025,), // gap
                                    Text(
                                      "${plan.plan}",
                                      style: TextStyle(
                                        fontFamily: 'Sora',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Color(0xffFFFFFF),
                                      ),
                                    ),
                                    SizedBox(width:width * 0.025,), // gap

                                  ],
                                ),
                              ),
                              SizedBox(height: height * 0.02),

                              Row(
                                children: [
                                  Text(
                                    "Current Plan",
                                    style: TextStyle(
                                      fontFamily: 'Sora',
                                      fontWeight: FontWeight.w600, // 600 weight
                                      fontSize: 20,
                                      height: 32 / 20, // Flutter's height is a multiple of font size
                                      letterSpacing: 0,
                                      color: Color(0xff3F414E), // Optional
                                    ),
                                  ),
                                  SizedBox(width: width *0.13,),
                                  Material(
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(15),

                                    child: Container(
                                      width: width * 0.35,
                                      height: height * 0.05,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Color(0x1C30AE3F),
                                        border: Border.all(
                                          color: Color(0xFF0C792F), // border color: #0C792F
                                          width: 1, // adjust thickness as needed
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.access_time,color:Color(0xff479F51) ,),
                                          SizedBox(width: width * 0.01), // gap
                                          Text(
                                            "$remaining days remaining",
                                            style: TextStyle(
                                              fontFamily: 'Sora',
                                              fontWeight: FontWeight.w400, // Regular
                                              fontSize: 11,
                                              height: 1.5, // 150% line-height
                                              letterSpacing: 0, // 0% letter spacing
                                              color: Color(0xFF0C792F), // border color: #0C792F
                                            ),
                                          ),
                                          SizedBox(width: 5), // gap


                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: height * 0.02),

                              Row(
                                children: [
                                  buildbox(color: Color(0xff000000), text: 'Profile Access'),
                                  SizedBox(width: width *0.28,),
                                Text("${plan.planFeatures[0].used }of ${plan.planFeatures[0].limit} used",style: TextStyle(color:Color(0xffEB4335) ),)
                                ],
                              ),
                              SizedBox(height: height * 0.01,),

                              buildcontaner(text: 'Profile Access Used', icons: Icon(Icons.bolt,color: Color(0xffEB8125),),textnun: plan.planFeatures[0].used.toString(), context: context),
                              SizedBox(height: height * 0.01,),
                              buildcontaner(text: 'Profile Access Left', icons: Icon(Icons.add,color: Color(0xffEB8125),),textnun:" ${profileaccess}", context: context),

                              SizedBox(height: height * 0.01,),
                              buildcontaner(text: 'Used', icons: Icon(Icons.settings,color: Color(0xffEB8125),),textnun:" ${formatPercent(profileaccessPercent)}", context: context),

                              SizedBox(height: height * 0.02,),

                              Center(
                                child: Container(
                                  width: width* 0.9,
                                  height: 1, // or more, like 5.0 or 10.0
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 0.2,
                                      color: Color(0xffC4A78D),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  buildbox(color: Color(0xff000000), text: 'Job Posting'),
                                  SizedBox(width: width *0.34,),
                                  Text("${plan.planFeatures[1].used }of ${plan.planFeatures[1].limit} used",style: TextStyle(color:Color(0xffEB4335) ),)
                                ],
                              ),
                              SizedBox(height: height * 0.01,),
                              buildcontaner(text: 'Job Posting Used', icons: Icon(Icons.bolt,color: Color(0xffEB8125),),textnun:"${plan.planFeatures[1].used}", context: context ),

                              SizedBox(height: height * 0.01,),
                              buildcontaner(text: 'Job Posting Left', icons: Icon(Icons.add,color: Color(0xffEB8125),),textnun: "${profileaccess2}", context: context),

                              SizedBox(height: height * 0.01,),
                              buildcontaner(text: 'Used', icons: Icon(Icons.settings,color: Color(0xffEB8125),),textnun: "${formatPercent(profileaccess2Percent)}", context: context),

                              SizedBox(height: height * 0.02,),
                              Container(
                                  width: double.infinity,
                                  height: 1, // or more, like 5.0 or 10.0
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 0.2,
                                      color: Color(0xffC4A78D),
                                    ),
                                  ),
                                ),



                              SizedBox(height: height * 0.02,),
                              buildcontaner(text: 'Plan Started', icons: Icon(Icons.calendar_today,color: Color(0xffFB4A59),),textnun: "$created", context: context),
                              SizedBox(height: height * 0.01,),
                              buildcontaner(text: 'Plan Expires', icons: Icon(Icons.calendar_today,color: Color(0xffFB4A59),),textnun: "$expiry", context: context),

                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.1,)



                    ],
                  ),
                ),
              ),
            );
          }
          return Container(); // initial state
        },
      ),
    ),
    );
  }
}
Widget buildbox({ required String text,required Color color, double ? fontsize}){
  return  Text(
    text,
    style: TextStyle(
      fontFamily: 'Sora',
      fontWeight: FontWeight.w400,
      fontSize: fontsize ?? 17,
      height: 32 / 17, // Line height of 32px for 17px font size
      letterSpacing: 0,
      color: color,
    ),
  );

}
Widget buildcontaner({ required BuildContext context ,required String text,required Icon icons,String ? textnun}){
  final size = MediaQuery.of(context).size;

  final width = size.width;
  final height = size.height;
  return Container(
  width: width * 0.9,
  height: height * 0.1,
  decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(11),
      color: Color(0xffFFFFFF),
    boxShadow: [
      BoxShadow(
        color: Color(0x40000000), // 25% black = hex 40 alpha
        offset: Offset(0, 4),
        blurRadius: 4,
        spreadRadius: 0, // softer downward shadow
      ),
    ],


  ),
  child: Row(crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(width: width * 0.05,),
      Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(6),

        child: Container(
          width: width * 0.09,
          height:  width * 0.09,
          decoration: BoxDecoration(
              color: Color(0x1AEb8125),
              borderRadius: BorderRadius.circular(6)
          ),
          child: Center(
            child: icons,
          ),
        ),
      ),
      SizedBox(width: width * 0.04,),

      Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildbox(text: text, color: Color(0xff3F414E),fontsize: 15),
            Text(
              textnun ?? "" ,
              style: TextStyle(
                fontFamily: 'Sora',
                fontWeight: FontWeight.w600, // 600 weight
                fontSize: 15,
                height: 32 / 15, // line height of 32px for 15px font size ≈ 2.13
                letterSpacing: 0,
                color: Colors.black, // optional
              ),
            )

          ],
        ),
      )
    ],
  ),
);


}
