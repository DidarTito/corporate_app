import 'package:flutter/material.dart';
import 'notifications_screen.dart';
import 'contacts_screen.dart';
import 'help_screen.dart';
import 'profile_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/profile_card.dart';
import '../data/mock_data.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  // Теперь у нас 2 экрана: Home и Profile
  final List<Widget> _screens = [
    const _HomeContent(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Главный контент HomeScreen
class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final user = mockUser;
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Card (Minimized) - клик переключает на Profile через BottomNav
            ProfileCard(
              user: user,
              onPressed: () {
                // Получаем родительский HomeScreenState и меняем selectedIndex
                final homeState = context.findAncestorStateOfType<_HomeScreenState>();
                if (homeState != null) {
                  homeState.setState(() {
                    homeState._selectedIndex = 1; // Переключаем на Profile
                  });
                }
              },
              minimized: true,
            ),
            const SizedBox(height: 30),
            
            // Quick Actions Title
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
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
                  label: 'Help',
                  color: Colors.orange,
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
                  label: 'Contacts',
                  color: Colors.green,
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
                    const Icon(
                      Icons.business,
                      size: 40,
                      color: AppColors.primaryBlue,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Welcome to Corporate App',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Everything you need in one place',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
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
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3)),
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