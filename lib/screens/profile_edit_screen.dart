import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_app_bar.dart';
import '../models/user_model.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';

class ProfileEditScreen extends StatefulWidget {
  final User user;
  
  const ProfileEditScreen({
    super.key,
    required this.user,
  });

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _clothingSizeController;
  late TextEditingController _shoeSizeController;
  
  @override
  void initState() {
    super.initState();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    
    // Используем email из логина, если он есть, иначе из настроек
    final loginEmail = settings.loginEmail.isNotEmpty 
        ? settings.loginEmail 
        : (settings.userData['email'] ?? widget.user.email);
    
    _phoneController = TextEditingController(text: settings.userData['phoneNumber']);
    _emailController = TextEditingController(text: loginEmail); // Используем email из логина
    _clothingSizeController = TextEditingController(text: settings.userData['clothingSize']);
    _shoeSizeController = TextEditingController(text: settings.userData['shoeSize']);
  }
  
  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _clothingSizeController.dispose();
    _shoeSizeController.dispose();
    super.dispose();
  }
  void _saveChanges(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    
    // Получаем новый email
    final newEmail = _emailController.text.trim();
    
    // Update user data
    settings.updateUserData('phoneNumber', _phoneController.text);
    settings.updateUserData('email', newEmail);
    settings.updateUserData('clothingSize', _clothingSizeController.text);
    settings.updateUserData('shoeSize', _shoeSizeController.text);
    
    // Обновляем loginEmail если он отличается
    if (settings.loginEmail != newEmail) {
      settings.saveLoginEmail(newEmail);
    }
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile updated successfully'),
        backgroundColor: AppColors.success,
      ),
    );
    
    // Navigate back
    Navigator.pop(context);
  }
  
  void _showSaveConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Changes'),
        content: const Text('Are you sure you want to save the changes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _saveChanges(context); // Save changes
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = Provider.of<SettingsProvider>(context);
    
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Edit Profile',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Avatar
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Non-editable fields
                    _buildReadOnlyField(context, 'IIN', widget.user.iin),
                    _buildReadOnlyField(context, 'Full Name', widget.user.fullName),
                    _buildReadOnlyField(context, 'Position', widget.user.position),
                    
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    
                    // Editable fields
                    _buildEditableField(
                      context,
                      'Phone Number',
                      _phoneController,
                      TextInputType.phone,
                      Icons.phone,
                    ),
                    _buildEditableField(
                      context,
                      'Email',
                      _emailController,
                      TextInputType.emailAddress,
                      Icons.email,
                    ),
                    _buildEditableField(
                      context,
                      'Clothing Size',
                      _clothingSizeController,
                      TextInputType.text,
                      Icons.checkroom,
                    ),
                    _buildEditableField(
                      context,
                      'Shoe Size',
                      _shoeSizeController,
                      TextInputType.text,
                      Icons.directions_walk,
                    ),
                    
                    // Email source info (debug, можно убрать)
                    if (settings.loginEmail.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Divider(color: theme.colorScheme.primary.withOpacity(0.2)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.info_outline, size: 16, color: AppColors.info),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Email from login: ${settings.loginEmail}',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.info,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    // Save Button (inside card)
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _showSaveConfirmation(context),
                        icon: const Icon(Icons.save),
                        label: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'SAVE CHANGES',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Note
            const SizedBox(height: 20),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: AppColors.info.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.info, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Note: IIN, Full Name, and Position are managed by HR department and cannot be changed here.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.info,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Email can be edited but will be used for future logins.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.info.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildReadOnlyField(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEditableField(
    BuildContext context,
    String label,
    TextEditingController controller,
    TextInputType keyboardType,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                prefixIcon: Icon(icon, size: 20),
                isDense: true,
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}