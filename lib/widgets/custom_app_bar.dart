import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final bool showNotificationButton;
  final VoidCallback? onBackPressed;
  final VoidCallback? onNotificationPressed;
  
  const CustomAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.showNotificationButton = false,
    this.onBackPressed,
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
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back, 
                  color: theme.appBarTheme.iconTheme?.color ?? theme.appBarTheme.foregroundColor),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      title: title != null
          ? Text(
              title!,
              style: theme.appBarTheme.titleTextStyle,
            )
          : null,
      centerTitle: true,
      actions: showNotificationButton
          ? [
              IconButton(
                icon: Icon(Icons.notifications_outlined, 
                    color: theme.appBarTheme.iconTheme?.color ?? theme.appBarTheme.foregroundColor),
                onPressed: onNotificationPressed,
              ),
            ]
          : null,
    );
  }
}