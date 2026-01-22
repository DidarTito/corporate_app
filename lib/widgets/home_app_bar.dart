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
    
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      elevation: theme.appBarTheme.elevation ?? 2,
      title: Row(
        children: [
          Icon(Icons.business, size: 24, color: theme.appBarTheme.iconTheme?.color ?? theme.appBarTheme.foregroundColor),
          const SizedBox(width: 8),
          Text(
            AppStrings.appName,
            style: theme.appBarTheme.titleTextStyle,
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.notifications_outlined, 
                color: theme.appBarTheme.iconTheme?.color ?? theme.appBarTheme.foregroundColor),
            onPressed: onNotificationPressed,
          ),
        ],
      ),
    );
  }
}