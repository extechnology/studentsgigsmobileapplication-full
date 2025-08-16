import 'dart:io';
import 'package:anjalim/student_Section/custom_widgets/CustomTextField.dart';
import 'package:anjalim/student_Section/custom_widgets/dropdownbutton.dart';
import 'package:anjalim/student_Section/models_std/employee_Profile/employeeProfileImages.dart';
import 'package:anjalim/student_Section/services/employee_detailsFeatching.dart';
import 'package:anjalim/student_Section/student_blocs/profile_edit_std/profile_edit_bloc.dart'
    show
        UpdateFormField,
        SearchLocation,
        ProfileEditLocationSuggestions,
        ProfileEditBloc,
        SelectDate,
        ProfileEditUploading,
        PickImage,
        ProfileEditLoaded,
        ProfileEditError,
        ProfileEditInitial,
        ProfileEditState,
        ProfileEditLoading,
        LoadProfileData,
        UpdateProfile;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileEditBloc(
        EmployeeServices(),
      )..add(LoadProfileData()),
      child: Scaffold(
        backgroundColor: const Color(0xffF9F2ED),
        appBar: AppBar(
          title: const Text(
            "Update Profile",
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Color(0xff3F414E),
            ),
          ),
          backgroundColor: const Color(0xffF9F2ED),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: BlocConsumer<ProfileEditBloc, ProfileEditState>(
          listener: (context, state) {
            if (state is ProfileEditError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            } else if (state is ProfileEditLoaded && state.showSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.successMessage!)),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileEditInitial || state is ProfileEditLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileEditError) {
              return Center(child: Text(state.error));
            }

            final bloc = context.read<ProfileEditBloc>();

            // Now all states have profileData and jobTitles
            EmployeeProfile? profileData;
            List<dynamic> jobTitles = [];

            if (state is ProfileEditLoaded) {
              profileData = state.profileData;
              jobTitles = state.jobTitles;
            } else if (state is ProfileEditUploading) {
              profileData = state.profileData;
              jobTitles = state.jobTitles;
            } else if (state is ProfileEditLocationSuggestions) {
              profileData = state.profileData;
              jobTitles = state.jobTitles;
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: Form(
                  key: GlobalKey<FormState>(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile picture section
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3.3,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            state is ProfileEditUploading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xff004673),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: MediaQuery.of(context).size.height /
                                        3.8,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image:
                                            _getCoverPhotoProvider(profileData),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Container(
                                          height: 38,
                                          width: 38,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xff004673),
                                          ),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () => bloc.add(PickImage(
                                              isProfileImage: false,
                                              context: context,
                                            )),
                                            icon: const Icon(Icons.edit,
                                                color: Colors.white, size: 20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.grey.shade300,
                                backgroundImage:
                                    _getProfilePicProvider(profileData),
                                child: state is ProfileEditUploading
                                    ? const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : Align(
                                        alignment: Alignment.bottomRight,
                                        child: Container(
                                          height: 38,
                                          width: 38,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xff004673),
                                          ),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () => bloc.add(PickImage(
                                              isProfileImage: true,
                                              context: context,
                                            )),
                                            icon: const Icon(Icons.edit,
                                                color: Colors.white, size: 20),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Name Field
                      _buildSectionLabel("Name"),
                      CustomTextField(
                        controller: bloc.user_Name,
                        hintText: "Enter Name",
                      ),

                      // Email Field
                      _buildSectionLabel("Contact Email"),
                      CustomTextField(
                        controller: bloc.email,
                        hintText: "Enter Email",
                      ),

                      // Phone Field with Country Code Picker
                      _buildSectionLabel("Phone Number"),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            // Country Code Picker
                            CountryCodePicker(
                              onChanged: (CountryCode countryCode) {
                                bloc.selectedCountryCode = countryCode;
                              },
                              initialSelection: bloc.selectedCountryCode.code,
                              favorite: const ['+91', '+1', '+44'],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                              textStyle: const TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                              ),
                              dialogTextStyle: const TextStyle(
                                fontFamily: "Poppins",
                              ),
                              searchStyle: const TextStyle(
                                fontFamily: "Poppins",
                              ),
                              searchDecoration: const InputDecoration(
                                hintText: 'Search country...',
                                hintStyle: TextStyle(fontFamily: "Poppins"),
                              ),
                              flagWidth: 25,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.grey.shade300,
                            ),
                            // Phone Number Input
                            Expanded(
                              child: TextFormField(
                                controller: bloc.phone_Number,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                decoration: const InputDecoration(
                                  hintText: "Enter Phone Number",
                                  hintStyle: TextStyle(fontFamily: "Poppins"),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter phone number';
                                  }
                                  if (value.length < 7) {
                                    return 'Please enter a valid phone number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Work Hours Field
                      _buildSectionLabel("Available Working Hours"),
                      CustomTextField(
                        controller: bloc.work_Hours,
                        keyboardType: TextInputType.number,
                      ),

                      // Portfolio Field
                      _buildSectionLabel("Portfolio/LinkedIn Profile"),
                      CustomTextField(
                        controller: bloc.portfolio,
                        hintText: "Enter Portfolio/LinkedIn Profile",
                      ),

                      // Work Location Field
                      _buildSectionLabel("Preferred Work Location"),
                      if (state is ProfileEditLocationSuggestions)
                        ..._buildLocationSuggestions(
                            state as ProfileEditLocationSuggestions, bloc),
                      if (state is! ProfileEditLocationSuggestions)
                        TextField(
                          controller: bloc.loacation,
                          onChanged: (value) {
                            if (value.length >= 2) {
                              bloc.add(SearchLocation(query: value));
                            }
                          },
                          decoration: InputDecoration(
                            labelText: "Search Your Location",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "Enter your preferred work location",
                          ),
                        ),

                      // Date of Birth Field
                      _buildSectionLabel("Date of Birth"),
                      GestureDetector(
                        onTap: () => bloc.add(SelectDate(context: context)),
                        child: AbsorbPointer(
                          child: CustomTextField(
                            hintText: "DD-MM-YYYY",
                            controller: bloc.dateOfbirth,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[\d-]')),
                              LengthLimitingTextInputFormatter(10),
                              _DateInputFormatter(),
                            ],
                            iconTrailing: Icons.calendar_month_outlined,
                          ),
                        ),
                      ),

                      // Gender Field
                      _buildSectionLabel("Gender"),
                      DropdownButtonFormField<String>(
                        value: bloc.selectedGender,
                        hint: Text(
                          "Select your gender",
                          style: TextStyle(
                              fontFamily: "Poppins", color: Colors.grey[600]),
                        ),
                        items: ["Male", "Female"].map((gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: (value) {
                          bloc.selectedGender = value;
                        },
                        validator: (value) {
                          if (value == null) return 'Please select gender';
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Select your gender",
                          labelStyle: const TextStyle(fontFamily: "Poppins"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),

                      // Age Field
                      _buildSectionLabel("Age"),
                      CustomTextField(
                        controller: bloc.ageController,
                        hintText: "0",
                        keyboardType: TextInputType.number,
                      ),

                      // Job Title Field
                      _buildSectionLabel("Job Title"),
                      buildDropdownButtonFormField(
                        value: bloc.selectedJobTitle,
                        items: jobTitles.map((job) {
                          return DropdownMenuItem(
                            value: job['job_title'].toString(),
                            child: Text(job['job_title'] ?? 'No Title'),
                          );
                        }).toList(),
                        labelText: "Select Job Title",
                        onChanged: (value) {
                          bloc.selectedJobTitle = value;
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a job title';
                          }
                          return null;
                        },
                      ),

                      // About You Field
                      _buildSectionLabel("About You"),
                      CustomTextField(
                        maxLines: 4,
                        controller: bloc.about,
                        hintText: "",
                      ),

                      const SizedBox(height: 20),

                      // Save Button
                      Center(
                        child: SizedBox(
                          width: 107,
                          height: 56,
                          child: Builder(
                            builder: (BuildContext context) {
                              return FloatingActionButton(
                                onPressed: () {
                                  final form = Form.of(context);
                                  if (form.validate() ?? false) {}
                                },
                                child: const Text(
                                  "Save",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                                backgroundColor: const Color(0xff004673),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xff3F414E)),
      ),
    );
  }

  List<Widget> _buildLocationSuggestions(
      ProfileEditLocationSuggestions state, ProfileEditBloc bloc) {
    return [
      TextField(
        controller: bloc.loacation,
        onChanged: (value) {
          if (value.length >= 2) {
            bloc.add(SearchLocation(query: value));
          }
        },
        decoration: InputDecoration(
          labelText: "Search Your Location",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: "Enter your preferred work location",
        ),
      ),
      ...state.locations.map((location) => ListTile(
            title: Text(location.toString()),
            onTap: () {
              bloc.loacation.text = location.toString();
              bloc.add(UpdateFormField(
                  fieldName: 'location', value: location.toString()));
            },
          )),
    ];
  }

  ImageProvider _getCoverPhotoProvider(EmployeeProfile? profileData) {
    if (profileData?.coverPhoto != null &&
        profileData!.coverPhoto!.isNotEmpty) {
      return NetworkImage(profileData!.coverPhoto!);
    }
    return const AssetImage(
            "lib/assets/images/others/elementor-placeholder-image (1).webp")
        as ImageProvider;
  }

  ImageProvider _getProfilePicProvider(EmployeeProfile? profileData) {
    if (profileData?.profilePic != null &&
        profileData!.profilePic!.isNotEmpty) {
      return NetworkImage(profileData!.profilePic!);
    }
    return const AssetImage("lib/assets/images/others/Group 69.png")
        as ImageProvider;
  }
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 || i == 4) {
        buffer.write('-');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class DateFormatter {
  static String displayToApi(String displayDate) {
    try {
      final parts = displayDate.split('-');
      if (parts.length == 3) {
        return '${parts[2]}-${parts[1]}-${parts[0]}';
      }
    } catch (e) {}
    return displayDate;
  }

  static String apiToDisplay(String apiDate) {
    try {
      final parts = apiDate.split('-');
      if (parts.length == 3) {
        return '${parts[2]}-${parts[1]}-${parts[0]}';
      }
    } catch (e) {}
    return apiDate;
  }

  static bool isValidDisplayDate(String date) {
    try {
      final parts = date.split('-');
      if (parts.length != 3) return false;
      if (parts[0].length != 2 || parts[1].length != 2 || parts[2].length != 4)
        return false;

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      if (day < 1 || day > 31) return false;
      if (month < 1 || month > 12) return false;
      if (year < 1900 || year > DateTime.now().year) return false;

      return true;
    } catch (e) {
      return false;
    }
  }
}
