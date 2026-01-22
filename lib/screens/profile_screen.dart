import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_edit_screen.dart';
import 'settings_screen.dart';
import '../widgets/profile_card.dart';
import '../data/mock_data.dart'; // This imports User class and mockUser getter
import '../providers/settings_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = mockUser; // Use the getter function
    final settings = Provider.of<SettingsProvider>(context);
    
    // Используем email из логина, если он есть, иначе из mock данных
    final loginEmail = settings.loginEmail.isNotEmpty 
        ? settings.loginEmail 
        : user.email;
    
    // Merge mock user with editable data from settings
    final mergedUser = user.copyWith(
      phoneNumber: settings.userData['phoneNumber'] ?? user.phoneNumber,
      email: loginEmail, // Используем email из логина
      clothingSize: settings.userData['clothingSize'] ?? user.clothingSize,
      shoeSize: settings.userData['shoeSize'] ?? user.shoeSize,
    );
    
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Debug info (можно убрать в релизе)
            if (settings.loginEmail.isNotEmpty) ...[
              const SizedBox(height: 20),
              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Logged in as: ${settings.loginEmail}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
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
                onPressed: () async {
                  // Ожидаем результат редактирования
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileEditScreen(user: mergedUser),
                    ),
                  );
                  // Принудительно обновляем состояние
                  // Provider автоматически обновит через notifyListeners
                },
                icon: const Icon(Icons.edit),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 16),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}