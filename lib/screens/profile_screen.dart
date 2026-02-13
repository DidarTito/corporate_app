import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_edit_screen.dart';
import 'settings_screen.dart';
import '../widgets/profile_card.dart';
import '../widgets/app_widgets.dart';
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
            return const AppLoadingIndicator();
          }

          // We always try to show something, even if Firestore fails.
          final data = snapshot.data ?? <String, dynamic>{};
          final authEmail = auth.user?.email ?? '';
          // Merge settings into data for fallback
          final merged = <String, dynamic>{
            ...data,
            'email': data['email'] ?? authEmail,
            'phoneNumber': data['phoneNumber'] ?? settings.userData['phoneNumber'],
            'clothingSize': data['clothingSize'] ?? settings.userData['clothingSize'],
            'shoeSize': data['shoeSize'] ?? settings.userData['shoeSize'],
          };
          final baseUser = mockUser;
          final userFromFirebase = User.fromProfileMap(baseUser, merged);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
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