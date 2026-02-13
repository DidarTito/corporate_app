class ProjectVacancy {
  final String id;
  final String title;
  final String description;
  final String location;
  final double? latitude;
  final double? longitude;
  final String projectType;  // construction, installation, etc.
  final List<String> requiredSkills;
  final DateTime publishDate;
  final bool isActive;

  ProjectVacancy({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    this.latitude,
    this.longitude,
    required this.projectType,
    this.requiredSkills = const [],
    required this.publishDate,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'projectType': projectType,
      'requiredSkills': requiredSkills,
      'publishDate': publishDate.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory ProjectVacancy.fromMap(Map<String, dynamic> map) {
    return ProjectVacancy(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      projectType: map['projectType'] ?? '',
      requiredSkills: List<String>.from(map['requiredSkills'] ?? []),
      publishDate: DateTime.parse(map['publishDate']),
      isActive: map['isActive'] ?? true,
    );
  }
}
