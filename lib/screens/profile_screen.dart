import 'package:corporate_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notifications_screen.dart';
import 'profile_edit_screen.dart';
import 'settings_screen.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/profile_card.dart';
import '../data/mock_data.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = mockUser;
    final settings = Provider.of<SettingsProvider>(context);
    
    // Merge mock user with editable data from settings
    final mergedUser = user.copyWith(
      phoneNumber: settings.userData['phoneNumber'] ?? user.phoneNumber,
      email: settings.userData['email'] ?? user.email,
      clothingSize: settings.userData['clothingSize'] ?? user.clothingSize,
      shoeSize: settings.userData['shoeSize'] ?? user.shoeSize,
    );
    
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Full Profile Card with updated data
            ProfileCard(
              user: mergedUser,
              minimized: false,
            ),
            const SizedBox(height: 30),
            
            // Edit Profile Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileEditScreen(user: mergedUser),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Edit Profile',
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
            const SizedBox(height: 16),
            
            // Settings Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.settings),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Settings',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primaryBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension to copy User with updated fields
extension UserCopyWith on User {
  User copyWith({
    String? phoneNumber,
    String? email,
    String? clothingSize,
    String? shoeSize,
  }) {
    return User(
      id: id,
      username: username,
      email: email ?? this.email,
      fullName: fullName,
      iin: iin,
      position: position,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      clothingSize: clothingSize ?? this.clothingSize,
      shoeSize: shoeSize ?? this.shoeSize,
    );
  }
}