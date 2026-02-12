import 'package:corporate_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notifications_screen.dart';
import 'contacts_screen.dart';
import 'help_screen.dart';
import 'profile_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/profile_card.dart';
import '../data/mock_data.dart';
import '../utils/constants.dart';
import '../utils/localization.dart';
import '../providers/settings_provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    
    final List<Widget> screens = [
      _HomeContent(auth: auth),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: HomeAppBar(
        onNotificationPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotificationsScreen(),
            ),
          );
        },
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

// Главный контент HomeScreen
class _HomeContent extends StatelessWidget {
  final AuthProvider auth;
  
  const _HomeContent({required this.auth});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Logged-in User Card
            if (auth.user != null)
              FutureBuilder<Map<String, dynamic>?>(
                future: auth.getProfile(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Always show at least Gmail/email from auth, even if Firestore fails
                  final data = snapshot.data ?? <String, dynamic>{};
                  final authEmail = auth.user?.email ?? 'No email';
                  final name = (data['name'] ?? 'User') as String;
                  final email = (data['email'] ?? authEmail) as String;

                  final baseUser = mockUser;
                  final userFromFirebase = baseUser.copyWith(
                    fullName: name,
                    email: email,
                  );

                  return ProfileCard(
                    user: userFromFirebase,
                    minimized: true,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  );
                },
              ),
            const SizedBox(height: 30),
            
            // Quick Actions Title
            Text(
              l10n.quickActionsTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            
            // Help and Contacts Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Help Button
                _ActionButton(
                  icon: Icons.help_outline,
                  label: l10n.helpLabel,
                  color: AppColors.warning,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpScreen(),
                      ),
                    );
                  },
                ),
                
                // Contacts Button
                _ActionButton(
                  icon: Icons.contacts,
                  label: l10n.contactsLabel,
                  color: AppColors.success,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContactsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            // Welcome Message
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.business,
                      size: 40,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.welcomeHomeTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.welcomeHomeSubtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: IconButton(
            icon: Icon(icon, size: 36, color: color),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}