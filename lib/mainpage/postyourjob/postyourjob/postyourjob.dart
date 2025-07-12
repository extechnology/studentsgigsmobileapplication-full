import 'dart:convert';

import 'package:anjalim/mainpage/postyourjob/postyourjob/cubit/postyourjob_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

import '../../../tas.dart';
import '../../widgets/typeagecondetion.dart';
import '../../widgets/typeforlocation.dart';
import '../../widgets/typehyder.dart';

class Postyourjob extends StatefulWidget {
  const Postyourjob({super.key});

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
        // Optionally show a loading spinner
      } else if (state is PostyourjobSuccess) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Success"),
            content: const Text("Job posted successfully!"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else if (state is PostyourjobFailure) {
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
                      return buildFieldTitle("Preferred Work Mode", width);
                    }
                  ),
                  Row(
                    children: [
                      SizedBox(width: 30,),
                      InkWell(onTap: () {
                        cubit.toggleJobMode(true); // user selected "On-site"
                      },

                        child: buildbox(text: "Online",
                          color: cubit.Online ? Color(0xffEB8125) : Color(0xffFFFFFF),
                          bordercolor: cubit.Online ? Color(0xffEB8125) : Color(0xffE3E3E3),
                          textcolor: cubit.Online ? Color(0xffFFFFFF) : Color(0xff000000),

                        ),
                      ),
                      SizedBox(width: 10,),

                      InkWell(
                        onTap: () {
                          cubit.toggleJobMode(false); // user selected "Online"

                        },
                        child: buildbox(text: "On-site",
                          color: !cubit.Online ? Color(0xffEB8125) : Color(0xffFFFFFF),
                          bordercolor: !cubit.Online ? Color(0xffEB8125) : Color(0xffE3E3E3),
                          textcolor: !cubit.Online ? Color(0xffFFFFFF) : Color(0xff000000),

                        ),
                      ),
                      SizedBox(width: 10,),



                    ],
                  ),
                  Row(
                    children: [
                      buildFieldTitle("Category", width),
                      SizedBox(width: width * 0.01,),
                      cubit.isCategoryValid ?
                          SizedBox()
                          :Text("Required",style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,fontSize: 10 ),)
                    ],
                  ),

                  Builder(
                    key: jobTitleKey,
                    builder: (context) {
                      return Center(
                        child: Container(
                          height: 50,
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
                            controller: cubit.categoryController,
                            focusNode: cubit.categoryFocusNode,
                            suggestionsCallback: (query) async {
                              if (query.isEmpty) {
                                return cubit.imagesData.map((e) =>
                                e["category"] ?? "").toSet().cast<String>().toList();
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
                            decoration: InputDecoration(
                              // hintText: "Select Job Category",
                              contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                  Row(
                    children: [
                      buildFieldTitle("Job Title ", width),
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
                        child: Container(
                          height: 50,
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
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 20),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                  Row(
                    children: [
                      buildFieldTitle("Job Location ", width),
                      SizedBox(width: width * 0.01,),
                      cubit.isLocationValid ?
                      SizedBox()
                          :Text("Required",style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,fontSize: 10 ),)
                    ],
                  ),
                  Builder(
                    key: prefeerredacademiv,
                    builder: (context) {
                      return Container(
                        height: 50,
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
                            print("Selected Location ID: $locationId");

                            Future.delayed(const Duration(milliseconds: 300), () {
                              cubit.shouldListenToLocationChanges = true;
                            });
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20),
                            border: InputBorder.none,
                            hintText: "Please Enter Your Location",
                          ),
                        ),
                      );
                    }
                  ),
                  Row(
                    children: [
                      buildFieldTitle("Preferred Academic Course", width),
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
                        child: Container(
                          height: 50,
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
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 20),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                  Row(
                    children: [
                      buildFieldTitle("Compensation/Pay Structure", width),
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
                        child: Container(
                          height: 50,
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
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 20),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      );
                    }
                  ),

                  Row(
                    children: [
                      buildFieldTitle("Age Preference", width),
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
                        hinttext: "Minimum",
                        controller: cubit.minage,
                        minAge: 14,
                        onChanged: (value) {
                          print("Age value changed: $value");
                        },
                      ),
                    );
                  }
                ),
                  Builder(
                    key: maxAgeKey,
                    builder: (context) {
                      return Container(
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
                          firsttext: "",
                          hinttext: "Maximum",
                          controller: cubit.maxage,
                          minAge: 14,
                          onChanged: (value) {
                            print("Age value changed: $value");
                          },
                        ),
                      );
                    }
                  ),
                  Row(
                    children: [
                      buildFieldTitle("Amount ", width),
                      SizedBox(width: width * 0.01,),
                      cubit.isAmountValid ?
                      SizedBox()
                          :Text("Required",style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,fontSize: 10 ),)
                    ],
                  ),


                  Builder(
                    key: descriptionKey,
                    builder: (context) {
                      return Container(
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
                       controller: cubit.amountcontroller,
                       keyboardType:  TextInputType.numberWithOptions(
                         decimal: false, // set true if you want decimal numbers
                         signed: false,  // set true if you want negative numbers
                       ),
                       inputFormatters: [
                         FilteringTextInputFormatter.digitsOnly, // ✅ Only allow digits
                       ],

                       decoration: InputDecoration(
                         contentPadding: EdgeInsets.symmetric(horizontal: 20),
                         border: InputBorder.none,
                       ),

                                       ),
                                     );
                    }
                  ),
                  Row(
                    children: [
                      buildFieldTitle("Job Description", width),
                      SizedBox(width: width * 0.01,),
                      cubit.isDescriptionValid ?
                      SizedBox()
                          :Text("Required",style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,fontSize: 10 ),)
                    ],
                  ),
                  Builder(
                    builder: (context) {
                      return Container(
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
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5), // ✅ adds space inside
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
                    child: Container(
                      width: 172,
                      height: 40,
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
                              fontSize: 16,
                              height: 1.5, // 150% line-height
                              letterSpacing: 0, // 0% letter-spacing
                            ),
                          )

                        )
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
Widget buildbox({ required String text,required Color color,required Color bordercolor,required Color textcolor}){
  return Container(

    width: 96,
    height: 41,
    decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: bordercolor
        )
    ),
    child: Center(child: Text(text,style: TextStyle(color:textcolor,fontFamily: 'Sora', fontWeight: FontWeight.w400,
    ),)),
  );

}
Widget buildField({ required String title, TextEditingController ? controller}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildFieldTitle(title, 400),  // pass width directly
        SizedBox(height: 8),
        Container(
          height: 50,
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
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
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
    return Row(
      children: [
        const Icon(Icons.access_time_rounded),
        const SizedBox(width: 4),
        Text(embedContext.node.value.data as String),
      ],
    );
  }

}