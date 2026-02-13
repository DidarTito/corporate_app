class ChildInfo {
  final String name;
  final DateTime birthDate;
  final String? certificateNumber;  // For certificates
  final String? socialPackageInfo;  // Social package information

  ChildInfo({
    required this.name,
    required this.birthDate,
    this.certificateNumber,
    this.socialPackageInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'birthDate': birthDate.toIso8601String(),
      'certificateNumber': certificateNumber,
      'socialPackageInfo': socialPackageInfo,
    };
  }

  factory ChildInfo.fromMap(Map<String, dynamic> map) {
    DateTime birthDate = DateTime.now();
    if (map['birthDate'] != null) {
      try {
        birthDate = DateTime.parse(map['birthDate'].toString());
      } catch (_) {}
    }
    return ChildInfo(
      name: map['name']?.toString() ?? '',
      birthDate: birthDate,
      certificateNumber: map['certificateNumber']?.toString(),
      socialPackageInfo: map['socialPackageInfo']?.toString(),
    );
  }
}
