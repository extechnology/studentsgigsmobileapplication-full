class EmployeeProfile {
  final int id;
  final String employeeName;
  final String jobTitle;
  final String username;
  final String? coverPhoto;
  final String? profilePic;
  final int employeeId;

  EmployeeProfile({
    required this.id,
    required this.employeeName,
    required this.jobTitle,
    required this.username,
    this.coverPhoto,
    this.profilePic,
    required this.employeeId,
  });

  factory EmployeeProfile.fromJson(Map<String, dynamic> json) {
    return EmployeeProfile(
      id: json['id'],
      employeeName: json['employee_name'],
      jobTitle: json['job_title'],
      username: json['username'],
      coverPhoto: json['cover_photo'],
      profilePic: json['profile_pic'],
      employeeId: json['employee'],
    );
  }
}
