class Experiences {
  final int id;
  final String? companyName;
  final String? jobTitle;
  final String? startDate;
  final String? endDate;
  final bool? isCurrentlyWorking;
  final int? employee;

  Experiences({
    required this.id,
    this.companyName,
    this.jobTitle,
    this.startDate,
    this.endDate,
    this.isCurrentlyWorking,
    this.employee,
  });

  factory Experiences.fromJson(Map<String, dynamic> json) {
    // Debug print

    return Experiences(
      id: json['id'] ?? 0,
      companyName: json['exp_company_name']?.toString(),
      jobTitle: json['exp_job_title']?.toString(),
      startDate: json['exp_start_date']?.toString(),
      endDate: json['exp_end_date']?.toString(),
      isCurrentlyWorking: json['exp_working'] as bool? ?? false,
      employee: json['employee'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exp_company_name': companyName,
      'exp_job_title': jobTitle,
      'exp_start_date': startDate,
      'exp_end_date': endDate,
      'exp_working': isCurrentlyWorking,
      'employee': employee,
    };
  }

  @override
  String toString() {
    return 'Experience{id: $id, companyName: $companyName, jobTitle: $jobTitle, startDate: $startDate, endDate: $endDate, isCurrentlyWorking: $isCurrentlyWorking, employee: $employee}';
  }
}
