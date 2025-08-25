import 'package:anjalim/student_Section/custom_widgets/CustomTextField.dart';
import 'package:anjalim/student_Section/custom_widgets/calender.dart';
import 'package:anjalim/student_Section/student_blocs/std_wrk_experience/experience_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ExperinceScreen extends StatefulWidget {
  const ExperinceScreen({super.key});

  @override
  State<ExperinceScreen> createState() => _ExperinceScreenState();
}

class _ExperinceScreenState extends State<ExperinceScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedExperience;
  TextEditingController companyName = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endtDate = TextEditingController();
  String? selectedJobTitle;
  bool isWorking = false;
  String experienceDuration = '';

  // Search functionality variables
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  bool isSearching = false;
  List<Map<String, String>> filteredJobTitles = [];

  @override
  void initState() {
    super.initState();
    // Load job titles when screen initializes
    context.read<ExperienceBloc>().add(LoadJobTitles());
  }

  @override
  void dispose() {
    companyName.dispose();
    startDate.dispose();
    endtDate.dispose();
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  // void _filterJobTitles(String query, List<Map<String, String>> allJobTitles) {
  //   setState(() {
  //     if (query.isEmpty) {
  //       // Remove duplicates by converting to Set and back to List
  //       final uniqueJobTitles = <String, Map<String, String>>{};
  //       for (var job in allJobTitles) {
  //         uniqueJobTitles[job['value']!] = job;
  //       }
  //       filteredJobTitles = uniqueJobTitles.values.toList();
  //       isSearching = false;
  //     } else {
  //       final filtered = allJobTitles.where((job) {
  //         return job['label']!.toLowerCase().contains(query.toLowerCase());
  //       }).toList();

  //       // Remove duplicates from filtered results
  //       final uniqueFiltered = <String, Map<String, String>>{};
  //       for (var job in filtered) {
  //         uniqueFiltered[job['value']!] = job;
  //       }
  //       filteredJobTitles = uniqueFiltered.values.toList();
  //       isSearching = true;
  //     }
  //   });
  // }

  void _handleCurrentlyWorking(bool? value) {
    if (value == null) return;

    setState(() {
      isWorking = value;
      if (isWorking) {
        final now = DateTime.now();
        endtDate.text = DateFormat('yyyy-MM-dd').format(now);
        calculateExperience();
      }
    });
  }

  void calculateExperience() {
    if (startDate.text.isEmpty) return;

    try {
      final start = DateFormat('yyyy-MM-dd').parse(startDate.text);
      DateTime end = isWorking
          ? DateTime.now()
          : (endtDate.text.isEmpty
              ? DateTime.now()
              : DateFormat('yyyy-MM-dd').parse(endtDate.text));

      if (end.isBefore(start)) {
        setState(() => experienceDuration = 'Invalid date range');
        return;
      }

      final totalDays = end.difference(start).inDays;

      if (totalDays < 30) {
        setState(() => experienceDuration = 'Below one month');
        return;
      }

      final years = totalDays ~/ 365;
      final months = (totalDays % 365) ~/ 30;

      final parts = <String>[];
      if (years > 0) parts.add('$years year${years != 1 ? 's' : ''}');
      if (months > 0) parts.add('$months month${months != 1 ? 's' : ''}');

      setState(() {
        experienceDuration =
            parts.isEmpty ? 'Below one month' : parts.join(', ');
      });
    } catch (e) {
      setState(() => experienceDuration = 'Error calculating experience');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffF9F2ED),
      appBar: AppBar(
        backgroundColor: const Color(0xffF9F2ED),
        title: const Text(
          "Add Your Experience",
          style: TextStyle(
            fontFamily: "Poppin",
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xff3F414E),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<ExperienceBloc, ExperienceState>(
          listener: (context, state) {
            if (state is ExperienceError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is ExperienceAdded) {
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Experience added successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              // Navigate back with success result
              Navigator.pop(context, true);
            }
          },
          builder: (context, state) {
            final size = MediaQuery.of(context).size;
            final padding = size.width * 0.05; // 5% horizontal padding
            final spacing = size.height * 0.02; // 2% vertical spacing
            if (state is ExperienceLoading && _formKey.currentState == null) {
              return const Center(child: CircularProgressIndicator());
            }

            List<Map<String, String>> jobTitles = [];
            if (state is JobTitlesLoaded) {
              // Remove duplicates from the original job titles
              final uniqueJobTitles = <String, Map<String, String>>{};
              for (var job in state.jobTitles) {
                uniqueJobTitles[job['value']!] = job;
              }
              jobTitles = uniqueJobTitles.values.toList();

              if (filteredJobTitles.isEmpty) {
                filteredJobTitles = jobTitles;
              }
            }

            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: padding,
                right: padding,
                bottom: MediaQuery.of(context).viewInsets.bottom + spacing,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel("Job Title"),
                    _buildSearchableDropdown(jobTitles, state),
                    const SizedBox(height: 15),
                    _buildSectionLabel("Select / Enter your company name"),
                    CustomTextField(
                      controller: companyName,
                      hintText: "Enter your company name",
                    ),
                    _buildSectionLabel("Start Date"),
                    CalendarInputField(
                      controller: startDate,
                      hintText: 'Select start date',
                      onDateSelected: calculateExperience,
                    ),
                    _buildSectionLabel("End Date"),
                    AbsorbPointer(
                      absorbing: isWorking,
                      child: CalendarInputField(
                        controller: endtDate,
                        hintText: 'Select end date',
                        onDateSelected: calculateExperience,
                        enabled: !isWorking,
                        // validator: (value) {
                        //   if (!isWorking && (value == null || value.isEmpty)) {
                        //     return 'End date is required';
                        //   }
                        //   return null;
                        // },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text("I currently work here"),
                        const SizedBox(width: 8),
                        Checkbox(
                          onChanged: _handleCurrentlyWorking,
                          value: isWorking,
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                        ),
                      ],
                    ),
                    if (experienceDuration.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.timer, color: Colors.blue.shade600),
                            const SizedBox(width: 8),
                            Text(
                              'Duration: $experienceDuration',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            backgroundColor: const Color(0xffFF9500),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Update the Save button onPressed in your ExperinceScreen:

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff004673)),
                          onPressed: state is ExperienceLoading
                              ? null
                              : () {
                                  // Debug: Print all form data before validation

                                  if (_formKey.currentState!.validate()) {
                                    if (selectedJobTitle == null ||
                                        selectedJobTitle!.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please select a job title')),
                                      );
                                      return;
                                    }

                                    if (companyName.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please enter company name')),
                                      );
                                      return;
                                    }

                                    if (startDate.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please select start date')),
                                      );
                                      return;
                                    }

                                    if (!isWorking && endtDate.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please select end date or mark as currently working')),
                                      );
                                      return;
                                    }

                                    // All validations passed, proceed with adding experience

                                    context.read<ExperienceBloc>().add(
                                          AddExperience(
                                            companyName:
                                                companyName.text.trim(),
                                            jobTitle: selectedJobTitle!,
                                            startDate: startDate.text.trim(),
                                            endDate: isWorking
                                                ? ''
                                                : endtDate.text.trim(),
                                            isWorking: isWorking,
                                          ),
                                        );
                                  } else {}
                                },
                          child: state is ExperienceLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text("Save",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchableDropdown(
      List<Map<String, String>> jobTitles, ExperienceState state) {
    return _buildDropdownbuttonFormField(
      value: selectedJobTitle,
      items: [
        // Search field as the first item
        // DropdownMenuItem<String>(
        //   enabled: false,
        //   value: '__search__',
        //   child: Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 8),
        //     child: TextFormField(
        //       controller: searchController,
        //       focusNode: searchFocusNode,
        //       decoration: InputDecoration(
        //         hintText: 'Search job titles...',
        //         border: InputBorder.none,
        //         suffixIcon: searchController.text.isNotEmpty
        //             ? IconButton(
        //                 icon: const Icon(Icons.clear, size: 18),
        //                 onPressed: () {
        //                   searchController.clear();
        //                   _filterJobTitles('', jobTitles);
        //                 },
        //               )
        //             : null,
        //       ),
        //       onChanged: (value) {
        //         _filterJobTitles(value, jobTitles);
        //       },
        //     ),
        //   ),
        // ),
        // Divider
        // const DropdownMenuItem<String>(
        //   enabled: false,
        //   value: '__divider__',
        //   child: Divider(height: 1),
        // ),
        // Loading state
        if (state is JobTitlesLoading)
          DropdownMenuItem<String>(
            enabled: false,
            value: '__loading__',
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              child: const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        // Error state
        if (state is ExperienceError)
          DropdownMenuItem<String>(
            enabled: false,
            value: '__error__',
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              child: Text(
                'Failed to load job titles',
                style: TextStyle(color: Colors.red.shade600),
              ),
            ),
          ),
        // Empty state
        if (filteredJobTitles.isEmpty && state is! JobTitlesLoading)
          DropdownMenuItem<String>(
            enabled: false,
            value: '__empty__',
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              child: const Text(
                'No job titles found',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        // Job title items
        ...filteredJobTitles.map((job) {
          return DropdownMenuItem<String>(
            value: job['value'],
            child: Text(
              job['label']!,
              style: const TextStyle(
                fontFamily: "Poppins",
                color: Color(0xff3F414E),
              ),
            ),
          );
        }).toList(),
      ],
      onChanged: (newValue) {
        if (newValue == null ||
            newValue == '__search__' ||
            newValue == '__divider__' ||
            newValue == '__loading__' ||
            newValue == '__error__' ||
            newValue == '__empty__') {
          return;
        }

        setState(() {
          selectedJobTitle = newValue as String;
          // Find and set the selected job title in search field for better UX
          final selectedJob = jobTitles.firstWhere(
            (job) => job['value'] == selectedJobTitle,
            orElse: () => {'label': '', 'value': ''},
          );
          if (selectedJob['label']!.isNotEmpty) {
            searchController.text = selectedJob['label']!;
          }
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a job title';
        }
        return null;
      },
      labeltext: 'Select your Job Title',
      state: state,
    );
  }

  Widget _buildDropdownbuttonFormField({
    required String? value,
    required List<DropdownMenuItem<String>>? items,
    required ValueChanged<String?> onChanged,
    required String labeltext,
    required String? Function(String? value) validator,
    required ExperienceState state,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: labeltext,
        labelStyle: const TextStyle(
          fontFamily: "Poppins",
          color: Color(0xff3F414E),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xffE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xffE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xff004673)),
        ),
        filled: true,
        fillColor: const Color(0xffF9F2ED),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      dropdownColor: const Color(0xffF9F2ED),
      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xff3F414E)),
      style: const TextStyle(
        fontFamily: "Poppins",
        color: Color(0xff3F414E),
        fontSize: 16,
      ),
      menuMaxHeight: 300,
      onTap: () {
        // Focus on search field when dropdown is opened
        if (searchFocusNode.canRequestFocus) {
          searchFocusNode.requestFocus();
        }
      },
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: Color(0xff3F414E)),
      ),
    );
  }
}
