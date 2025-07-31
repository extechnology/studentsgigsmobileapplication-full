// postyourjob_cubit.dart
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'dart:io' as io show File, Directory;
import 'package:path/path.dart' as path;

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart'as http;

import '../../../Premiumemployer/premiumemployerpage.dart';
import '../../../datapage/datapage.dart';
import '../model/model.dart';
import '../model2/model2.dart';

part 'postyourjob_state.dart';

class PostyourjobCubit extends Cubit<PostyourjobState> {
  PostyourjobCubit() : super(PostyourjobInitial()) {
    initQuill(); // ✅ Ensure this runs immediately

    // Future.delayed(const Duration(seconds: 7), () {
    //   initLocationListener();
    // });
  }
  bool Online = true;
  void toggleJobMode(bool online) {
    Online = online;
    emit(PostyourjobInitial());
  }
  bool isminAgeKey = true;
  bool ismaxAgeKey = true;
  bool isJobTitleValid = true;
  bool isCategoryValid = true;
  bool isLocationValid = true;
  bool isDescriptionValid = true;
  bool isPreferredAcademicValid = true;
  bool isCompensationValid = true;
  bool isAmountValid = true;
  void resetValidation() {
     isminAgeKey = true;
     ismaxAgeKey = true;
     isJobTitleValid = true;
     isCategoryValid = true;
     isLocationValid = true;
     isDescriptionValid = true;
     isPreferredAcademicValid = true;
     isCompensationValid = true;
     isAmountValid = true;
  }


  String? selectedLocation;
  String? selectedCategory;
   bool shouldListenToLocationChanges = true;
  List<String> filteredJobTitles = [];
  final List<String> payStructures = [
    "Hourly Rate",
    "All-Day Gigs",
    "Weekend Gigs",
    "Vacation Gigs",
    "Project Based",
  ];
  List imagesData = [];
  List<Map<String, Object>> locationdata = [];
  final LayerLink layerLink = LayerLink();
  late final String defaultQuillText;


  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final categoryController = TextEditingController();
  final jobTitleController = TextEditingController();
  final preferredacademicController = TextEditingController();
  final locationController = TextEditingController();

  final minage = TextEditingController();
  final maxage = TextEditingController();
  final compensationController = TextEditingController();
  final amountcontroller = TextEditingController();
  final categoryFocusNode = FocusNode();

  final locationFocusNode = FocusNode();
  final jobTitleFocusNode = FocusNode();
  final preferredacademicFocusNode = FocusNode();
  final compasationFocusNode = FocusNode();


  final List<String> degrees = [
    "B.Tech - Computer Science",
    "B.Tech - Mechanical Engineering",
    "B.Tech - Civil Engineering",
    "B.Tech - Electrical Engineering",
    "B.Tech - Electronics and Communication",
    "M.Tech - Computer Science",
    "M.Tech - Mechanical Engineering",
  ];
  final String baseurl = ApiConstants.baseUrl;



  void updateJobTitlesForCategory(String category) {
    selectedCategory = category;

    filteredJobTitles = imagesData
        .where((e) => e["category"] == category)
        .map((e) => e["job_title"].toString())
        .toSet() // remove duplicates
        .toList();

    emit(PostyourjobInitial());
  }

  Future<void> getthetextsuggestion() async {
    final url = "$baseurl/api/employer/job-titles-view/";
    final response = await http.get(Uri.parse(url)

    );
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      final data = getthetextsuggestionFromJson(response.body);
      print(data);
      final mapped = data.map((item) {
        return {
          "id": item.id,
          "job_title": item.jobTitle,
          "category": item.category,
          "label": item.label,
          "value": item.value,
          "talent_category": item.talentCategory,
        };
      }).toList();
      imagesData.addAll(mapped);


      print("hey where$imagesData");

      emit(PostyourjobInitial());
    } else {
      print("statusCode${response.statusCode}");
    }
  }

  Future<void> getLocation(String query) async {
    final url = "$baseurl/api/employer/locations-employer/?query=$query";
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final parsed = countrylocationFromJson(response.body);
        final mapped = parsed.features.map((item) {
          final name = item.properties.name;
          final state = item.properties.state ?? '';
          final country = item.properties.country ?? '';
          return {
            "label": "$name, $state, $country",
            "value": "$name, $state, $country",
            "id": item.properties.osmId,
          };
        }).toList();

        locationdata = mapped;

        // ⚡️ REMOVE THIS EMIT
        // emit(PostyourjobInitial());
      } else {
        print("Location fetch failed: ${response.statusCode}");
      }
    } on TimeoutException {
      print("Location request timed out after 15 seconds");
    } catch (e) {
      print("Location fetch error: $e");
    }
  }
  void initLocationListener() {
    locationController.addListener(() {
      if (!shouldListenToLocationChanges) return;

      final query = locationController.text.trim();
      if (selectedLocation != null && query == selectedLocation) {
        return; // Don't call getLocation if it's the selected value
      }

      if (query.length >= 3) {
        getLocation(query);
      }
    });
  }
  Future<List<String>> getLocationSuggestions(String query) async {
    await getLocation(query);
    return locationdata.map((e) => e['label'] as String).toList();
  }
  Timer? _debounce;

  void onLocationChanged(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!shouldListenToLocationChanges) return;

      if (selectedLocation != null && query == selectedLocation) {
        return;
      }

      if (query.length >= 3) {
        getLocation(query);
      } else {
        locationdata = [];
        emit(PostyourjobInitial()); // Clears results if needed
      }
    });
  }
  late QuillController quillController;
  final FocusNode editorFocusNode = FocusNode();
  final ScrollController editorScrollController = ScrollController();

  void initQuill() {
    final defaultDelta = Delta()


      ..insert('\n  1. Job Details\n', {'b': true})
      ..insert('\n  • Job Title: Graphic Designer for Social Media\n')
      ..insert('\n • Job Description:\nWe are looking for a creative student to design engaging social media posts for our brand.\nYou will be responsible for creating visuals that align with our brand\'s identity.\n\n')
      ..insert('\n • Required Skills: (Select Multiple)\n')



      ..insert('\n • Adobe Photoshop\n')
      ..insert('\n • Canva\n')
      ..insert('\n • Social Media Marketing\n\n')
      ..insert('\n 2. Job Type & Payment\n', {'b': true})



      ..insert('\n • Job Type: (Choose one)\n○ Freelance\n○ Part-time\n○ One-time Gig\n')
      ..insert('\n • Work Mode: (Choose one)\n○ Remote\n○ On-Site\n○ Hybrid\n')
      ..insert('\n • Payment Type: (Choose one)\n○ Fixed Price – ₹5,000\n○ Hourly Rate – ₹300/hr\n\n')
      ..insert('\n 3. Job Preferences\n', {'b': true})
      ..insert('\n • Experience Level: (Choose one)\n○ Beginner\n○ Intermediate\n○ Advanced\n')
      ..insert('\n • Number of Positions Available: 2\n\n')
      ..insert('\n 4. Job Location (If On-Site)\n', {'b': true})


      ..insert('\n • Company Address: ABC Marketing, Kochi, Kerala\n\n')
      ..insert('\n 5. Application Deadline & Contact\n', {'b': true})
      ..insert('\n • Application Deadline: March 20, 2025\n')
      ..insert('\n • Contact Email: hr@abcmarketing.com\n\n');
    defaultQuillText = Document.fromDelta(defaultDelta).toPlainText().trim();

    quillController = QuillController(
      document: Document.fromDelta(defaultDelta),
      selection: const TextSelection.collapsed(offset: 0),
      config: QuillControllerConfig(
        clipboardConfig: QuillClipboardConfig(
          enableExternalRichPaste: true,
          onImagePaste: (imageBytes) async {
            if (kIsWeb) return null;
            final filePath = path.join(
              io.Directory.systemTemp.path,
              'image-${DateTime.now().millisecondsSinceEpoch}.png',
            );
            final file = await io.File(filePath).writeAsBytes(imageBytes);
            return file.path;
          },
        ),
      ),
    );
  }
  Future<Map<String, dynamic>?> fetchPlanUsage() async {
    final uri = Uri.parse('$baseurl/api/employer/employer-plan/');

    try {
      final token = await ApiConstants.getTokenOnly(); // ✅ get actual token
      final token2 = await ApiConstants.getTokenOnly2(); // ✅ get actual token

      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer ${token ?? token2}',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Failed to fetch plan usage: $e');
      return null;
    }
  }



  Future<void> postJobForm(BuildContext context,{
    required GlobalKey jobDescriptionKey,
    required GlobalKey categoryKey,
    required GlobalKey jobTitleKey,
    required GlobalKey locationKey,
    required GlobalKey prefeerredacademiv,
    required GlobalKey compensationKey,
    required GlobalKey minAgeKey,
    required GlobalKey maxAgeKey,
    required GlobalKey amount,}) async
  {
    final usageData = await fetchPlanUsage();

    if (usageData == null) {
      emit(PostyourjobFailure(error: 'Could not fetch usage info.'));
      return;
    }

    final canPostJob = usageData['usage']['can_post_job'] ?? false;
    final jobPostingLimit = int.tryParse(usageData['plan']['job_posting'] ?? '0') ?? 0;

    if (!canPostJob || jobPostingLimit <= 0) {
      Navigator.pushNamed(context,'Premiumemployerpage' );
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => Premiumemployerpage()));
      return;
    }
    resetValidation();

    bool isValid = true;

    final currentText = quillController.document.toPlainText().trim();

    if (currentText == defaultQuillText || currentText.isEmpty) {
      isDescriptionValid = false;
      emit(Postyourpost()); // ← add this line
      scrollToField(jobDescriptionKey);
      isValid = false;

    }
    if (categoryController.text.trim().isEmpty) {
       isCategoryValid = false;
       emit(Postyourpost()); // ← add this line
       scrollToField(categoryKey);
      isValid = false;


    }
    if (amountcontroller.text.trim().isEmpty) {
      isAmountValid = false;
      emit(Postyourpost()); // ← add this line
      scrollToField(amount);
      isValid = false;

    }
    if (jobTitleController.text.trim().isEmpty) {
      isJobTitleValid = false;
      emit(Postyourpost()); // ← add this line
      scrollToField(jobTitleKey);
      isValid = false;

    }
    if (locationController.text.trim().isEmpty) {
      isLocationValid = false;
      emit(Postyourpost()); // ← add this line
      scrollToField(locationKey);
      isValid = false;
    }
    if (preferredacademicController.text.trim().isEmpty) {
      isPreferredAcademicValid = false;
      emit(Postyourpost()); // ← add this line
      scrollToField(prefeerredacademiv);
      isValid = false;
    }
    if (compensationController.text.trim().isEmpty) {
      isCompensationValid = false;
      emit(Postyourpost()); // ← add this line

      scrollToField(compensationKey);
      isValid = false;

    }
    if (minage.text.trim().isEmpty || maxage.text.trim().isEmpty) {
      ismaxAgeKey = false;
      isminAgeKey = false;
      emit(Postyourpost()); // ← add this line

      scrollToField(minAgeKey);
      scrollToField(maxAgeKey);
      isValid = false;

    }
    if (!isValid) return;// ✅ <- add here


    emit(PostyourjobLoading());

    final uri = Uri.parse(
        Online

        ? "$baseurl/api/employer/online-job-info/"
        :  "$baseurl/api/employer/offline-job-info/"

    );


    try {

      final token = await ApiConstants.getTokenOnly(); // ✅ get actual token
      final token2 = await ApiConstants.getTokenOnly2(); // ✅ get actual token

      final request = http.MultipartRequest('POST', uri);

      // 👇 Replace with your actual token

      request.headers['Authorization'] = 'Bearer ${token ?? token2}';

      request.fields['job_title'] = jobTitleController.text.trim();
      request.fields['category'] = categoryController.text.trim();
      request.fields['age_requirement_min'] = minage.text.trim();
      request.fields['age_requirement_max'] = maxage.text.trim();
      request.fields['preferred_academic_courses'] = preferredacademicController.text.trim();
      request.fields['pay_structure'] = amountcontroller.text.trim();
      request.fields['salary_type'] = compensationController.text.trim();
      request.fields['job_description'] = quillController.document.toPlainText().trim();
      request.fields['job_location'] = locationController.text.trim();

      final response = await request.send();

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        jobTitleController.clear();
        categoryController.clear();


        minage.clear();
        maxage.clear();
        preferredacademicController.clear();
        amountcontroller.clear();
        compensationController.clear();
        locationController.clear();
        quillController = QuillController(
          document: Document()..insert(0, defaultQuillText),
          selection: const TextSelection.collapsed(offset: 0),
        );

        // ✅ Reset all validation flags if needed
        print("success");
        emit(PostyourjobSuccess());
      } else {
        print("fail");
        emit(PostyourjobFailure(error: 'Server Error: ${response.statusCode}'));
      }
    } catch (e) {
      print("fail");
      emit(PostyourjobFailure(error: 'Exception: $e'));
    }
  }

  @override
  Future<void> close() {
    quillController.dispose();
    editorFocusNode.dispose();
    editorScrollController.dispose();
    return super.close();
  }
  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  void scrollToField(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }
  void validateJobTitleOnInput(String value) {
    if (!isJobTitleValid && value.trim().isNotEmpty) {
      isJobTitleValid = true;
      emit(Postyourpost()); // Or a new state like PostyourjobValidationUpdated
    }
  }
  void validateCategoryOnInput(String value) {
    if (!isCategoryValid && value.trim().isNotEmpty) {
      isCategoryValid = true;
      emit(Postyourpost()); // Or a new state like PostyourjobValidationUpdated
    }
  }
  void validateLocationOnInput(String value) {
    if (!isLocationValid && value.trim().isNotEmpty) {
      isLocationValid = true;
      emit(Postyourpost()); // Or a new state like PostyourjobValidationUpdated
    }
  }
  void validateDescriptionOnInput(String value) {
    if (!isDescriptionValid && value.trim().isNotEmpty) {
      isDescriptionValid = true;
      emit(Postyourpost()); // Or a new state like PostyourjobValidationUpdated
    }
  }
  void validatepreferredOnInput(String value) {
    if (!isPreferredAcademicValid && value.trim().isNotEmpty) {
      isPreferredAcademicValid = true;
      emit(Postyourpost()); // Or a new state like PostyourjobValidationUpdated
    }
  }
  void validatecompensationOnInput(String value) {
    if (!isCompensationValid && value.trim().isNotEmpty) {
      isCompensationValid = true;
      emit(Postyourpost()); // Or a new state like PostyourjobValidationUpdated
    }
  }
  void validateamountOnInput(String value) {
    if (!isAmountValid && value.trim().isNotEmpty) {
      isAmountValid = true;
      emit(Postyourpost()); // Or a new state like PostyourjobValidationUpdated
    }
  }
  void validateminOnInput(String value) {
    if (!isminAgeKey && value.trim().isNotEmpty) {
      isminAgeKey = true;
      emit(Postyourpost()); // Or a new state like PostyourjobValidationUpdated
    }
  }



}