import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool showDivider;
  
  const SettingItem({
    super.key,
    required this.title,
    this.trailing,
    this.icon,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Column(
      children: [
        ListTile(
          leading: icon != null
              ? Icon(icon, color: theme.primaryColor)
              : null,
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.grey.shade200 : Colors.black87,
            ),
          ),
          trailing: trailing,
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          minLeadingWidth: 36,
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
          ),
      ],
    );
  }
}