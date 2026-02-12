import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_edit_screen.dart';
import 'settings_screen.dart';
import '../widgets/profile_card.dart';
import '../data/mock_data.dart';
import '../providers/settings_provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';
import '../utils/localization.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final l10n = AppLocalizations.of(context);

    if (auth.user == null) {
      return Scaffold(
        body: Center(
          child: Text(l10n.pleaseLoginToViewProfile),
        ),
      );
    }

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: auth.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // We always try to show something, even if Firestore fails.
          final data = snapshot.data ?? <String, dynamic>{};
          final authEmail = auth.user?.email ?? '';
          
          // Create a User object from Firebase data and mock user
          final baseUser = mockUser;
          final userFromFirebase = baseUser.copyWith(
            fullName: (data['name'] ?? baseUser.fullName) as String,
            email: (data['email'] ?? authEmail ?? baseUser.email) as String,
            phoneNumber: (data['phoneNumber'] ??
                    settings.userData['phoneNumber'] ??
                    baseUser.phoneNumber) as String,
            clothingSize: (data['clothingSize'] ??
                    settings.userData['clothingSize'] ??
                    baseUser.clothingSize) as String,
            shoeSize: (data['shoeSize'] ??
                    settings.userData['shoeSize'] ??
                    baseUser.shoeSize) as String,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Debug info
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
                            '${l10n.loggedInAs} ${data['email'] ?? authEmail ?? 'User'}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Full Profile Card with Firebase data
                ProfileCard(
                  user: userFromFirebase,
                  minimized: false,
                ),
                const SizedBox(height: 30),

                // Edit Profile Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileEditScreen(user: userFromFirebase),
                        ),
                      );
                      setState(() {});
                    },
                    icon: const Icon(Icons.edit),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        l10n.editProfileButton,
                        style: const TextStyle(fontSize: 16),
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
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        l10n.settingsButton,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}