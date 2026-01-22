class NotificationItem {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String sender;
  final bool isRead;
  final String type;
  
  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.sender,
    this.isRead = false,
    this.type = 'general',
  });
}