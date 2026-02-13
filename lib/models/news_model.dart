class NewsItem {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final String? videoUrl;
  final DateTime publishDate;
  final String author;
  final bool isCorporate;  // true for corporate, false for local
  final List<String> tags;

  NewsItem({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    this.videoUrl,
    required this.publishDate,
    required this.author,
    this.isCorporate = true,
    this.tags = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'publishDate': publishDate.toIso8601String(),
      'author': author,
      'isCorporate': isCorporate,
      'tags': tags,
    };
  }

  factory NewsItem.fromMap(Map<String, dynamic> map) {
    return NewsItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      imageUrl: map['imageUrl'],
      videoUrl: map['videoUrl'],
      publishDate: DateTime.parse(map['publishDate']),
      author: map['author'] ?? '',
      isCorporate: map['isCorporate'] ?? true,
      tags: List<String>.from(map['tags'] ?? []),
    );
  }
}
