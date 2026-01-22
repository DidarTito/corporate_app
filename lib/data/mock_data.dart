import '../models/user_model.dart';
import '../models/notification_model.dart';

// Mock user
User get mockUser => User.mockUser;

// Mock notifications
List<NotificationItem> get mockNotifications => [
  NotificationItem(
    id: '1',
    title: 'System Maintenance',
    description: 'The system will be down for maintenance on Saturday from 2 AM to 6 AM.',
    date: DateTime.now().subtract(const Duration(hours: 2)),
    sender: 'IT Department',
    isRead: false,
  ),
  NotificationItem(
    id: '2',
    title: 'HR Announcement',
    description: 'New HR policies have been updated. Please review the document.',
    date: DateTime.now().subtract(const Duration(days: 1)),
    sender: 'HR Department',
    isRead: true,
  ),
  NotificationItem(
    id: '3',
    title: 'Meeting Reminder',
    description: 'Team meeting today at 3 PM in Conference Room A.',
    date: DateTime.now().subtract(const Duration(days: 2)),
    sender: 'Manager',
    isRead: true,
  ),
  NotificationItem(
    id: '4',
    title: 'Salary Payment',
    description: 'Your salary for December has been processed.',
    date: DateTime.now().subtract(const Duration(days: 3)),
    sender: 'Finance Department',
    isRead: true,
  ),
  NotificationItem(
    id: '5',
    title: 'Training Session',
    description: 'New employee training session scheduled for next Monday.',
    date: DateTime.now().subtract(const Duration(days: 4)),
    sender: 'Training Department',
    isRead: true,
  ),
];