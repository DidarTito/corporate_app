class TrainingMaterial {
  final String id;
  final String title;
  final String description;
  final String category;  // master, installer, foreman, etc.
  final String? fileUrl;  // PDF, video, etc.
  final String? imageUrl;
  final DateTime publishDate;
  final bool isMemo;  // true for memos, false for training materials

  TrainingMaterial({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.fileUrl,
    this.imageUrl,
    required this.publishDate,
    this.isMemo = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'fileUrl': fileUrl,
      'imageUrl': imageUrl,
      'publishDate': publishDate.toIso8601String(),
      'isMemo': isMemo,
    };
  }

  factory TrainingMaterial.fromMap(Map<String, dynamic> map) {
    return TrainingMaterial(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      fileUrl: map['fileUrl'],
      imageUrl: map['imageUrl'],
      publishDate: DateTime.parse(map['publishDate']),
      isMemo: map['isMemo'] ?? false,
    );
  }
}
