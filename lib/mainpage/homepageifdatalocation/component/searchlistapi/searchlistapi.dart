import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../dashborad/dashborad.dart';
import '../homepagetextformdatahave/cubit/homepagetextformdatahave_cubit.dart';
import '../homepagetextformdatahave/homepagetextformdatahave.dart';
import 'cubit/searchclass_cubit.dart';

class Searchlistapi extends StatelessWidget {
  const Searchlistapi({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return MultiBlocProvider(
  providers: [
    BlocProvider(
      create: (context) => SearchclassCubit()..getFunction(),
    ),

  ],
  child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffF9F2ED),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: height * 0.02),
                  BlocBuilder<SearchclassCubit, SearchclassState>(
                    builder: (context, state) {
                      final cubit = context.read<SearchclassCubit>();
                      return
                        formField(
                          onFieldSubmitted: (value) {
                            final trimmedValue = value.trim(); // remove spaces from start/end
                            if (trimmedValue.isEmpty) return; // don't proceed if input is blank

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Dashborad(initialSearchText: trimmedValue),
                              ),
                            );

                          },

                        prefixIcon: Icons.search,
                        context: context,
                        controller: cubit.searchController,
                        onChanged: (value) => cubit.search(value),
                        topLeft: height * 0.02,
                        topRight: height * 0.02,
                          bottomLeft: height * 0.02,
                          bottomRight: height * 0.02,

                      );
                    },
                  ),


                  SizedBox(height: height * 0.02),


                     BlocBuilder<SearchclassCubit, SearchclassState>(
                      builder: (context, state) {
                        if (state is SearchclassLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is SearchclassLoaded) {
                          if (state.data.isEmpty) {
                            return const Center(child: Text("No matching data"));
                          }
                          return ListView.separated(
                             shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),

                            itemCount: state.data.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: height * 0.005),
                            itemBuilder: (context, index) {
                              final item = state.data[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff7DFFFFFF),
                                  borderRadius: BorderRadius.circular(height * 0.02),
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.history,color: Color(0xff3F414E),),
                                  title: Text(
                                    item['label'] ?? '',
                                    style: const TextStyle(color: Color(0xff3F414E)),
                                  ),
                                  onTap: () {
                                    final cubit = context.read<SearchclassCubit>();
                                    cubit.onItemSelected(item);
                                  },
                                ),
                              );
                            },
                          );
                        } else if (state is SearchclassError) {
                          return Center(child: Text(state.message));
                        }
                        return const SizedBox();
                      },
                    ),
                  SizedBox(height: height * 0.02),
                  fieldTitle(title: "Suggested For You", width: width),
                  SizedBox(height: height * 0.02),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.22,
                    child:
                    ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      separatorBuilder: (context, index) => SizedBox(width: MediaQuery.of(context).size.width * 0.03), // <-- horizontal spacing
                      itemBuilder: (context, index) {
                        return customBox(
                          imageurl: '',
                          name: 'YOKESH V',
                          carrier: 'FRONTEND DEVELOPER',
                          location: 'Kozhikode, Kerala, India',
                          context: context,
                        );
                      },
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

Widget formField({
  required BuildContext context,
  String? hintText,
   TextEditingController ? controller,
  Function(String)? onChanged,
  Widget? child,
  IconData? prefixIcon,
  IconData? suffixIcon,
  VoidCallback? onSuffixTap,
  double ? topLeft,
  double ? topRight,
  double ? bottomLeft,
  double ? bottomRight,
  Function(String)? onFieldSubmitted, // ✅ add this




}) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  return Container(
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
    child: Center(
      child: child ??
          TextFormField(
            controller: controller,
            onChanged: onChanged,
            style: TextStyle(
              fontFamily: 'Sora',
              fontSize: height * 0.017,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: const TextStyle(color: Color(0xff3F414E)),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: Colors.white)
                  : null,
              suffixIcon: suffixIcon != null
                  ? GestureDetector(
                onTap: onSuffixTap,
                child: Icon(suffixIcon, color: Colors.white),
              )
                  : null,
            ),
            onFieldSubmitted: onFieldSubmitted,
          ),
    ),
  );
}

Widget responsiveContainer(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  return Container(
    width: screenWidth * (354 / 375),
    height: screenHeight * 0.06,
    margin: EdgeInsets.only(top: screenHeight * 0.30, left: screenWidth * 0.05),
    padding: EdgeInsets.all(screenWidth * 0.04),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(screenHeight * 0.01),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        const Icon(Icons.search),
        SizedBox(width: screenWidth * 0.02),
        const Expanded(
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search...',
            ),
          ),
        ),
      ],
    ),
  );
}

Widget searchInfoBox({
  required BuildContext context,
  required IconData icon,
  required String text,
  Color iconColor = Colors.black,
  Color textColor = Colors.black,
  Color backgroundColor = Colors.white,
}) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  return Container(
    width: screenWidth * (354 / 375),
    height: screenHeight * 0.06,
    margin: EdgeInsets.only(
        top: screenHeight * 0.025,
        left: screenWidth * 0.05,
        right: screenWidth * 0.05),
    padding: EdgeInsets.all(screenWidth * 0.04),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(screenHeight * 0.01),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Icon(icon, color: iconColor),
        SizedBox(width: screenWidth * 0.02),
        Text(
          text,
          style: TextStyle(
            fontSize: screenHeight * 0.02,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ],
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
      height: height * 0.22,
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

