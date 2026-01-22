import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/setting_item.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _showLanguageDialog(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) {
        String selectedLanguage = settings.language;
        
        return AlertDialog(
          title: const Text('Select Language'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 3 Boxes in a row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // KZ Box
                        _LanguageBox(
                          languageCode: 'kz',
                          label: 'ҚАЗ',
                          fullName: 'Қазақша',
                          isSelected: selectedLanguage == 'kz',
                          onTap: () {
                            setState(() {
                              selectedLanguage = 'kz';
                            });
                          },
                        ),
                        
                        // RU Box
                        _LanguageBox(
                          languageCode: 'ru',
                          label: 'РУС',
                          fullName: 'Русский',
                          isSelected: selectedLanguage == 'ru',
                          onTap: () {
                            setState(() {
                              selectedLanguage = 'ru';
                            });
                          },
                        ),
                        
                        // EN Box
                        _LanguageBox(
                          languageCode: 'en',
                          label: 'ENG',
                          fullName: 'English',
                          isSelected: selectedLanguage == 'en',
                          onTap: () {
                            setState(() {
                              selectedLanguage = 'en';
                            });
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Selected language display
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.language, size: 20, color: AppColors.primaryBlue),
                          const SizedBox(width: 8),
                          Text(
                            _getFullLanguageName(selectedLanguage),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                settings.changeLanguage(selectedLanguage);
                Navigator.pop(context);
              },
              child: const Text('SAVE'),
            ),
          ],
        );
      },
    );
  }
  
  String _getFullLanguageName(String code) {
    switch (code) {
      case 'kz':
        return 'Қазақша';
      case 'ru':
        return 'Русский';
      case 'en':
        return 'English';
      default:
        return 'Русский';
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              final settings = Provider.of<SettingsProvider>(context, listen: false);
              settings.logout();
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back from settings
              Navigator.pop(context); // Go to login screen
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('LOGOUT'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Settings',
        showBackButton: true,
      ),
      body: ListView(
        children: [
          // Language Setting
          SettingItem(
            title: 'Language',
            icon: Icons.language,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  settings.getLanguageDisplayName(settings.language),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: AppColors.grey),
              ],
            ),
            onTap: () => _showLanguageDialog(context),
          ),
          
          // Dark Mode Setting
          SettingItem(
            title: 'Dark Mode',
            icon: Icons.dark_mode,
            trailing: Switch(
              value: settings.isDarkMode,
              onChanged: (value) {
                settings.toggleDarkMode();
              },
              activeThumbColor: AppColors.primaryBlue,
            ),
          ),
          
          // App Version
          SettingItem(
            title: 'App Version',
            icon: Icons.info,
            trailing: const Text(
              '1.0.0',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            showDivider: false,
          ),
          
          // Logout Button
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout, size: 20),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'LOGOUT',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _LanguageBox extends StatelessWidget {
  final String languageCode;
  final String label;
  final String fullName;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageBox({
    required this.languageCode,
    required this.label,
    required this.fullName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              languageCode.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white.withOpacity(0.8) : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}