class AdditionalInformations {
  final int id;
  final String? resume;
  final List<String>? hobbies;
  final String? willingToRelocate;
  final String? testimonials;

  AdditionalInformations({
    required this.id,
    this.resume,
    this.hobbies,
    this.willingToRelocate,
    this.testimonials,
  });

  factory AdditionalInformations.fromJson(Map<String, dynamic> json) {
    return AdditionalInformations(
      id: json['id'] ?? 0, // Default to 0 if null
      resume: json['resume'],
      hobbies: (json['hobbies_or_interests']?.toString().isNotEmpty ?? false)
          ? json['hobbies_or_interests']
              .toString()
              .split(',')
              .map((e) => e.trim())
              .toList()
          : [],
      willingToRelocate: json['willing_to_relocate']?.toString(),
      testimonials: json['reference_or_testimonials'],
    );
  }

  // Empty constructor for when no data exists
  factory AdditionalInformations.empty() {
    return AdditionalInformations(
      id: 0,
      hobbies: [],
      willingToRelocate: null,
      testimonials: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resume': resume,
      'hobbies_or_interests': hobbies?.join(','),
      'willing_to_relocate': willingToRelocate,
      'reference_or_testimonials': testimonials,
    };
  }
}
