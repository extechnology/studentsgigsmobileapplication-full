// employee_model.dart
class StudentEmployee {
  final String name;
  final String email;
  final String phone;
  final String preferredWorkLocation;
  final String availableWorkHours;
  final dynamic profilePhoto;
  final dynamic coverPhoto;
  final String portfolio;
  final String jobTitle;
  final String? about;
  final String? availableWorkingPeriodsStartDate;
  final String? availableWorkingPeriodsEndDate;
  final String? dateOfBirth;
  final int? age;
  final String? gender;

  StudentEmployee({
    required this.name,
    required this.email,
    required this.phone,
    required this.preferredWorkLocation,
    required this.availableWorkHours,
    this.profilePhoto,
    this.coverPhoto,
    required this.portfolio,
    required this.jobTitle,
    this.about,
    this.availableWorkingPeriodsStartDate,
    this.availableWorkingPeriodsEndDate,
    this.dateOfBirth,
    required this.age,
    this.gender,
  });

  factory StudentEmployee.fromMap(Map<String, dynamic> map) {
    return StudentEmployee(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      preferredWorkLocation: map['preferred_work_location'] ?? '',
      availableWorkHours: map['available_work_hours']?.toString() ?? '0',
      profilePhoto: map['profile_photo'],
      coverPhoto: map['cover_photo'],
      portfolio: map['portfolio'] ?? '',
      jobTitle: map['job_title'] ?? '',
      about: map['about'],
      availableWorkingPeriodsStartDate:
          map['available_working_periods_start_date']?.toString(),
      availableWorkingPeriodsEndDate:
          map['available_working_periods_end_date']?.toString(),
      dateOfBirth: map['date_of_birth']?.toString(),
      age: map['age'] as int?,
      gender: map["gender"] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'preferred_work_location': preferredWorkLocation,
      'available_work_hours': availableWorkHours,
      'profile_photo': profilePhoto,
      'cover_photo': coverPhoto,
      'portfolio': portfolio,
      'job_title': jobTitle,
      'about': about,
      'available_working_periods_start_date': availableWorkingPeriodsStartDate,
      'available_working_periods_end_date': availableWorkingPeriodsEndDate,
      'date_of_birth': dateOfBirth,
      'age': age,
      'gender': gender
    };
  }
}
