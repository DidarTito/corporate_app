import 'package:flutter/material.dart';
import '../utils/constants.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationPressed;
  
  const HomeAppBar({
    super.key,
    this.onNotificationPressed,
  });
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return AppBar(
      backgroundColor: isDarkMode ? const Color.fromARGB(255, 0, 0, 0) : AppColors.primaryBlue,
      foregroundColor: Colors.white,
      elevation: 2,
      title: Row(
        children: [
          const Icon(Icons.business, size: 24),
          const SizedBox(width: 8),
          const Text(
            AppStrings.appName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: onNotificationPressed,
          ),
        ],
      ),
    );
  }
}