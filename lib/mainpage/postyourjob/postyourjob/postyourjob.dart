import 'dart:convert';

import 'package:anjalim/mainpage/postyourjob/postyourjob/cubit/postyourjob_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

import '../../widgets/typeagecondetion.dart';
import '../../widgets/typeforlocation.dart';
import '../../widgets/typehyder.dart';

class Postyourjob extends StatefulWidget {
  final TabController tabController;

  const Postyourjob({super.key, required this.tabController});

  @override
  State<Postyourjob> createState() => _PostyourjobState();
}

class _PostyourjobState extends State<Postyourjob> {
  final GlobalKey categoryKey = GlobalKey();
  final GlobalKey jobTitleKey = GlobalKey();
  final GlobalKey locationKey = GlobalKey();
  final GlobalKey prefeerredacademiv = GlobalKey();

  final GlobalKey descriptionKey = GlobalKey();
  final GlobalKey minAgeKey = GlobalKey();
  final GlobalKey maxAgeKey = GlobalKey();
  final GlobalKey compensationKey = GlobalKey();
  final GlobalKey amountkey = GlobalKey();



  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return  BlocProvider(
  create: (context) => PostyourjobCubit()..getthetextsuggestion(),

  child:
  BlocListener<PostyourjobCubit, PostyourjobState>(
    listener: (context, state) {
      if (state is PostyourjobLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Loading....."),
            backgroundColor: Colors.green,
          ),
        );
        // Optionally show a loading spinner
      }
      else if (state is PostyourjobSuccess) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: const Color(0xffFFFFFF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ✅ Animated check icon
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 600),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Icon(Icons.check_circle, color: Colors.green, size: 80),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text("Success", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              content: const Text("Job posted successfully!", textAlign: TextAlign.center),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // close dialog
                    FocusScope.of(context).unfocus(); // hide keyboard

                    widget.tabController?.animateTo(1); // switch to "Posted" tab

                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );

      }
      else if (state is PostyourjobFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${state.error}")),
        );
      }
    // TODO: implement listener
  },
  child: BlocBuilder<PostyourjobCubit, PostyourjobState>(
  builder: (context, state) {
    final cubit = context.read<PostyourjobCubit>();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true, // ✅ Enables keyboard to push UI

        backgroundColor: Color(0xffF9F2ED),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,

          child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + height * 0.1,right: width *0.05,left: width * 0.05,top: MediaQuery.of(context).viewInsets.top + height * 0.03 ),
              child: Column(
                children: [
                  Builder(
                    key: categoryKey,
                    builder: (context) {
                      return buildFieldTitle(title: "Preferred Work Mode",  context: context);
                    }
                  ),
                  SizedBox(height: height * 0.02,),


                  Row(
                    children: [
                      SizedBox(width: width * 0.08,),
                      InkWell(onTap: () {
                        cubit.toggleJobMode(true); // user selected "On-site"
                      },

                        child: buildbox(text: "Online",
                          color: cubit.Online ? Color(0xffEB8125) : Color(0xffFFFFFF),
                          bordercolor: cubit.Online ? Color(0xffEB8125) : Color(0xffE3E3E3),
                          textcolor: cubit.Online ? Color(0xffFFFFFF) : Color(0xff000000), context: context,

                        ),
                      ),
                      SizedBox(width: width * 0.025), // ~10px on 400px wide screen

                      InkWell(
                        onTap: () {
                          cubit.toggleJobMode(false); // user selected "Online"

                        },
                        child: buildbox(text: "On-site",
                          color: !cubit.Online ? Color(0xffEB8125) : Color(0xffFFFFFF),
                          bordercolor: !cubit.Online ? Color(0xffEB8125) : Color(0xffE3E3E3),
                          textcolor: !cubit.Online ? Color(0xffFFFFFF) : Color(0xff000000), context: context,

                        ),
                      ),
                      SizedBox(width: width * 0.08,),



                    ],
                  ),
                  SizedBox(height: height * 0.02,),

                  Row(
                    children: [
                      buildFieldTitle(title: "Category", context: context, ),
                      SizedBox(width: width * 0.01,),
                      cubit.isCategoryValid ?
                          SizedBox()
                          :Text("Required",style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,    fontSize: width * 0.025, // ≈10 on 400px screen width
                      ),)
                    ],
                  ),

                  Builder(
                    key: jobTitleKey,
                    builder: (context) {
                      return Center(
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(15),

                          child: Container(
                            height: height * 0.06, // ≈50 when screen height is ~830
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color:  Colors.transparent ,
                                width: width * 0.0037, // ≈1.5 when screen width is ~400
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child:
                            CustomTypeAhead<String>(
                              controller: cubit.categoryController,
                              focusNode: cubit.categoryFocusNode,
                              suggestionsCallback: (query) async {
                                if (query.isEmpty) {
                                  return []; // ❌ This disables suggestions when text is cleared or empty

                                }
                                return cubit.imagesData
                                    .map((e) => e["category"] ?? "")
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
                              maxLength: 50,
                              decoration: InputDecoration(

                                // hintText: "Select Job Category",
                                contentPadding: EdgeInsets.symmetric(horizontal: width * 0.04), // 0.04 × 400 = 16
                                border: InputBorder.none,
                              ),

                            ),
                          ),
                        ),
                      );
                    }
                  ),
                  SizedBox(height: height * 0.02,),

                  Row(
                    children: [
                      buildFieldTitle(title: "Job Title ",  context: context),
                      SizedBox(width: width * 0.01,),
                      cubit.isJobTitleValid ?
                      SizedBox()
                          :Text("Required",style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,fontSize: 10 ),)
                    ],
                  ),


                  // 🔹 Second: Job Title Selector
                  Builder(
                    key: locationKey,
                    builder: (context) {
                      return Center(
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(15),

                          child: Container(
                            height: height * 0.06, // 0.06 × 800 = 48 (approx. 50 on 800px screen)
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color:  Colors.transparent ,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child:
                            CustomTypeAhead<String>(

                          
                              controller: cubit.jobTitleController,
                              focusNode: cubit.jobTitleFocusNode,
                              suggestionsCallback: (query) async {
                                if (query.isEmpty) {
                                  return []; // ❌ This disables suggestions when text is cleared or empty

                                }
                                return cubit.filteredJobTitles
                                    .where((item) =>
                                    item.toLowerCase().contains(query.toLowerCase()))
                                    .toList();
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(title: Text(suggestion,));
                              },
                              onSuggestionSelected: (suggestion) {
                                cubit.jobTitleController.text = suggestion;
                              },
                              maxLength: 50,
                              decoration:  InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: width * 0.04), // 0.04 × 400 = 16
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                  SizedBox(height: height * 0.02,),

                  Row(
                    children: [
                      buildFieldTitle(title: "Job Location ",  context: context),
                      SizedBox(width: width * 0.01,),
                      cubit.isLocationValid ?
                      SizedBox()
                          :Text("Required",style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,fontSize: 10 ),)
                    ],
                  ),
                  Builder(
                    key: prefeerredacademiv,
                    builder: (context) {
                      return Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(15),

                        child: Container(
                          height: height * 0.06, // 0.06 × 800 = 48 (approx. 50 on 800px screen)

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color:  Colors.transparent ,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child:
                          CustomTypeAheadWithEmptyCheck<String>(
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
                              // print("Selected Location ID: $locationId");

                              Future.delayed(const Duration(milliseconds: 300), () {
                                cubit.shouldListenToLocationChanges = true;
                              });
                            },
                            maxLength: 50,
                            decoration:  InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: width * 0.04), // 0.04 × 400 = 16
                              border: InputBorder.none,
                              hintText: "Please Enter Your Location",
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                  SizedBox(height: height * 0.02,),

                  Row(
                    children: [
                      buildFieldTitle(title: "Preferred Academic Course", context: context),
                      SizedBox(width: width * 0.01,),
                      cubit.isPreferredAcademicValid ?
                      SizedBox()
                          :Text("Required",style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,fontSize: 10 ),)
                    ],
                  ),

                  Builder(
                    key: compensationKey,
                    builder: (context) {
                      return Center(
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(15),

                          child: Container(
                            height: height * 0.06, // 0.06 × 800 = 48 (approx. 50 on 800px screen)
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color:  Colors.transparent ,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child:
                            CustomTypeAhead<String>(
                              controller: cubit.preferredacademicController,
                              focusNode: cubit.preferredacademicFocusNode,
                              suggestionsCallback: (query) async {
                                if (query.isEmpty) {
                                  return []; // ❌ This disables suggestions when text is cleared or empty

                                }
                                return cubit.degrees
                                    .where((item) =>
                                    item.toLowerCase().contains(query.toLowerCase()))
                                    .toList();
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(title: Text(suggestion,));
                              },
                              onSuggestionSelected: (suggestion) {
                                cubit.preferredacademicController.text = suggestion;
                              },
                              maxLength: 70,
                              decoration:  InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: width * 0.04), // 0.04 × 400 = 16
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                  SizedBox(height: height * 0.02,),

                  Row(
                    children: [
                      buildFieldTitle(title: "Compensation/Pay Structure", context: context, ),
                      SizedBox(width: width * 0.01,),
                      cubit.isCompensationValid ?
                      SizedBox()
                          :Text("Required",style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,fontSize: 10 ),)
                    ],
                  ),
                  Builder(
                    key: minAgeKey,
                    builder: (context) {
                      return Center(
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(15),

                          child: Container(
                            height: height * 0.06, // 0.06 × 800 = 48 (approx. 50 on 800px screen)
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color:  Colors.transparent ,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child:
                            CustomTypeAhead<String>(
                              controller: cubit.compensationController,
                              focusNode: cubit.compasationFocusNode,
                              suggestionsCallback: (query) async {
                                if (query.isEmpty) {
                                  return []; // ❌ This disables suggestions when text is cleared or empty

                                }
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
                              maxLength: 30,
                              decoration:  InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: width * 0.04), // 0.04 × 400 = 16
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                  SizedBox(height: height * 0.02,),


                  Row(
                    children: [
                      buildFieldTitle(title: "Age Preference", context: context, ),
                      SizedBox(width: width * 0.01,),
                      cubit.isPreferredAcademicValid ?
                      SizedBox()
                          :Text("Required",style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,fontSize: 10 ),)
                    ],
                  ),
                Builder(
                  key: amountkey,
                  builder: (context) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),


                        ),
                        border: Border.all(
                          color:  Colors.transparent ,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),

                      child:
                      MinAgeField(
                        maxLength: 5,
                        hinttext: "Minimum",
                        controller: cubit.minage,
                        minAge: 14,
                        onChanged: (value) {
                          // print("Age value changed: $value");
                        },
                      ),
                    );
                  }
                ),
                  Builder(
                    key: maxAgeKey,
                    builder: (context) {
                      return Material(
                        elevation: 1,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),

                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),
                            border: Border.all(
                              color:  Colors.transparent ,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: MinAgeField(
                            maxLength: 5,
                            firsttext: "",
                            hinttext: "Maximum",
                            controller: cubit.maxage,
                            minAge: 14,
                            onChanged: (value) {
                              // print("Age value changed: $value");
                            },
                          ),
                        ),
                      );
                    }
                  ),
                  SizedBox(height: height * 0.02,),

                  Row(
                    children: [
                      buildFieldTitle(title: "Amount ", context: context, ),
                      SizedBox(width: width * 0.01,),

                      cubit.isAmountValid ?
                      SizedBox()
                          :Text("Required",style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,fontSize: 10 ),)
                    ],
                  ),


                  Builder(
                    key: descriptionKey,
                    builder: (context) {
                      return Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(15),

                        child: Container(
                          decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color:  Colors.transparent ,
                              width: 1.5,
                            ),
                         boxShadow: [
                           BoxShadow(
                             color: Colors.black.withOpacity(0.05),
                             blurRadius: 4,
                             offset: const Offset(0, 2),
                           ),
                         ],
                                         ),

                                         child: TextFormField(
                                           maxLength: 20  ,
                         controller: cubit.amountcontroller,
                         keyboardType:  TextInputType.numberWithOptions(
                           decimal: false, // set true if you want decimal numbers
                           signed: false,  // set true if you want negative numbers
                         ),
                         inputFormatters: [
                           FilteringTextInputFormatter.digitsOnly, // ✅ Only allow digits
                         ],

                         decoration: InputDecoration(
                           contentPadding: EdgeInsets.symmetric(horizontal: width * 0.04), // 0.04 × 400 = 16
                           border: InputBorder.none,
                         ),

                                         ),
                                       ),
                      );
                    }
                  ),
                  SizedBox(height: height * 0.02,),

                  Row(
                    children: [
                      buildFieldTitle(title: "Job Description", context: context, ),
                      SizedBox(width: width * 0.01,),
                      cubit.isDescriptionValid ?
                      SizedBox()
                          :Text("Required",style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,fontSize: 10 ),)
                    ],
                  ),
                  Builder(
                    builder: (context) {
                      return Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(15),

                        child: Container(
                          width: width * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color:  Colors.transparent ,
                              width: 1.5,
                            ),
                            color: Color(0xFFF2F4F7), // Your selected Gray/100 color
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                  color: Color(0xFFF2F4F7),
                                ),
                                child: QuillSimpleToolbar(

                                  controller: cubit.quillController,
                                  config: QuillSimpleToolbarConfig(


                                    embedButtons: FlutterQuillEmbeds.toolbarButtons(),
                                    showUndo: true,

                                    showRedo: true,
                                    showBoldButton: true,
                                    showItalicButton: true,
                                    showUnderLineButton: true,
                                    showListBullets: true,
                                    showListNumbers: true,
                                    showCodeBlock: true,
                                    showInlineCode: true,
                                    showLink: true,
                                    multiRowsDisplay: true,
                                    showHeaderStyle: false,
                                    showFontFamily: false,
                                    showFontSize: false,
                                    showCenterAlignment: false,
                                    showLeftAlignment: false,
                                    showJustifyAlignment: false,
                                    showRightAlignment: false,
                                    showClearFormat: false,
                                    showQuote: false,
                                    showSearchButton: false,
                                    showDirection: false,
                                    showClipboardCopy: false,
                                    showClipboardCut: false,
                                    showClipboardPaste: false,
                                    showBackgroundColorButton: false,
                                    showAlignmentButtons: false,
                                    showColorButton: false,
                                    showDividers: false,
                                     showIndent: false,
                                    showLineHeightButton: false,
                                    showListCheck: false,
                                    showSmallButton: false,
                                    showStrikeThrough: false,
                                    showSubscript: false,
                                    showSuperscript: false
                                  ),
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.00625), // ✅ adds space inside
                                  child: QuillEditor(

                                    controller: cubit.quillController,
                                    focusNode: cubit.editorFocusNode,
                                    scrollController: cubit.editorScrollController,

                                    config: QuillEditorConfig(

                                      placeholder: 'Write job description...',
                                      embedBuilders: [
                                        ...FlutterQuillEmbeds.editorBuilders(),
                                        TimeStampEmbedBuilder(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                  SizedBox(height: height * 0.05,),
                  GestureDetector(
                    onTap: () {

                      cubit.postJobForm(
                        context,

                        amount: amountkey,
                        categoryKey: categoryKey,
                        compensationKey: compensationKey,
                        jobDescriptionKey: descriptionKey,
                        jobTitleKey: jobTitleKey,
                        locationKey: locationKey,
                        maxAgeKey: maxAgeKey,
                        minAgeKey: minAgeKey,
                        prefeerredacademiv: prefeerredacademiv
                      );

                    },
                    child: Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(16),

                      child: Container(
                          width: width * 0.4587,
                          height: height * 0.0493,
                        decoration: BoxDecoration(
                          color: Color(0xffEB8125), // or any background color you want
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child:
                          Center(
                            child: Text(
                              'Post Job',
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontWeight: FontWeight.w600,
                                fontSize: width * 0.0427,
                                height: 1.5, // 150% line-height
                                letterSpacing: 0, // 0% letter-spacing
                              ),
                            )

                          )
                      ),
                    ),
                  )



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
Widget buildFieldTitle({String ? title, required BuildContext context}) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Text(
      title!,
      style: TextStyle(
        fontFamily: 'Sora',
        fontWeight: FontWeight.w600,
        fontSize: width * 0.037,
      ),
    ),
  );
}
Widget buildbox({ required BuildContext context,required String text,required Color color,required Color bordercolor,required Color textcolor}){
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;


  return Material(
    elevation: 1,
    borderRadius: BorderRadius.circular(15),

    child: Container(

      width: screenWidth * 0.35 ,
      height: screenHeight * 0.05,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: bordercolor
          )
      ),
      child: Center(child: Text(text,style: TextStyle(color:textcolor,fontFamily: 'Sora', fontWeight: FontWeight.w400,

        fontSize: screenWidth * 0.035, // Responsive font size

      ),)),
    ),
  );

}
Widget buildField({ required BuildContext context ,required String title, TextEditingController ? controller}) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  return Padding(
    padding: EdgeInsets.symmetric(vertical: height * 0.01),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildFieldTitle(title: title, context: context),
        SizedBox(height:height * 0.01),
        Container(
          height: height * 0.06,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child:  TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: width * 0.04), // e.g., 4% of screen width
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    ),
  );
}
class TimeStampEmbed extends Embeddable {
  const TimeStampEmbed(String value) : super('timeStamp', value);
  static TimeStampEmbed fromDocument(Document document) =>
      TimeStampEmbed(jsonEncode(document.toDelta().toJson()));
  Document get document => Document.fromJson(jsonDecode(data));
}

class TimeStampEmbedBuilder extends EmbedBuilder {
  @override
  String get key => 'timeStamp';

  @override
  String toPlainText(Embed node) => node.value.data;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Row(
      children: [
        const Icon(Icons.access_time_rounded),
        SizedBox(width: width * 0.01), // ~1% of screen width (adjust as needed)
        Text(embedContext.node.value.data as String),
      ],
    );
  }

}