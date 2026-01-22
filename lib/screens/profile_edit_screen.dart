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
    
    _phoneController = TextEditingController(text: settings.userData['phoneNumber']);
    _emailController = TextEditingController(text: settings.userData['email']);
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
    
    // Update user data
    settings.updateUserData('phoneNumber', _phoneController.text);
    settings.updateUserData('email', _emailController.text);
    settings.updateUserData('clothingSize', _clothingSizeController.text);
    settings.updateUserData('shoeSize', _shoeSizeController.text);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: Colors.green,
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
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Non-editable fields
                    _buildReadOnlyField('IIN', widget.user.iin),
                    _buildReadOnlyField('Full Name', widget.user.fullName),
                    _buildReadOnlyField('Position', widget.user.position),
                    
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    
                    // Editable fields
                    _buildEditableField(
                      'Phone Number',
                      _phoneController,
                      TextInputType.phone,
                      Icons.phone,
                    ),
                    _buildEditableField(
                      'Email',
                      _emailController,
                      TextInputType.emailAddress,
                      Icons.email,
                    ),
                    _buildEditableField(
                      'Clothing Size',
                      _clothingSizeController,
                      TextInputType.text,
                      Icons.checkroom,
                    ),
                    _buildEditableField(
                      'Shoe Size',
                      _shoeSizeController,
                      TextInputType.text,
                      Icons.directions_walk,
                    ),
                    
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
              color: Colors.blue.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Note: IIN, Full Name, and Position are managed by HR department and cannot be changed here.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue[800],
                          height: 1.4,
                        ),
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
  
  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
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
    String label,
    TextEditingController controller,
    TextInputType keyboardType,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primaryBlue),
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