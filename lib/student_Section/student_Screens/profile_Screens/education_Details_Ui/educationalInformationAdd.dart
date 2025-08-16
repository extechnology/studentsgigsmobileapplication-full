import 'package:anjalim/student_Section/student_blocs/education_section_std/education_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EducationAddPage extends StatefulWidget {
  const EducationAddPage({Key? key}) : super(key: key);

  @override
  State<EducationAddPage> createState() => _EducationAddPageState();
}

class _EducationAddPageState extends State<EducationAddPage> {
  String? selectedAcademicLevel;
  String? selectedFieldOfStudy;
  String? selectedUniversity;
  String? selectedGraduationYear;
  final TextEditingController _newAchievementController =
      TextEditingController();
  final TextEditingController _universityController = TextEditingController();

  bool _hasLoadedFields = false;
  @override
  void initState() {
    super.initState();
    // Load fields of study when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<EducationBloc>().add(LoadFieldsOfStudy());
      }
    });
  }

  final List<Map<String, String>> educationLevels = [
    {"label": "No Formal Education", "value": "No Formal Education"},
    {"label": "Primary Education", "value": "Primary Education"},
    {
      "label": "Lower Secondary Education (Middle School)",
      "value": "Lower Secondary Education (Middle School)"
    },
    {
      "label": "Upper Secondary Education (High School)",
      "value": "Upper Secondary Education (High School)"
    },
    {"label": "High School Diploma", "value": "High School Diploma"},
    {
      "label": "General Educational Development (GED)",
      "value": "General Educational Development (GED)"
    },
    {"label": "Diploma", "value": "Diploma"},
    {"label": "Certificate", "value": "Certificate"},
    {
      "label": "Post-secondary Certificate",
      "value": "Post-secondary Certificate"
    },
    {"label": "Associate Degree", "value": "Associate Degree"},
    {"label": "Associate of Arts (A.A.)", "value": "Associate of Arts (A.A.)"},
    {
      "label": "Associate of Science (A.S.)",
      "value": "Associate of Science (A.S.)"
    },
    {
      "label": "Associate of Applied Science (A.A.S.)",
      "value": "Associate of Applied Science (A.A.S.)"
    },
    {"label": "Bachelor's Degree", "value": "Bachelor's Degree"},
    {"label": "Bachelor of Arts (B.A.)", "value": "Bachelor of Arts (B.A.)"},
    {
      "label": "Bachelor of Science (B.Sc.)",
      "value": "Bachelor of Science (B.Sc.)"
    },
    {
      "label": "Bachelor of Technology (B.Tech)",
      "value": "Bachelor of Technology (B.Tech)"
    },
    {
      "label": "Bachelor of Engineering (B.E.)",
      "value": "Bachelor of Engineering (B.E.)"
    },
    {
      "label": "Bachelor of Business Administration (BBA)",
      "value": "Bachelor of Business Administration (BBA)"
    },
    {
      "label": "Bachelor of Commerce (B.Com)",
      "value": "Bachelor of Commerce (B.Com)"
    },
    {"label": "Bachelor of Laws (LL.B.)", "value": "Bachelor of Laws (LL.B.)"},
    {
      "label": "Bachelor of Education (B.Ed.)",
      "value": "Bachelor of Education (B.Ed.)"
    },
    {
      "label": "Bachelor of Medicine, Bachelor of Surgery (MBBS)",
      "value": "Bachelor of Medicine, Bachelor of Surgery (MBBS)"
    },
    {
      "label": "Bachelor of Fine Arts (BFA)",
      "value": "Bachelor of Fine Arts (BFA)"
    },
    {"label": "Master's Degree", "value": "Master's Degree"},
    {"label": "Master of Arts (M.A.)", "value": "Master of Arts (M.A.)"},
    {
      "label": "Master of Science (M.Sc.)",
      "value": "Master of Science (M.Sc.)"
    },
    {
      "label": "Master of Technology (M.Tech)",
      "value": "Master of Technology (M.Tech)"
    },
    {
      "label": "Master of Engineering (M.E.)",
      "value": "Master of Engineering (M.E.)"
    },
    {
      "label": "Master of Business Administration (MBA)",
      "value": "Master of Business Administration (MBA)"
    },
    {"label": "Master of Laws (LL.M.)", "value": "Master of Laws (LL.M.)"},
    {
      "label": "Master of Education (M.Ed.)",
      "value": "Master of Education (M.Ed.)"
    },
    {
      "label": "Master of Social Work (MSW)",
      "value": "Master of Social Work (MSW)"
    },
    {
      "label": "Master of Fine Arts (MFA)",
      "value": "Master of Fine Arts (MFA)"
    },
    {
      "label": "Master of Public Administration (MPA)",
      "value": "Master of Public Administration (MPA)"
    },
    {
      "label": "Master of Public Health (MPH)",
      "value": "Master of Public Health (MPH)"
    },
    {"label": "Doctorate (Ph.D.)", "value": "Doctorate (Ph.D.)"},
    {"label": "Doctor of Medicine (MD)", "value": "Doctor of Medicine (MD)"},
    {
      "label": "Doctor of Business Administration (DBA)",
      "value": "Doctor of Business Administration (DBA)"
    },
    {
      "label": "Doctor of Education (Ed.D.)",
      "value": "Doctor of Education (Ed.D.)"
    },
    {
      "label": "Doctor of Pharmacy (Pharm.D.)",
      "value": "Doctor of Pharmacy (Pharm.D.)"
    },
    {
      "label": "Doctor of Law (Juris Doctor - JD)",
      "value": "Doctor of Law (Juris Doctor - JD)"
    },
    {
      "label": "Doctor of Dental Surgery (DDS)",
      "value": "Doctor of Dental Surgery (DDS)"
    },
    {
      "label": "Doctor of Veterinary Medicine (DVM)",
      "value": "Doctor of Veterinary Medicine (DVM)"
    },
    {
      "label": "Doctor of Public Health (DrPH)",
      "value": "Doctor of Public Health (DrPH)"
    },
    {"label": "Postdoctoral Studies", "value": "Postdoctoral Studies"},
    {"label": "Vocational Training", "value": "Vocational Training"},
    {
      "label": "Professional Certification",
      "value": "Professional Certification"
    },
    {
      "label": "Trade School Certification",
      "value": "Trade School Certification"
    },
    {"label": "Apprenticeship", "value": "Apprenticeship"},
  ];

  final List<String> years =
      List.generate(15, (index) => (2025 + index).toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F2ED),
      appBar: AppBar(
        title: const Text('Add Education'),
        backgroundColor: const Color(0xffF9F2ED),
      ),
      body: BlocConsumer<EducationBloc, EducationState>(
        listener: (context, state) {
          if (state is EducationOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context, true); // Return true to indicate success
          } else if (state is EducationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Educational Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // Academic Level
                DropdownButtonFormField<String>(
                  value: selectedAcademicLevel,
                  items: educationLevels
                      .map(
                        (level) => DropdownMenuItem<String>(
                          value: level['value'],
                          child: Text(
                            level['label']!,
                            overflow: TextOverflow
                                .ellipsis, // Add ellipsis for overflow
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) =>
                      setState(() => selectedAcademicLevel = val),
                  decoration: const InputDecoration(
                    labelText: "Select Your Academic Level",
                    border: OutlineInputBorder(),
                  ),
                  isExpanded:
                      true, // Add this to make the dropdown take full width
                ),
                const SizedBox(height: 16),

                // Field of Study
                //_buildFieldOfStudyDropdown(state),

                if (state is FieldsOfStudyLoaded)
                  DropdownButtonFormField<String>(
                    value: selectedFieldOfStudy,
                    items: state.fields
                        .map(
                          (field) => DropdownMenuItem<String>(
                            value: field,
                            child: Text(field),
                          ),
                        )
                        .toList(),
                    onChanged: (val) =>
                        setState(() => selectedFieldOfStudy = val),
                    decoration: const InputDecoration(
                      labelText: "Select Your Field of Study",
                      border: OutlineInputBorder(),
                    ),
                  )
                else if (state is EducationLoading)
                  const TextField(
                    decoration: InputDecoration(
                      labelText: "Loading fields of study...",
                      border: OutlineInputBorder(),
                    ),
                    enabled: false,
                  )
                else if (state is EducationError)
                  Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Error loading fields: ${state.message}",
                          border: const OutlineInputBorder(),
                        ),
                        enabled: false,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (mounted) {
                            context
                                .read<EducationBloc>()
                                .add(LoadFieldsOfStudy());
                          }
                        },
                        child: const Text("Retry Loading Fields"),
                      ),
                    ],
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      if (mounted) {
                        context.read<EducationBloc>().add(LoadFieldsOfStudy());
                      }
                    },
                    child: const Text("Load Fields of Study"),
                  ),
                const SizedBox(height: 16),

                // University Search
                TextField(
                  controller: _universityController,
                  decoration: InputDecoration(
                    labelText: "Search Your University",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        if (_universityController.text.length >= 2 && mounted) {
                          context.read<EducationBloc>().add(
                                SearchUniversities(_universityController.text),
                              );
                        }
                      },
                    ),
                  ),
                  onChanged: (value) {
                    if (value.length >= 2 && mounted) {
                      context
                          .read<EducationBloc>()
                          .add(SearchUniversities(value));
                    }
                  },
                ),
                const SizedBox(height: 8),

                // University Results
                if (state is UniversitiesLoaded &&
                    state.universities.isNotEmpty)
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.universities.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.universities[index]),
                          onTap: () {
                            setState(() {
                              selectedUniversity = state.universities[index];
                              _universityController.text = selectedUniversity!;
                            });
                          },
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 16),

                // Graduation Year
                DropdownButtonFormField<String>(
                  value: selectedGraduationYear,
                  items: years
                      .map(
                        (year) => DropdownMenuItem<String>(
                          value: year,
                          child: Text(year),
                        ),
                      )
                      .toList(),
                  onChanged: (val) =>
                      setState(() => selectedGraduationYear = val),
                  decoration: const InputDecoration(
                    labelText: "Expected Year of Graduation",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Achievement
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Add Achievement (Optional)",
                    border: OutlineInputBorder(),
                  ),
                  controller: _newAchievementController,
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: state is EducationLoading
                          ? null
                          : () {
                              if (selectedFieldOfStudy == null ||
                                  selectedFieldOfStudy!.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Please select field of study')),
                                );
                                return;
                              }

                              if (selectedUniversity == null ||
                                  selectedUniversity!.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Please select university')),
                                );
                                return;
                              }

                              if (selectedGraduationYear == null ||
                                  selectedGraduationYear!.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please select graduation year')),
                                );
                                return;
                              }

                              if (selectedAcademicLevel == null ||
                                  selectedAcademicLevel!.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Please select academic level')),
                                );
                                return;
                              }

                              if (mounted) {
                                context.read<EducationBloc>().add(
                                      AddEducationDetail(
                                        fieldOfStudy: selectedFieldOfStudy!,
                                        institution: selectedUniversity!,
                                        graduationYear: selectedGraduationYear!,
                                        academicLevel: selectedAcademicLevel!,
                                        achievement:
                                            _newAchievementController.text,
                                      ),
                                    );
                              }
                            },
                      child: state is EducationLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFieldOfStudyDropdown(EducationState state) {
    if (state is FieldsOfStudyLoaded) {
      return DropdownButtonFormField<String>(
        isExpanded: true,
        value: selectedFieldOfStudy,
        items: state.fields
            .map(
              (field) => DropdownMenuItem<String>(
                  value: field,
                  child: Text(
                    field,
                    overflow: TextOverflow.ellipsis,
                  )),
            )
            .toList(),
        onChanged: (val) => setState(() => selectedFieldOfStudy = val),
        decoration: const InputDecoration(
          labelText: "Select Your Field of Study",
          border: OutlineInputBorder(),
        ),
      );
    } else if (state is EducationLoading) {
      return const TextField(
        decoration: InputDecoration(
          labelText: "Loading fields of study...",
          border: OutlineInputBorder(),
        ),
        enabled: false,
      );
    } else if (state is EducationError) {
      return Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: "Error loading fields: ${state.message}",
              border: const OutlineInputBorder(),
            ),
            enabled: false,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              if (mounted) {
                context.read<EducationBloc>().add(LoadFieldsOfStudy());
              }
            },
            child: const Text("Retry Loading Fields"),
          ),
        ],
      );
    } else {
      // Initial state - show loading or empty state
      return const TextField(
        decoration: InputDecoration(
          labelText: "Loading fields...",
          border: OutlineInputBorder(),
        ),
        enabled: false,
      );
    }
  }

  @override
  void dispose() {
    _newAchievementController.dispose();
    _universityController.dispose();
    super.dispose();
  }
}
