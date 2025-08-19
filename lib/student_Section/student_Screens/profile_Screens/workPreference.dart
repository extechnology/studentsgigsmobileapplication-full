import 'package:anjalim/student_Section/custom_widgets/CustomDropdownform.dart';
import 'package:anjalim/student_Section/custom_widgets/CustomTextField.dart';
import 'package:anjalim/student_Section/student_blocs/work_preference/work_preference_bloc.dart';
import 'package:anjalim/student_Section/student_blocs/work_preference/work_preference_event.dart';
import 'package:anjalim/student_Section/student_blocs/work_preference/work_preference_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StudentWorkPreference extends StatelessWidget {
  final TextEditingController payRangeController = TextEditingController();

  StudentWorkPreference({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkPreferenceBloc(const FlutterSecureStorage())
        ..add(FetchWorkPreference()),
      child: BlocConsumer<WorkPreferenceBloc, WorkPreferenceState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red),
            );
          }
          if (state.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Preferences updated successfully!'),
                  backgroundColor: Colors.green),
            );
          }
          if (state.salaryRange != null) {
            payRangeController.text = state.salaryRange!;
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xffF9F2ED),
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios),
              ),
              backgroundColor: const Color(0xffF9F2ED),
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Work Preference",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Color(0xff3F414E)),
                  ),
                  SizedBox(width: 8),
                  Icon(CupertinoIcons.briefcase,
                      color: Color(0xff004673), size: 28)
                ],
              ),
            ),
            body: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel("Interested Job Type"),
                        buildDropdownbuttonFormField(
                          value: _getValidDropdownValue(state.selectedJobType,
                              ["Online", "Offline", "Both"]),
                          items: ["Online", "Offline", "Both"].map((jobtype) {
                            return DropdownMenuItem<String>(
                                value: jobtype, child: Text(jobtype));
                          }).toList(),
                          onChanged: (value) {
                            context.read<WorkPreferenceBloc>().emit(
                                  state.copyWith(selectedJobType: value),
                                );
                          },
                          labeltext: 'Job Type',
                          validator: (value) =>
                              value == null ? 'Please select job type' : null,
                        ),
                        _buildSectionLabel("Transportation Availability"),
                        buildDropdownbuttonFormField(
                          value: _getValidDropdownValue(
                              state.selectedTransportationType,
                              ["Own Vehicle", "Public Transport", "None"]),
                          items: ["Own Vehicle", "Public Transport", "None"]
                              .map((t) {
                            return DropdownMenuItem<String>(
                                value: t, child: Text(t));
                          }).toList(),
                          onChanged: (value) {
                            context.read<WorkPreferenceBloc>().emit(
                                  state.copyWith(
                                      selectedTransportationType: value),
                                );
                          },
                          labeltext: 'Transportation',
                          validator: (value) => value == null
                              ? 'Please select transportation'
                              : null,
                        ),
                        _buildSectionLabel("Availability"),
                        buildDropdownbuttonFormField(
                          value: _getValidDropdownValue(
                              state.selectedAvailability, [
                            "Hourly Rate",
                            "All-Day Gigs",
                            "Weekend Gigs",
                            "Vacation Gigs",
                            "Project Based"
                          ]),
                          items: [
                            "Hourly Rate",
                            "All-Day Gigs",
                            "Weekend Gigs",
                            "Vacation Gigs",
                            "Project Based"
                          ].map((a) {
                            return DropdownMenuItem<String>(
                                value: a, child: Text(a));
                          }).toList(),
                          onChanged: (value) {
                            context.read<WorkPreferenceBloc>().emit(
                                  state.copyWith(
                                      selectedAvailability: value as String?),
                                );
                          },
                          labeltext: 'Availability',
                          validator: (value) => value == null
                              ? 'Please select availability'
                              : null,
                        ),
                        _buildSectionLabel("Expected Pay Range"),
                        CustomTextField(
                          hintText: "5000",
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          controller: payRangeController,
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: SizedBox(
                            width: 107,
                            height: 56,
                            child: FloatingActionButton(
                              onPressed: () {
                                context.read<WorkPreferenceBloc>().add(
                                      UpdateWorkPreference(
                                        jobType: state.selectedJobType ?? '',
                                        salaryRange: payRangeController.text,
                                        availability:
                                            state.selectedAvailability,
                                        transportation:
                                            state.selectedTransportationType,
                                      ),
                                    );
                              },
                              backgroundColor: const Color(0xff004673),
                              child: const Text("Save",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colors.white,
                                      fontSize: 16)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  // Helper method to ensure dropdown value is valid
  String? _getValidDropdownValue(
      String? currentValue, List<String> validItems) {
    if (currentValue == null || currentValue.isEmpty) {
      return null;
    }

    // Check if the current value exists in the valid items list
    if (validItems.contains(currentValue)) {
      return currentValue;
    }

    // If not found, return null to show no selection
    return null;
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Color(0xff3F414E),
        ),
      ),
    );
  }
}
