import 'package:flutter/material.dart';
import '../utils/constants.dart';

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
    return AppBar(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
      elevation: 2,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      centerTitle: true,
      actions: showNotificationButton
          ? [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: onNotificationPressed,
              ),
            ]
          : null,
    );
  }
}