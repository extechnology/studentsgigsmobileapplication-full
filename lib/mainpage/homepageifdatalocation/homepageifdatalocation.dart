import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../Premiumemployer/premiumemployerpage.dart';
import '../widgets/neterror.dart';
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
                appBar: AppBar(

                  foregroundColor: Color(0xffF9F2ED),
                  surfaceTintColor: Color(0xffF9F2ED) ,
                  backgroundColor: Color(0xffF9F2ED),
                  actions: [
                    Row(
                      children: [

                        SizedBox(width: width * 0.02),
                        Container(
                          width: width * 0.4,
                          height: height * 0.4,

                          decoration: BoxDecoration(
                          ),
                          child:  Image.asset(
                            "assets/images/logos/image 1.png",
                            fit: BoxFit.contain,
                          ),

                        ),
                        SizedBox(width: width * 0.58),


                      ],
                    ),

                  ],

                ),
                body: RefreshIndicator(
                  backgroundColor: Color(0xffFFFFFF),
                  color: Color(0xff000000),
                  onRefresh: ()async {
                    cubit.clearPlanUsageCache();      // optional: clear old cache
                    await cubit.fetchPlanUsage();
                    // cubit.imagesData.clear();
                    // cubit.counter = 1;
                    // 👈 refresh plan usage
                    await cubit.getserch(isRefresh: true);
                  },
                  child: SingleChildScrollView(

                    controller: cubit.scrollController,
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.01),

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
                        cubit.isConnected?

                        cubit.imagesData.isNotEmpty ?

                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal:width * 0.05 , ),
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // two items per row like your image
                              mainAxisSpacing: height * 0.02,
                              crossAxisSpacing: width * 0.04,
                              childAspectRatio: 0.71, // allow taller cards
                            ),
                            itemCount: cubit.imagesData.length + (cubit.isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index < cubit.imagesData.length) {
                                final item = cubit.imagesData[index];
                                return GestureDetector(
                                  onTap: () async {
                                    final usageData = await cubit
                                        .fetchPlanUsage();
                                    final usage = usageData?['usage'];
                                    final profileAccess = usage?['profile_access'] ??
                                        false;

                                    if (!profileAccess) {
                                      final shouldNavigate = await showDialog<
                                          bool>(
                                        context: context,
                                        builder: (context) =>
                                            AlertDialog(
                                              title: const Text(
                                                  "Premium Required"),
                                              content: const Text(
                                                  "You need a premium plan to view this profile. Do you want to upgrade now?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child: const Text(
                                                      "Cancel"),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  child: const Text(
                                                      "Upgrade"),
                                                ),
                                              ],
                                            ),
                                      );

                                      if (shouldNavigate == true) {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                            builder: (context) =>
                                                Premiumemployerpage()))
                                            .then((_) {
                                          cubit.clearPlanUsageCache();
                                          cubit.fetchPlanUsage();
                                        });
                                      }

                                      return;
                                    }

                                    final employeeId = item["user"]
                                        ?.toString();
                                    if (employeeId == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(content: Text(
                                            "Invalid employee ID")),
                                      );
                                      return;
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Homepagedetailpage(
                                            id: item["user"]),
                                      ),
                                    );

                                    Future.microtask(() {
                                      cubit.postVisitedCount(employeeId);
                                    });
                                  },
                                  child: customBox(
                                    imageurl: "${item["profile"] ?? ""}",
                                    name: "${item["name"]}",
                                    carrier: "${item["job_title"]}",
                                    location: "${item["preferred_work_location"]}",
                                    context: context,
                                  ),
                                );


                                // return GestureDetector(
                                //   onTap: () async {
                                //     final usageData = await cubit.fetchPlanUsage();
                                //     final usage = usageData?['usage'];
                                //     final profileAccess = usage?['profile_access'] ?? false;
                                //
                                //     if (!profileAccess) {
                                //       Navigator.of(context)
                                //           .push(MaterialPageRoute(builder: (context) => Premiumemployerpage()))
                                //           .then((_) {
                                //         cubit.clearPlanUsageCache();
                                //         cubit.fetchPlanUsage();
                                //       });
                                //       return;
                                //     }
                                //
                                //     final employeeId = item["user"]?.toString();
                                //     if (employeeId == null) {
                                //       ScaffoldMessenger.of(context).showSnackBar(
                                //         SnackBar(content: Text("Invalid employee ID")),
                                //       );
                                //       return;
                                //     }
                                //     final userId = item["user"];
                                //     if (userId != null) {
                                //       Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //           builder: (_) => Homepagedetailpage(id: userId),
                                //         ),
                                //       );
                                //     }
                                //
                                //     Future.microtask(() {
                                //       cubit.postVisitedCount(employeeId);
                                //     });
                                //   },
                                //   child: customBox(
                                //     imageurl: "${item["profile"] ?? ""}",
                                //     name: "${item["name"]}",
                                //     carrier: '${item["job_title"]}',
                                //     location: '${item["preferred_work_location"]}',
                                //     context: context,
                                //   ),
                                // );
                              } else {
                                // 👇 Bottom loading widget
                                return customBoxShimmer(context); // shimmer card for loading
                              }

                            },
                          ),
                        )
                            :CircularProgressIndicator()
                            : const NoInternetWidget()

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
    child:
    Material(
      elevation: 2,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(  height * 0.02,),
        topRight: Radius.circular( height * 0.02,),
        bottomLeft: Radius.circular( height * 0.02,),
        bottomRight: Radius.circular( height * 0.02,),
      ),

      child: Container(
          width: width * 0.9,
          height: height * 0.065,
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          decoration: BoxDecoration(
            color: const Color(0xffF9F2ED),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular( topLeft ?? 0),
              topRight: Radius.circular(topRight ?? 0),
              bottomLeft: Radius.circular(bottomLeft ?? 0),
              bottomRight: Radius.circular(bottomRight ?? 0),
            ),
            border: Border.all(
              color: Colors.black12, // 👈 border color
              width: width * 0.002, // 👈 Responsive border width (~0.8px on 400px screen)
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: height * 0.01,
                offset: Offset(0, height * 0.004),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                size: width * 0.06,
                color: Colors.black, // ✅ White color
              ),
              SizedBox(width: width * 0.02,),
              Text(
                "Search",
                style: TextStyle(
                  color: Colors.black, // ✅ White color
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w600, // 600 = SemiBold
                  fontSize: width * 0.04, // 16 when width is 400
                  height: 1.5, // 150% line-height
                  letterSpacing: 0.0,
                ),
              ),
            ],
          )

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
        padding: EdgeInsets.only(left: width * 0.05),
        child: Text(

          title,
          style: TextStyle(
            color: Color(0xff3F414E),
            fontFamily: 'Sora',
            fontWeight: FontWeight.w600,
            fontSize: width * 0.041,
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
    child:  Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(height * 0.016),

      child: Container(
        width: width * 0.44,
        constraints: BoxConstraints(
          minHeight: height * 0.12, // Minimum height
        ),      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(height * 0.016),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: height * 0.006,

          ),
        ],
      ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 👈 allow vertical growth
          children: [
            SizedBox(height: height * 0.028),
            Material(
              elevation: 2 ,
              shape:  CircleBorder(),

              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.grey[300],
                backgroundImage: (imageurl != null && imageurl.isNotEmpty)
                    ? NetworkImage(imageurl)
                    : null,
                child: (imageurl == null || imageurl.isEmpty)
                    ? const Icon(Icons.person, size: 30, color: Colors.grey)
                    : null,
              ),
            ),

            SizedBox(height: height * 0.012),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,  // 4% of screen width
              ),
              child: Text(
                name,
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w600,
                  fontSize: height * 0.0135,
                  height: 1.2,
                  letterSpacing: 0,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: height * 0.01),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04,  // 4% of screen width
                  vertical: height * 0.001,   // 1% of screen height
                ),
                child: Text(
                  carrier,
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.w400,
                    fontSize: height * 0.0123,
                    height: 1.2,
                    letterSpacing: 0,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,

                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: height * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,  // 4% of screen width
                vertical: height * 0.001,   // 1% of screen height
              ),              child: Text(
              location,
              style: TextStyle(
                fontFamily: 'Sora',
                fontWeight: FontWeight.w400,
                fontSize: height * 0.0086,
                height: 1.35,
                letterSpacing: 0,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,

            ),
            ),
            SizedBox(height: height * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,  // 4% of screen width
                vertical: height * 0.01,   // 1% of screen height
              ),              child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(height * 0.011),

              child: Container(
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
                    textAlign: TextAlign.center, // 🔑 Align text within the Text widget

                  ),
                ),
              ),
            ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget customBoxShimmer(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final width = size.width;
  final height = size.height;

  return Material(
    elevation: 2,
    borderRadius: BorderRadius.circular(height * 0.016),
    child: Container(
      width: width * 0.44,
      constraints: BoxConstraints(minHeight: height * 0.12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(height * 0.016),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: height * 0.006,
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: height * 0.028),
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.grey.shade300,
            ),
            SizedBox(height: height * 0.012),
            Container(
              width: width * 0.3,
              height: height * 0.015,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: height * 0.01),
            Container(
              width: width * 0.25,
              height: height * 0.014,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: height * 0.01),
            Container(
              width: width * 0.2,
              height: height * 0.012,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: height * 0.02),
            Container(
              width: width * 0.344,
              height: height * 0.022,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(height * 0.011),
              ),
            ),
            SizedBox(height: height * 0.01),
          ],
        ),
      ),
    ),
  );
}
