import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Premiumemployer/premiumemployerpage.dart';
import 'component/homepagedetailpage/homepagedetailpage.dart';
import 'component/searchlistapi/searchlistapi.dart';
import 'cubit2/defaultsearch_cubit.dart';

class Homepageifdatalocation extends StatelessWidget {
  const Homepageifdatalocation({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return SafeArea(
      child: BlocProvider(
        create: (context) =>DefaultsearchCubit()..getserch() ,
  child: BlocBuilder<DefaultsearchCubit, DefaultsearchState>(
  builder: (context, state) {
    final cubit = context.read<DefaultsearchCubit>();
    if (!cubit.isPaginationListenerAttached) {
      cubit.scrollController.addListener(() {
        if (cubit.scrollController.position.pixels >=
            cubit.scrollController.position.maxScrollExtent - 300) {
          cubit.counter++;
          cubit.getserch();
        }
      });
      cubit.isPaginationListenerAttached = true;
    }
    return WillPopScope(
      onWillPop: () async {
        context.read<DefaultsearchCubit>().fetchPlanUsage();
        return true;
      },
      child: Scaffold(
          backgroundColor: Color(0xffF9F2ED),
          body: RefreshIndicator(
            onRefresh: ()async {
              cubit.clearPlanUsageCache();      // optional: clear old cache
              await cubit.fetchPlanUsage();     // 👈 refresh plan usage
              await cubit.getserch();
            },
            child: SingleChildScrollView(
              controller: cubit.scrollController,
              child: Column(
                children: [
                  SizedBox(height: height * 0.02),
                  Row(
                    children: [
                      SizedBox(width: width * 0.08),
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
                    ],
                  ),

                  formField(context: context,onSuffixTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Searchlistapi(),));
                  },
                    topLeft: height * 0.02,
                    topRight: height * 0.02,
                    bottomLeft: height * 0.02,
                    bottomRight: height * 0.02,
                  ),

                  SizedBox(height: height * 0.02),
                  fieldTitle(title: "Suggested For You", width: width),
                  SizedBox(height: height * 0.02),

                              cubit.imagesData.isNotEmpty ?

                              Padding(
                                padding:  EdgeInsets.symmetric(horizontal:width * 0.05 , ),
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, // two items per row like your image
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 12,
                                    childAspectRatio: 3 / 4, // Adjust to make cards look good
                                  ),
                                  itemCount: cubit.imagesData.length,
                                  itemBuilder: (context, index) {
                                    final item = cubit.imagesData[index];
                                    return GestureDetector(
                                      onTap: () async {
                                        final usageData = await cubit.fetchPlanUsage();
                                        final usage = usageData?['usage'];
                                        final profileAccess = usage?['profile_access'] ?? false;

                                        if (!profileAccess) {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(builder: (context) => Premiumemployerpage()))
                                              .then((_) {
                                            cubit.clearPlanUsageCache();
                                            cubit.fetchPlanUsage();
                                          });
                                          return;
                                        }

                                        final employeeId = item["user"]?.toString();
                                        if (employeeId == null) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Invalid employee ID")),
                                          );
                                          return;
                                        }
                                        final userId = item["user"];
                                        if (userId != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => Homepagedetailpage(id: userId),
                                            ),
                                          );
                                        }

                                        Future.microtask(() {
                                          cubit.postVisitedCount(employeeId);
                                        });
                                      },
                                      child: customBox(
                                        imageurl: "${item["profile"] ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGEZghB-stFaphAohNqDAhEaXOWQJ9XvHKJw&s"}",
                                        name: "${item["name"]}",
                                        carrier: '${item["job_title"]}',
                                        location: '${item["preferred_work_location"]}',
                                        context: context,
                                      ),
                                    );
                                  },
                                ),
                              )
                     :SizedBox()






                ],
              ),
            ),
          ),
        ),
    );
  },
),
),
    );
  }
}
Widget formField({
  required BuildContext context,
  VoidCallback? onSuffixTap,
  double ? topLeft,
  double ? topRight,
  double ? bottomLeft,
  double ? bottomRight,


}) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  return InkWell(
    onTap: onSuffixTap,
    child: Container(
      width: width * 0.9,
      height: height * 0.065,
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xff004673),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular( topLeft ?? 0),
          topRight: Radius.circular(topRight ?? 0),
          bottomLeft: Radius.circular(bottomLeft ?? 0),
          bottomRight: Radius.circular(bottomRight ?? 0),
        ),      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
      ),

    ),
  );
}
Widget fieldTitle({
  required String title,
  required double width,
}) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 18.0),
        child: Text(
          title,
          style: TextStyle(
            color: Color(0xff3F414E),
            fontFamily: 'Sora',
            fontWeight: FontWeight.w600,
            fontSize: width * 0.05,
          ),
        ),
      ),
    ],
  );
}

Widget customBox({
  String ? imageurl,
  required String name,
  required String carrier,
  required String location,
  required BuildContext context,
  VoidCallback ? onSuffixTap,


}) {
  final size = MediaQuery.of(context).size;
  final width = size.width;
  final height = size.height;

  return GestureDetector(
    onTap: onSuffixTap,
    child: Container(
      width: width * 0.44,
      height: height * 0.12,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(height * 0.016),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: height * 0.028),
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage("${imageurl}"),
          ),
          SizedBox(height: height * 0.012),
          Text(
            name,
            style: TextStyle(
              fontFamily: 'Sora',
              fontWeight: FontWeight.w600,
              fontSize: height * 0.0135,
              height: 1.2,
              letterSpacing: 0,
              color: Colors.black,
            ),
          ),
          SizedBox(height: height * 0.01),
          Text(
            carrier,
            style: TextStyle(
              fontFamily: 'Sora',
              fontWeight: FontWeight.w400,
              fontSize: height * 0.0123,
              height: 1.2,
              letterSpacing: 0,
              color: Colors.black,
            ),
          ),
          SizedBox(height: height * 0.01),
          Text(
            location,
            style: TextStyle(
              fontFamily: 'Sora',
              fontWeight: FontWeight.w400,
              fontSize: height * 0.0086,
              height: 1.35,
              letterSpacing: 0,
              color: Colors.black,
            ),
          ),
          SizedBox(height: height * 0.01),
          Container(
            width: width * 0.344,
            height: height * 0.022,
            decoration: BoxDecoration(
              color: Color(0xffEB8125),
              borderRadius: BorderRadius.circular(height * 0.011),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: height * 0.004,
                  offset: Offset(0, height * 0.002),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "View Profile",
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w600,
                  fontSize: height * 0.0098,
                  height: 1.5,
                  letterSpacing: 0,
                  color: Color(0xffFFFFFF),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}