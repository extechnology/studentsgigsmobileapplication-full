import 'package:anjalim/student_Section/student_blocs/additional_info_std/additional_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AdditionalInformationScreen extends StatelessWidget {
  const AdditionalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdditionalInfoBloc()..add(LoadAdditionalInfo()),
      child: Scaffold(
        backgroundColor: const Color(0xffF9F2ED),
        appBar: AppBar(
          backgroundColor: const Color(0xffF9F2ED),
          title: const Text(
            'Additional Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: const AdditionalInformationView(),
      ),
    );
  }
}

class AdditionalInformationView extends StatefulWidget {
  const AdditionalInformationView({super.key});

  @override
  State<AdditionalInformationView> createState() =>
      _AdditionalInformationViewState();
}

class _AdditionalInformationViewState extends State<AdditionalInformationView> {
  final TextEditingController _hobbiesController = TextEditingController();
  final TextEditingController _referencesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _hobbiesController.addListener(_onHobbiesChanged);
    _referencesController.addListener(_onReferencesChanged);
  }

  @override
  void dispose() {
    _hobbiesController.dispose();
    _referencesController.dispose();
    super.dispose();
  }

  void _onHobbiesChanged() {
    // Handle hobby input if needed
  }

  void _onReferencesChanged() {
    context
        .read<AdditionalInfoBloc>()
        .add(UpdateReferences(_referencesController.text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdditionalInfoBloc, AdditionalInfoState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          if (state.errorMessage ==
              'Storage permission is permanently denied') {
            _showPermissionDialog(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Hobbies and Interests
              TextFormField(
                controller: _hobbiesController,
                decoration: InputDecoration(
                  hintText: 'Add a hobby and press enter',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onFieldSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    context
                        .read<AdditionalInfoBloc>()
                        .add(AddHobby(value.trim()));
                    _hobbiesController.clear();
                  }
                },
              ),
              const SizedBox(height: 8),
              if (state.hobbies.isNotEmpty)
                Row(
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: state.hobbies
                          .map((hobby) => Chip(
                                label: Text(hobby),
                                deleteIcon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                onDeleted: () => context
                                    .read<AdditionalInfoBloc>()
                                    .add(RemoveHobby(hobby)),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              const SizedBox(height: 20),

              // References or Testimonials
              TextFormField(
                controller: _referencesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'References or Testimonials (optional)',
                  hintText: 'Provide references or testimonials (optional)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 20),

              // Willingness to Relocate
              DropdownButtonFormField<String>(
                value: state.relocate,
                decoration: InputDecoration(
                  labelText: 'Willing to Relocate',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                hint: const Text('Select an option'),
                items: ['Yes', 'No'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) => context
                    .read<AdditionalInfoBloc>()
                    .add(UpdateRelocationPreference(newValue)),
              ),
              const SizedBox(height: 20),

              // Upload Resume Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Upload Resume Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.white),
                    onPressed: () {
                      context.read<AdditionalInfoBloc>().add(
                            UploadResume(null, context: context),
                          );
                    },
                    icon: const Icon(
                      Icons.upload_file,
                      color: Color(0xff004673),
                    ),
                    label: const Text(
                      'Upload Resume (PDF)',
                      style: TextStyle(
                          fontFamily: "Poppins", color: Color(0xff004673)),
                    ),
                  ),

                  // Show existing server resume
                  if (state.additionalInfo?.resume != null &&
                      state.additionalInfo!.resume!.isNotEmpty &&
                      !state.isResumeUploaded)
                    _ResumeItem(
                      fileName:
                          _getFileNameFromUrl(state.additionalInfo!.resume!),
                      label: 'Current Resume',
                      color: Colors.blue,
                      onView: () => context
                          .read<AdditionalInfoBloc>()
                          .add(const ViewResume(false)),
                    ),

                  // Show selected new resume (local file)
                  if (state.resume != null && state.resume!.files.isNotEmpty)
                    _ResumeItem(
                      fileName: state.resume!.files.single.name,
                      label: 'New Upload',
                      color: Colors.green,
                      fileSize: state.resume!.files.single.size,
                      onView: () => context
                          .read<AdditionalInfoBloc>()
                          .add(const ViewResume(true)),
                    ),
                ],
              ),
              const SizedBox(height: 30),

              // Save / Cancel Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: const ButtonStyle(),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style:
                          TextStyle(fontFamily: "Poppins", color: Colors.black),
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
                    onPressed: state.status == AdditionalInfoStatus.loading
                        ? null
                        : () => context
                            .read<AdditionalInfoBloc>()
                            .add(SaveAdditionalInfo()),
                    child: state.status == AdditionalInfoStatus.loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                                fontFamily: "Poppins", color: Colors.white),
                          ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showPermissionDialog(BuildContext context) async {
    final shouldOpenSettings = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content: Text('Please enable storage permission in app settings'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Open Settings'),
          ),
        ],
      ),
    );

    if (shouldOpenSettings == true) {
      await openAppSettings();
    }
  }

  String _getFileNameFromUrl(String url) {
    try {
      Uri uri = Uri.parse(url);
      String path = uri.path;
      return path.split('/').last;
    } catch (e) {
      return 'Resume.pdf';
    }
  }
}

class _ResumeItem extends StatelessWidget {
  final String fileName;
  final String label;
  final MaterialColor color; // Changed from Color to MaterialColor
  final int? fileSize;
  final VoidCallback onView;

  const _ResumeItem({
    required this.fileName,
    required this.label,
    required this.color, // Now accepts MaterialColor
    this.fileSize,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.shade50, // Use .shade50 instead of [50]
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: color.shade200), // Use .shade200 instead of [200]
      ),
      child: Row(
        children: [
          const Icon(
            Icons.picture_as_pdf,
            color: Colors.red,
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    if (fileSize != null)
                      Text(
                        '${(fileSize! / 1024 / 1024).toStringAsFixed(2)} MB',
                        style: TextStyle(
                          color: Colors.grey.shade600, // Use .shade here too
                          fontSize: 12,
                        ),
                      ),
                    if (fileSize != null) const SizedBox(width: 8),
                    Text(
                      label,
                      style: TextStyle(
                        color: color.shade600, // Use .shade here too
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onView,
                icon: const Icon(
                  Icons.visibility,
                  color: Color(0xff004673),
                ),
                tooltip: 'View Resume',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
