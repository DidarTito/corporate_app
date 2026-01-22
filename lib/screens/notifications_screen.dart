import 'package:corporate_app/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'notification_details_screen.dart';
import '../widgets/custom_app_bar.dart';
import '../data/mock_data.dart';
import '../utils/constants.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<NotificationItem> notifications;

  @override
  void initState() {
    super.initState();
    notifications = mockNotifications;
  }

  void _markAsRead(String id) {
    setState(() {
      notifications = notifications.map((notification) {
        if (notification.id == id) {
          return NotificationItem(
            id: notification.id,
            title: notification.title,
            description: notification.description,
            date: notification.date,
            sender: notification.sender,
            isRead: true,
            type: notification.type,
          );
        }
        return notification;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'NOTIFICATIONS',
        showBackButton: true,
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                'No notifications',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationCard(
                  notification: notification,
                  onTap: () {
                    _markAsRead(notification.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationDetailsScreen(
                          notification: notification,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                notification.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: notification.isRead
                      ? AppColors.textPrimary
                      : AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 8),
              
              // Description (minimized to 2 lines)
              Text(
                notification.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              
              // Date and Details button
              Row(
                children: [
                  // Date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${notification.date.day}/${notification.date.month}/${notification.date.year}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                        Text(
                          '${notification.date.hour.toString().padLeft(2, '0')}:${notification.date.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Unread indicator
                  if (!notification.isRead)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  const SizedBox(width: 12),
                  
                  // Details button
                  // TextButton(
                  //   onPressed: onTap,
                  //   style: TextButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 16,
                  //       vertical: 4,
                  //     ),
                  //   ),
                  //   child: const Text(
                  //     'Details',
                  //     style: TextStyle(
                  //       fontSize: 14,
                  //       color: AppColors.primaryBlue,
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}