import 'package:anjalim/student_Section/custom_widgets/CustomDropdownform.dart';
import 'package:anjalim/student_Section/models_std/employee_Profile/skill/technicalSkills.dart';
import 'package:anjalim/student_Section/services/profile_update_searvices/skills.dart';
import 'package:anjalim/student_Section/student_blocs/technical_skill/technical_skill_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Technicalskill extends StatefulWidget {
  const Technicalskill({super.key});

  @override
  State<Technicalskill> createState() => _TechnicalskillState();
}

class _TechnicalskillState extends State<Technicalskill> {
  String? selectedSkill;
  String searchQuery = '';
  String? selectedLevel;
  late TechnicalSkillBloc _technicalSkillBloc;

  final Map<String, List<String>> categorizedSkills = {
    'Programming Languages': [
      'JavaScript',
      'TypeScript',
      'Python',
      'Java',
      'C#',
      'C++',
      'PHP',
      'Ruby',
      'Go',
      'Swift',
      'Kotlin',
      'Rust',
      'Dart',
    ],
    'Web Development Frameworks': [
      'React',
      'Angular',
      'Vue.js',
      'Django',
      'Flask',
      'Express',
      'Laravel',
      'Ruby on Rails',
      'Spring',
      'ASP.NET',
    ],
    'Database and Data Management': [
      'MySQL',
      'PostgreSQL',
      'MongoDB',
      'Redis',
      'Firebase',
      'SQLite',
      'Oracle',
      'Cassandra',
      'Elasticsearch',
    ],
    'DevOps and Cloud Tools': [
      'Docker',
      'Kubernetes',
      'AWS',
      'Azure',
      'Google Cloud',
      'Terraform',
      'Ansible',
      'Jenkins',
      'GitHub Actions',
      'CI/CD',
    ],
    'Cyber Security': [
      'OWASP',
      'Penetration Testing',
      'Ethical Hacking',
      'Cryptography',
      'Network Security',
    ],
    'Machine Learning and AI': [
      'TensorFlow',
      'PyTorch',
      'Keras',
      'Scikit-learn',
      'OpenCV',
      'NLP',
    ],
    'Mobile Development': [
      'Flutter',
      'React Native',
      'Android (Java/Kotlin)',
      'iOS (Swift)',
      'Xamarin',
    ],
    'Software Development Tools': [
      'Git',
      'GitHub',
      'GitLab',
      'Bitbucket',
      'JIRA',
      'Confluence',
      'VS Code',
      'IntelliJ IDEA',
    ],
    'Other Tools': [
      'Webpack',
      'Babel',
      'ESLint',
      'Prettier',
      'Gulp',
      'Grunt',
    ],
    'Libraries and Components': [
      'jQuery',
      'Lodash',
      'RxJS',
      'Axios',
      'Bootstrap',
      'Material-UI',
    ],
    'State Management': [
      'Redux',
      'MobX',
      'Context API',
      'NgRx',
      'Vuex',
      'Provider',
      'Bloc',
    ],
    'Testing Frameworks and Tools': [
      'Jest',
      'Mocha',
      'Jasmine',
      'Cypress',
      'Selenium',
      'JUnit',
      'pytest',
    ],
  };

  final List<String> levels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert',
  ];

  @override
  void initState() {
    super.initState();
    // Create the bloc instance and store reference
    _technicalSkillBloc = TechnicalSkillBloc(skillsService: SkillsService());
    // Load skills when widget initializes
    _technicalSkillBloc.add(LoadTechnicalSkills(context: context));
  }

  @override
  void dispose() {
    _technicalSkillBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _technicalSkillBloc,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: const Color(0xffF9F2ED),
          appBar: AppBar(
            backgroundColor: const Color(0xffF9F2ED),
            title: const Text(
              "Technical Skills",
              style: TextStyle(
                fontFamily: "Poppins",
                color: Color(0xff3F414E),
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocConsumer<TechnicalSkillBloc, TechnicalSkillState>(
              listener: (context, state) {
                if (state is TechnicalSkillError && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
                // Removed TechnicalSkillSuccess listener to avoid duplicate success messages
              },
              builder: (context, state) {
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    buildDropdownbuttonFormField(
                      value: selectedSkill,
                      items: getFilteredItems(),
                      onChanged: (value) {
                        setState(() {
                          selectedSkill = value;
                        });
                      },
                      labeltext: 'Select Skill',
                      validator: (value) {
                        if (value == null) return 'Please select a skill';
                        return null;
                      },
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
                        labelStyle: const TextStyle(fontFamily: "Poppins"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      onChanged: (value) =>
                          setState(() => selectedLevel = value),
                      validator: (value) {
                        if (value == null) return 'Please select your level';
                        return null;
                      },
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
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedSkill = null;
                              selectedLevel = null;
                            });
                            context
                                .read<TechnicalSkillBloc>()
                                .add(ResetTechnicalSkillForm());
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                                color: Colors.white, fontFamily: "Poppins"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            backgroundColor: const Color(0xff004673),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          onPressed: state is TechnicalSkillProcessing
                              ? null
                              : () {
                                  if (selectedSkill != null &&
                                      selectedLevel != null) {
                                    context.read<TechnicalSkillBloc>().add(
                                          AddTechnicalSkill(
                                            skill: selectedSkill!,
                                            level: selectedLevel!,
                                            context: context,
                                          ),
                                        );
                                    setState(() {
                                      selectedSkill = null;
                                      selectedLevel = null;
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Select both skill and level"),
                                        backgroundColor: Colors.orange,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                          child: state is TechnicalSkillProcessing
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Save',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Poppins"),
                                ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Expanded(
                      child: _buildSkillsList(state),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsList(TechnicalSkillState state) {
    if (state is TechnicalSkillLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading skills...')
          ],
        ),
      );
    } else if (state is TechnicalSkillError) {
      final skills = state.currentSkills ?? [];
      if (skills.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                'Error: ${state.message}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<TechnicalSkillBloc>()
                      .add(LoadTechnicalSkills(context: context));
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      } else {
        return _buildSkillsListView(skills, false);
      }
    } else if (state is TechnicalSkillLoaded ||
        state is TechnicalSkillProcessing ||
        state is TechnicalSkillSuccess) {
      final skills = state.skills ?? [];
      final isProcessing = state is TechnicalSkillProcessing;

      if (skills.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No skills added yet',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: "Poppins",
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Add your first skill above!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: "Poppins",
                ),
              ),
            ],
          ),
        );
      }

      return _buildSkillsListView(skills, isProcessing);
    } else {
      return const Center(
        child: Text(
          'Initializing...',
          style: TextStyle(fontFamily: "Poppins"),
        ),
      );
    }
  }

  Widget _buildSkillsListView(List<TechnicalSkills> skills, bool isProcessing) {
    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<TechnicalSkillBloc>()
            .add(LoadTechnicalSkills(context: context));
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: skills.length,
        itemBuilder: (context, index) {
          final techskill = skills[index];
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            child: ListTile(
              title: Text(
                techskill.skills,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  color: Color(0xff3F414E),
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    'Level: ${techskill.level}',
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              trailing: isProcessing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _showDeleteDialog(context, techskill),
                    ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showDeleteDialog(
      BuildContext context, TechnicalSkills techskill) async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          'Confirm Delete',
          style: TextStyle(
            fontFamily: "Poppins",
            color: Color(0xff3F414E),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${techskill.skills}"?',
          style: const TextStyle(
            fontFamily: "Poppins",
            color: Color(0xff3F414E),
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: "Poppins",
                color: Color(0xff3F414E),
                fontWeight: FontWeight.w400,
              ),
            ),
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          TextButton(
            child: const Text(
              'Delete',
              style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      context.read<TechnicalSkillBloc>().add(
            DeleteTechnicalSkill(
              id: techskill.id,
              context: context,
            ),
          );
    }
  }

  List<DropdownMenuItem<String>> getFilteredItems() {
    final allItems = <DropdownMenuItem<String>>[];

    // Add a search header
    allItems.add(
      DropdownMenuItem<String>(
        enabled: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search skills...',
              isDense: true,
              border: InputBorder.none,
              suffixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
            },
          ),
        ),
      ),
    );

    categorizedSkills.forEach((category, skills) {
      final filteredSkills = skills
          .where((skill) => skill.toLowerCase().contains(searchQuery))
          .toList();

      if (filteredSkills.isNotEmpty) {
        // Add category header
        allItems.add(
          DropdownMenuItem<String>(
            enabled: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                category,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        );

        // Add skills under category
        allItems.addAll(
          filteredSkills
              .map((skill) => DropdownMenuItem<String>(
                    value: skill,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(skill),
                    ),
                  ))
              .toList(),
        );
      }
    });

    return allItems;
  }
}
