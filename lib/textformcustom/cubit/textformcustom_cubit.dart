// import 'package:bloc/bloc.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:meta/meta.dart';
// import 'package:http/http.dart' as http;
//
// import '../model/model.dart';
//
// part 'textformcustom_state.dart';
//
// class TextformcustomCubit extends Cubit<TextformcustomState> {
//   TextformcustomCubit() : super(TextformcustomInitial());
//
//   String? selectedCategory;
//   List<String> filteredJobTitles = [];
//   List imagesData = [];
//   final TextEditingController controller = TextEditingController();
//   final FocusNode focusNode = FocusNode();
//   final categoryController = TextEditingController();
//   final jobTitleController = TextEditingController();
//
//   final categoryFocusNode = FocusNode();
//   final jobTitleFocusNode = FocusNode();
//
//
//   String baseurl = "https://0829-103-153-105-140.ngrok-free.app";
//   void updateJobTitlesForCategory(String category) {
//     selectedCategory = category;
//
//     filteredJobTitles = imagesData
//         .where((e) => e["category"] == category)
//         .map((e) => e["job_title"].toString())
//         .toSet() // remove duplicates
//         .toList();
//
//     emit(TextformcustomInitial());
//   }
//
//   Future<void>getthetextsuggestion()async{
//     final url = "$baseurl/api/employer/job-titles-view/";
//     final response = await http.get(Uri.parse(url)
//
//     );
//     if(response.statusCode >= 200 && response.statusCode <= 299){
//       final data = getthetextsuggestionFromJson(response.body);
//       print(data);
//       final mapped = data.map((item) {
//         return {
//           "id": item.id,
//           "job_title": item.jobTitle,
//           "category": item.category,
//           "label": item.label,
//           "value": item.value,
//           "talent_category": item.talentCategory,
//         };
//       }).toList();
//       imagesData.addAll(mapped);
//
//
//       print("hey where$imagesData");
//
//       emit(TextformcustomInitial());
//
//     }else {
//       print("statusCode${response.statusCode}");
//     }
//   }
// }
