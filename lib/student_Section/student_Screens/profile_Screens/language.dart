import 'package:anjalim/student_Section/models_std/employee_Profile/language_model.dart';
import 'package:anjalim/student_Section/services/profile_update_searvices/language_repository.dart';
import 'package:anjalim/student_Section/student_blocs/std_Language/language_bloc.dart';
import 'package:anjalim/student_Section/student_blocs/std_Language/language_event.dart';
import 'package:anjalim/student_Section/student_blocs/std_Language/language_state.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_picker/languages.g.dart';

class LanguageDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LanguageBloc(LanguageRepository())..add(FetchLanguages()),
      child: _LanguageDropdownContent(),
    );
  }
}

class _LanguageDropdownContent extends StatefulWidget {
  @override
  _LanguageDropdownContentState createState() =>
      _LanguageDropdownContentState();
}

class _LanguageDropdownContentState extends State<_LanguageDropdownContent> {
  late List<String> languagesList;
  String? selectedLanguage;
  String? selectedLevel;

  final List<String> levels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert',
    'Native',
  ];

  final Map<String, int> levelPercent = {
    'Beginner': 20,
    'Intermediate': 40,
    'Advanced': 60,
    'Expert': 80,
    'Native': 100,
  };

  @override
  void initState() {
    super.initState();
    languagesList =
        Languages.defaultLanguages.map((lang) => lang.name).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F2ED),
      appBar: AppBar(
        backgroundColor: const Color(0xffF9F2ED),
        title: Text(
          "Select Language",
          style: TextStyle(
            fontFamily: "Poppins",
            color: Color(0xff3F414E),
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: BlocConsumer<LanguageBloc, LanguageState>(
        listener: (context, state) {
          if (state is LanguageError) {
            // Show error only in SnackBar, not in dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error: ${state.message}"),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
            // Still refresh to show current state from backend
            Future.delayed(Duration(milliseconds: 1000), () {
              context.read<LanguageBloc>().add(FetchLanguages());
            });
          } else if (state is LanguageActionSuccess) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("✓ ${state.message}"),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            // Refresh the languages list after success
            Future.delayed(Duration(milliseconds: 500), () {
              context.read<LanguageBloc>().add(FetchLanguages());
            });
          }
        },
        builder: (context, state) {
          // Only show language skills from backend, no error handling in UI
          List<LanguageSkill> languages = <LanguageSkill>[];

          if (state is LanguageLoaded) {
            languages = List<LanguageSkill>.from(state.languages);
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                DropdownSearch<String>(
                  items: (filter, loadProps) => languagesList,
                  selectedItem: selectedLanguage,
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: "Search your language...",
                        hintStyle: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  decoratorProps: DropDownDecoratorProps(
                    baseStyle: TextStyle(
                      fontFamily: "Poppins",
                    ),
                    decoration: InputDecoration(
                      labelText: "Select a language",
                      labelStyle: const TextStyle(
                        fontFamily: "Poppins",
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                  onChanged: (value) =>
                      setState(() => selectedLanguage = value),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedLevel,
                  items: levels
                      .map((level) => DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: "Select Level",
                    labelStyle: const TextStyle(
                      fontFamily: "Poppins",
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onChanged: (value) => setState(() => selectedLevel = value),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: const Color(0xffFF9500),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: Colors.white, fontFamily: "Poppins"),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Color(0xff004673),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                      onPressed: () async {
                        if (selectedLanguage != null && selectedLevel != null) {
                          // Add the language
                          context.read<LanguageBloc>().add(
                              AddLanguage(selectedLanguage!, selectedLevel!));

                          // Clear the form immediately
                          setState(() {
                            selectedLanguage = null;
                            selectedLevel = null;
                          });

                          // Show saving message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Saving language...",
                                style: TextStyle(color: Colors.black),
                              ),
                              backgroundColor: Colors.white,
                              duration: Duration(seconds: 1),
                            ),
                          );

                          // Wait a bit then refresh
                          await Future.delayed(Duration(milliseconds: 500));
                          context.read<LanguageBloc>().add(FetchLanguages());
                        } else {
                          // Show validation error in SnackBar instead of dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text("Please select both Language and Level"),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                            color: Colors.white, fontFamily: "Poppins"),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Language Skills",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xff3F414E),
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      )),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _buildLanguageList(context, languages),
                ),
                if (state is LanguageLoading)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguageList(
      BuildContext context, List<LanguageSkill> languages) {
    if (languages.isEmpty) {
      return Center(
        child: Text(
          "No languages added yet",
          style: TextStyle(
            fontFamily: "Poppins",
            color: Color(0xff3F414E),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: languages.length,
      itemBuilder: (context, index) {
        final lang = languages[index];
        final percent = levelPercent[lang.level] ?? 0;
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              lang.language,
              style: TextStyle(
                fontFamily: "Poppins",
                color: Color(0xff3F414E),
                fontWeight: FontWeight.w400,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lang.level),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: percent / 100,
                  color: Colors.green,
                  backgroundColor: Colors.grey[300],
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.cancel_outlined, color: Colors.red),
              onPressed: () => _showDeleteDialog(context, lang.id),
            ),
          ),
        );
      },
    );
  }

  // Removed _showErrorDialog method since we're using SnackBar for all errors

  Future<void> _showDeleteDialog(BuildContext context, int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm Delete',
          style: TextStyle(
            fontFamily: "Poppins",
            color: Color(0xff3F414E),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this language?',
          style: TextStyle(
            fontFamily: "Poppins",
            color: Color(0xff3F414E),
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text(
              'Delete',
              style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Delete the language and let BlocConsumer handle the response
      context.read<LanguageBloc>().add(DeleteLanguage(id));
    }
  }
}
