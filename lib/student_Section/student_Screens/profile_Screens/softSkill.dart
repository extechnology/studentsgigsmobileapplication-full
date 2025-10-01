import 'package:anjalim/student_Section/services/profile_update_searvices/soft_skill.dart';
import 'package:anjalim/student_Section/student_blocs/soft_skill/soft_skill_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SoftSkillScreen extends StatefulWidget {
  const SoftSkillScreen({super.key});

  @override
  State<SoftSkillScreen> createState() => _SoftSkillScreenState();
}

class _SoftSkillScreenState extends State<SoftSkillScreen> {
  final SoftSkillsService _softSkillsService = SoftSkillsService();

  final List<Skill> allSkills = [
    // Communication Skills
    Skill(
        label: "Verbal Communication",
        value: "verbal_communication",
        category: "Communication"),
    Skill(
        label: "Written Communication",
        value: "written_communication",
        category: "Communication"),
    Skill(
        label: "Public Speaking",
        value: "public_speaking",
        category: "Communication"),
    Skill(
        label: "Active Listening",
        value: "active_listening",
        category: "Communication"),
    Skill(
        label: "Nonverbal Communication",
        value: "nonverbal_communication",
        category: "Communication"),
    Skill(
        label: "Presentation Skills",
        value: "presentation_skills",
        category: "Communication"),
    Skill(
        label: "Storytelling",
        value: "storytelling",
        category: "Communication"),
    Skill(
        label: "Negotiation", value: "negotiation", category: "Communication"),

    // Leadership and Management
    Skill(
        label: "Team Leadership",
        value: "team_leadership",
        category: "Leadership and Management"),
    Skill(
        label: "Strategic Thinking",
        value: "strategic_thinking",
        category: "Leadership and Management"),
    Skill(
        label: "Decision Making",
        value: "decision_making",
        category: "Leadership and Management"),
    Skill(
        label: "Delegation",
        value: "delegation",
        category: "Leadership and Management"),
    Skill(
        label: "Conflict Resolution",
        value: "conflict_resolution",
        category: "Leadership and Management"),
    Skill(
        label: "Mentoring",
        value: "mentoring",
        category: "Leadership and Management"),
    Skill(
        label: "Motivating Others",
        value: "motivating_others",
        category: "Leadership and Management"),
    Skill(
        label: "Change Management",
        value: "change_management",
        category: "Leadership and Management"),

    // Problem Solving and Critical Thinking
    Skill(
        label: "Analytical Thinking",
        value: "analytical_thinking",
        category: "Problem Solving and Critical Thinking"),
    Skill(
        label: "Creativity",
        value: "creativity",
        category: "Problem Solving and Critical Thinking"),
    Skill(
        label: "Innovation",
        value: "innovation",
        category: "Problem Solving and Critical Thinking"),
    Skill(
        label: "Research Skills",
        value: "research_skills",
        category: "Problem Solving and Critical Thinking"),
    Skill(
        label: "Troubleshooting",
        value: "troubleshooting",
        category: "Problem Solving and Critical Thinking"),
    Skill(
        label: "Logical Reasoning",
        value: "logical_reasoning",
        category: "Problem Solving and Critical Thinking"),
    Skill(
        label: "Data Analysis",
        value: "data_analysis",
        category: "Problem Solving and Critical Thinking"),

    // Collaboration and Teamwork
    Skill(
        label: "Teamwork",
        value: "teamwork",
        category: "Collaboration and Teamwork"),
    Skill(
        label: "Collaboration",
        value: "collaboration",
        category: "Collaboration and Teamwork"),
    Skill(
        label: "Cross-functional Coordination",
        value: "cross_functional_coordination",
        category: "Collaboration and Teamwork"),
    Skill(
        label: "Cultural Awareness",
        value: "cultural_awareness",
        category: "Collaboration and Teamwork"),
    Skill(
        label: "Empathy",
        value: "empathy",
        category: "Collaboration and Teamwork"),
    Skill(
        label: "Relationship Building",
        value: "relationship_building",
        category: "Collaboration and Teamwork"),
    Skill(
        label: "Networking",
        value: "networking",
        category: "Collaboration and Teamwork"),

    // Time Management and Organization
    Skill(
        label: "Time Management",
        value: "time_management",
        category: "Time Management and Organization"),
    Skill(
        label: "Organization",
        value: "organization",
        category: "Time Management and Organization"),
    Skill(
        label: "Prioritization",
        value: "prioritization",
        category: "Time Management and Organization"),
    Skill(
        label: "Planning",
        value: "planning",
        category: "Time Management and Organization"),
    Skill(
        label: "Goal Setting",
        value: "goal_setting",
        category: "Time Management and Organization"),
    Skill(
        label: "Multitasking",
        value: "multitasking",
        category: "Time Management and Organization"),
    Skill(
        label: "Meeting Deadlines",
        value: "meeting_deadlines",
        category: "Time Management and Organization"),
    Skill(
        label: "Attention to Detail",
        value: "attention_to_detail",
        category: "Time Management and Organization"),

    // Emotional Intelligence
    Skill(
        label: "Self-awareness",
        value: "self_awareness",
        category: "Emotional Intelligence"),
    Skill(
        label: "Self-regulation",
        value: "self_regulation",
        category: "Emotional Intelligence"),
    Skill(
        label: "Motivation",
        value: "motivation",
        category: "Emotional Intelligence"),
    Skill(
        label: "Social Skills",
        value: "social_skills",
        category: "Emotional Intelligence"),
    Skill(
        label: "Adaptability",
        value: "adaptability",
        category: "Emotional Intelligence"),
    Skill(
        label: "Resilience",
        value: "resilience",
        category: "Emotional Intelligence"),
    Skill(
        label: "Stress Management",
        value: "stress_management",
        category: "Emotional Intelligence"),
    Skill(
        label: "Positive Attitude",
        value: "positive_attitude",
        category: "Emotional Intelligence"),

    // Additional valuable soft skills
    Skill(
        label: "Critical Thinking",
        value: "critical_thinking",
        category: "Problem Solving and Critical Thinking"),
    Skill(
        label: "Emotional Intelligence",
        value: "emotional_intelligence",
        category: "Emotional Intelligence"),
    Skill(
        label: "Active Listening",
        value: "active_listening",
        category: "Communication"),
    Skill(
        label: "Conflict Resolution",
        value: "conflict_resolution",
        category: "Leadership and Management"),
    Skill(label: "Persuasion", value: "persuasion", category: "Communication"),
    Skill(
        label: "Work Ethic", value: "work_ethic", category: "Professionalism"),
    Skill(
        label: "Professionalism",
        value: "professionalism",
        category: "Professionalism"),
    Skill(
        label: "Dependability",
        value: "dependability",
        category: "Professionalism"),
    Skill(
        label: "Accountability",
        value: "accountability",
        category: "Professionalism"),
  ];

  Map<String, List<Skill>> get groupedSkills {
    final map = <String, List<Skill>>{};
    for (final skill in allSkills) {
      (map[skill.category] ??= []).add(skill);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SoftSkillBloc(_softSkillsService)..add(LoadSoftSkills(context)),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: const Color(0xffF9F2ED),
          appBar: AppBar(
            backgroundColor: Color(0xffF9F2ED),
            title: const Text(
              "Soft Skills",
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
            child: BlocBuilder<SoftSkillBloc, SoftSkillState>(
              builder: (context, state) {
                if (state is SoftSkillInitial || state is SoftSkillLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is SoftSkillError) {
                  return Center(child: Text(state.message));
                }

                if (state is SoftSkillLoaded) {
                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField<String>(
                          value: state.selectedSkill,
                          hint: const Text("Select Skill"),
                          isExpanded: true,
                          items: [
                            for (final entry in groupedSkills.entries) ...[
                              DropdownMenuItem<String>(
                                value: null,
                                enabled: false,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    entry.key,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ),
                              ),
                              ...entry.value
                                  .map((skill) => DropdownMenuItem<String>(
                                        value: skill.label,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 24.0),
                                          child: Text(
                                            skill.label,
                                            style: const TextStyle(
                                              fontFamily: "Poppins",
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )),
                            ]
                          ],
                          decoration: InputDecoration(
                            labelText: "Select Skill",
                            labelStyle: const TextStyle(fontFamily: "Poppins"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onChanged: (value) {
                            if (value != null) {
                              context
                                  .read<SoftSkillBloc>()
                                  .add(SelectSoftSkill(value));
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor: Color(0xffFF9500),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                            ),
                            onPressed: () {
                              context
                                  .read<SoftSkillBloc>()
                                  .add(ClearSelection());
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
                            onPressed: () {
                              if (state.selectedSkill != null) {
                                context.read<SoftSkillBloc>().add(
                                      AddSoftSkill(
                                          state.selectedSkill!, context),
                                    );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Please select a skill first")),
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
                      Expanded(
                        child: state.softSkills.isEmpty
                            ? Center(
                                child: Text(
                                  "No skills added yet",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: state.softSkills.length,
                                itemBuilder: (context, index) {
                                  final softskill = state.softSkills[index];
                                  return Card(
                                    color: Colors.white,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: ListTile(
                                      title: Text(
                                        softskill.skillName ?? 'Unknown Skill',
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: Color(0xff3F414E),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.cancel_outlined,
                                            color: Colors.red),
                                        onPressed: () async {
                                          final confirm = await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text(
                                                'Confirm Delete',
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: Color(0xff3F414E),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              content: Text(
                                                'Are you sure you want to delete ${softskill.skillName}?',
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
                                                      color: Color(0xff3F414E),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                ),
                                                TextButton(
                                                  child: Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      color: Color(0xff3F414E),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (confirm == true) {
                                            context.read<SoftSkillBloc>().add(
                                                  DeleteSoftSkill(
                                                      softskill.id, context),
                                                );
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                }

                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class Skill {
  final String label;
  final String value;
  final String category;

  Skill({
    required this.label,
    required this.value,
    required this.category,
  });
}
