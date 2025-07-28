import 'package:anjalim/mainpage/homepageifdatalocation/component/homepagetextformdatahave/cubit/homepagetextformdatahave_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Premiumemployer/premiumemployerpage.dart';
import '../../../widgets/typeforlocation.dart';
import '../../../widgets/typehyder.dart';
import '../homepagedetailpage/homepagedetailpage.dart';

class Homepagetextformdatahave extends StatelessWidget {
  final String searchText;

  const Homepagetextformdatahave({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return BlocProvider(
  create: (context) => HomepagetextformdatahaveCubit(
    initialCategory: searchText,

  ),
  child: BlocBuilder<HomepagetextformdatahaveCubit, HomepagetextformdatahaveState>(
  builder: (context, state) {
    final cubit = context.read<HomepagetextformdatahaveCubit>();
    if (!cubit.isPaginationListenerAttached) {
      cubit.scrollControllerofsearch.addListener(() {
        final state = cubit.state;

        // Avoid multiple triggers while loading
        if (state is HomepagetextformdatahaveIoading) return;

        // Scroll trigger threshold
        if (cubit.scrollControllerofsearch.position.pixels >=
            cubit.scrollControllerofsearch.position.maxScrollExtent - 300) {

          // Check if more pages are available
          if (state is HomepagetextformdatahaveIoaded) {
            if (cubit.counter >= state.data.totalPages) {
              print("🔚 No more pages to fetch.");
              return; // Stop fetching more pages
            }

            cubit.counter++;
            cubit.fetchEmployees(
              category: cubit.categoryController.text,
              location: cubit.locationController.text,
            );
          }
        }
      });

      cubit.isPaginationListenerAttached = true;
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF9F2ED),
        body: SingleChildScrollView(
          controller: cubit.scrollControllerofsearch,
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: width * 0.06),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: height * 0.03),
                // Container(
                //   width: width * 0.397,   // ~149 / 375
                //   height: height * 0.07,  // ~57 / 812
                //
                //   decoration: BoxDecoration(
                //   ),
                //   child:  Image.asset(
                //     "assets/images/logos/image 1.png",
                //     fit: BoxFit.contain,
                //   ),
                // ),


            Container(
              width: width * 0.9,
              height: height * 0.065,
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              decoration: BoxDecoration(
                color: const Color(0xffF9F2ED),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular( height * 0.0185),
                  topRight: Radius.circular(  height * 0.0185),
                  bottomLeft: Radius.circular(  0),
                  bottomRight: Radius.circular(  0),
                ),
                border: Border(
                  top: BorderSide(
                    color: Colors.black12,
                    width: width * 0.002, // ✅ Responsive top border
                  ),
                  left: BorderSide(
                    color: Colors.black12,
                    width: width * 0.002, // ✅ Responsive left border
                  ),
                  right: BorderSide(
                    color: Colors.black12,
                    width: width * 0.002, // ✅ Responsive left border
                  ),
                  bottom: BorderSide(
                    color: Colors.black12,
                    width: width * 0.002, // ✅ Responsive left border
                  ),
                  // right and bottom not included = no border
                ),


                boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.09),
                  blurRadius: height * 0.005,        // 4 / 812 ≈ 0.0049
                  offset: Offset(0, height * 0.002), // 2 / 812 ≈ 0.0024

                ),
              ],
              ),
              child:
              CustomTypeAhead<String>(

                  controller: cubit.compensationController,
                  focusNode: cubit.compasationFocusNode,
                  suggestionsCallback: (query) async {
                    return cubit.payStructures
                        .where((item) =>
                        item.toLowerCase().contains(query.toLowerCase()))
                        .toList();
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(title: Text(suggestion,));
                  },
                  onSuggestionSelected: (suggestion) {
                    cubit.compensationController.text = suggestion;
                  },
                textStyle: TextStyle(color: Colors.black), // 👈 Make typed text white

                  decoration:  InputDecoration(
                    hintText: "Select Your Salary Type…",
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.9), // Light grayish white like your image
                      fontSize: height * 0.0197, // Because 16 / 812 ≈ 0.0197
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.black,), // 👈 Prefix Icon

                    border: InputBorder.none,
                  ),

              ),
            ) ,
            Container(
              width: width * 0.9,
              height: height * 0.065,
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              decoration: BoxDecoration(
                color: const Color(0xffF9F2ED),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(   0),
                  topRight: Radius.circular(  0),
                  bottomLeft: Radius.circular(  0),
                  bottomRight: Radius.circular(  0),
                ),
                border: Border(
                  left: BorderSide(
                    color: Colors.black12,
                    width: width * 0.002, // ✅ Responsive left border
                  ),
                  right: BorderSide(
                    color: Colors.black12,
                    width: width * 0.002, // ✅ Responsive left border
                  ),
                  // right and bottom not included = no border
                ),

                boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: height * 0.0049, // 4 / 812 ≈ 0.0049
                  offset: Offset(0, height * 0.0025), // 2 / 812 ≈ 0.0025

                ),
              ],
              ),
              child:CustomTypeAheadWithEmptyCheck<String>(
                  controller: cubit.locationController,
                  focusNode: cubit.locationFocusNode,
                  onTap: () {
                    cubit.selectedLocation = null;
                  },
                  onChanged: (val) {
                    cubit.onLocationChanged(val);
                  },
                  suggestionsCallback: (query) async {
                    if (query.isEmpty) {
                      return [];
                    }
                    if (query.length >= 3) {
                      return await cubit.getLocationSuggestions(query);
                    } else {
                      return [];
                    }
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(title: Text(suggestion));
                  },
                  onSuggestionSelected: (suggestion) {
                    cubit.shouldListenToLocationChanges = false;

                    cubit.locationController.text = suggestion;
                    cubit.selectedLocation = suggestion;

                    FocusScope.of(context).unfocus();

                    final selected = cubit.locationdata.firstWhere(
                          (e) => e['label'] == suggestion,
                      orElse: () => {'id': ''},
                    );
                    final locationId = selected['id'];
                    print("Selected Location ID: $locationId");

                    Future.delayed(const Duration(milliseconds: 300), () {
                      cubit.shouldListenToLocationChanges = true;
                    });
                  },
                textStyle: TextStyle(color: Colors.black), // 👈 Make typed text white

                decoration:  InputDecoration(

                  prefixIcon: Icon(Icons.location_on, color: Colors.black,), // 👈 Prefix Icon

                    border: InputBorder.none,
                  hintText: "Search a City…",
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.9), // Light grayish white like your image
                    fontSize: height * 0.0197, // 16 ÷ 812 ≈ 0.0197
                    fontWeight: FontWeight.w400,
                  ),
                ),
                ),

            ),
            Container(
              width: width * 0.9,
              height: height * 0.065,
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              decoration: BoxDecoration(
                color: const Color(0xffF9F2ED),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(   0),
                  topRight: Radius.circular(  0),
                  bottomLeft: Radius.circular(height * 0.0185),
                  bottomRight: Radius.circular(height * 0.0185),

                ),
                border: Border(
                  top: BorderSide(
                    color: Colors.black12,
                    width: width * 0.002, // ✅ Responsive top border
                  ),
                  left: BorderSide(
                    color: Colors.black12,
                    width: width * 0.002, // ✅ Responsive left border
                  ),
                  right: BorderSide(
                    color: Colors.black12,
                    width: width * 0.002, // ✅ Responsive left border
                  ),
                  bottom: BorderSide(
                    color: Colors.black12,
                    width: width * 0.002, // ✅ Responsive left border
                  ),
                  // right and bottom not included = no border
                ),
                boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: height * 0.0049, // 4 / 812 ≈ 0.0049
                  offset: Offset(0, height * 0.0025), // 2 / 812 ≈ 0.0025

                ),
              ],
              ),
              child: CustomTypeAhead<String>(
                  controller: cubit.categoryController,
                  focusNode: cubit.categoryFocusNode,
                  suggestionsCallback: (query) async {
                    if (query.isEmpty) {
                      return cubit.imagesData.map((e) =>
                      e["label"] ?? "").toSet().cast<String>().toList();
                    }
                    return cubit.imagesData
                        .map((e) => e["label"] ?? "")
                        .toSet()
                        .where((item) =>
                        item.toLowerCase().contains(query.toLowerCase()))
                        .cast<String>()
                        .toList();
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(title: Text(suggestion));
                  },

                  onSuggestionSelected: (suggestion) {
                    cubit.categoryController.text = suggestion;
                    cubit.updateJobTitlesForCategory(suggestion);
                  },
                textStyle: TextStyle(color: Colors.black), // 👈 Make typed text white

                decoration: InputDecoration(
                  hintText: "Search a Category or Job Title...",
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.0), // Light grayish white like your image
                    fontSize: height * 0.0197, // Because 16 / 812 ≈ 0.0197
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.black,), // 👈 Prefix Icon

                  // hintText: "Select Job Category",
                    border: InputBorder.none,
                  ),
                ),


            ),
                SizedBox(height: height * 0.01,),
                InkWell(onTap: () {
                  cubit.counter = 1 ;
                  cubit.allEmployees.clear();

                  cubit.fetchEmployees(
                    category: cubit.categoryController.text,
                    location: cubit.locationController.text,
                  );
                },

                  child: Center(
                    child: Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(height * 0.0185), // 15 / 812 ≈ 0.0185

                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffEB8125),
                          borderRadius: BorderRadius.circular(height * 0.0185), // 15 / 812 ≈ 0.0185

                        ),
                        height: height * 0.0616,
                        width: width * 0.999 ,

                        child: Center(child: Text("Search",style: TextStyle(color: Color(0xffFFFFFF)),)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.01,),

                cubit.allEmployees.isNotEmpty ?
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal:width * 0.01 , ),
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // two items per row like your image
                      mainAxisSpacing: height * 0.015, // ≈ 12 if height ≈ 800
                      crossAxisSpacing: width * 0.032, // ≈ 12 if width ≈ 375
                      childAspectRatio: 3 / 4, // Adjust to make cards look good
                    ),
                    itemCount: cubit.allEmployees.length,
                    itemBuilder: (context, index) {
                      final item = cubit.allEmployees[index];
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

                          final employeeId = item.user.toString();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  Homepagedetailpage(id: item.user),
                            ),
                          );

                          Future.microtask(() {
                            cubit.postVisitedCount(employeeId);
                          });
                        },
                        child: customBox(
                          imageurl: item.profile.profilePic ??
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGEZghB-stFaphAohNqDAhEaXOWQJ9XvHKJw&s",
                          name: item.name!,
                          carrier: item.jobTitle!,
                          location: item.preferredWorkLocation!,
                          context: context,
                        ),
                      );
                    },
                  ),
                )
                    : Center(
                      child: Text(
                                        "No Employee Found....",
                                        style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                      letterSpacing: 0.5,
                                        ),
                                      ),
                    ),

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
    child: Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(height * 0.016),

      child: Container(
        width: width * 0.44,
        height: height * 0.12,
        decoration: BoxDecoration(
          color: Color(0xffF9F2ED),
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
              radius:height * 0.05,
              backgroundImage: NetworkImage("${imageurl}"),
            ),
            SizedBox(height: height * 0.012),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,  // 4% of screen width
                vertical: height * 0.001,   // 1% of screen height
              ),              child: Text(
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
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,  // 4% of screen width
                vertical: height * 0.001,   // 1% of screen height
              ),             child: Text(
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

              ),
            ),
            SizedBox(height: height * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,  // 4% of screen width
                vertical: height * 0.001,   // 1% of screen height
              ),
              child: Text(
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
    ),
  );
}