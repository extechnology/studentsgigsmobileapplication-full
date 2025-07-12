// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:anjalim/textformcustom/cubit/textformcustom_cubit.dart';
// import '../mainpage/widgets/typehyder.dart';
//
// class MySearchPage extends StatelessWidget {
//   const MySearchPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final width = size.width;
//     final height = size.height;
//     return BlocProvider(
//       create: (context) => TextformcustomCubit()..getthetextsuggestion(),
//       child: BlocBuilder<TextformcustomCubit, TextformcustomState>(
//         builder: (context, state) {
//           final cubit = context.read<TextformcustomCubit>();
//
//           return SafeArea(
//             child: Scaffold(
//               body:
//               Padding(
//                 padding:  EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Column(
//                   children: [
//                     SizedBox(height: height * 0.02,),
//
//                     // 🔹 First: Category Selector
//                     Center(
//                       child: Container(
//                         width: 324,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.05),
//                               blurRadius: 4,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: CustomTypeAhead<String>(
//
//                           controller: cubit.categoryController,
//                           focusNode: cubit.categoryFocusNode,
//                           suggestionsCallback: (query) async {
//                             if (query.isEmpty) {
//                               return cubit.imagesData.map((e) => e["category"] ?? "").toSet().cast<String>().toList();
//                             }
//                             return cubit.imagesData
//                                 .map((e) => e["category"] ?? "")
//                                 .toSet()
//                                 .where((item) => item.toLowerCase().contains(query.toLowerCase()))
//                                 .cast<String>()
//                                 .toList();
//                           },
//                           itemBuilder: (context, suggestion) {
//                             return ListTile(title: Text(suggestion));
//                           },
//                           onSuggestionSelected: (suggestion) {
//                             cubit.categoryController.text = suggestion;
//                             cubit.updateJobTitlesForCategory(suggestion);
//                           },
//                           decoration:  InputDecoration(
//                             contentPadding: EdgeInsets.symmetric(horizontal: 16),
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // 🔹 Second: Job Title Selector
//                     Center(
//                       child: Container(
//                         width: 324,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.05),
//                               blurRadius: 4,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: CustomTypeAhead<String>(
//                           controller: cubit.jobTitleController,
//                           focusNode: cubit.jobTitleFocusNode,
//                           suggestionsCallback: (query) async {
//                             return cubit.filteredJobTitles
//                                 .where((item) => item.toLowerCase().contains(query.toLowerCase()))
//                                 .toList();
//                           },
//                           itemBuilder: (context, suggestion) {
//                             return ListTile(title: Text(suggestion,));
//                           },
//                           onSuggestionSelected: (suggestion) {
//                             cubit.jobTitleController.text = suggestion;
//                           },
//                           decoration: const InputDecoration(
//                             contentPadding: EdgeInsets.symmetric(horizontal: 16),
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
