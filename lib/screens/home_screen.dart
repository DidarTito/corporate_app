import 'package:corporate_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'notifications_screen.dart';
import 'contacts_screen.dart';
import 'help_screen.dart';
import 'profile_screen.dart';
import 'finance_screen.dart';
import 'company_screen.dart';
import 'search_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/profile_card.dart';
import '../widgets/app_widgets.dart';
import '../data/mock_data.dart';
import '../utils/constants.dart';
import '../utils/localization.dart';
import '../utils/app_snackbars.dart';
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
        onSearchPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
        },
        onNotificationPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
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
                    return const AppLoadingIndicator();
                  }

                  // Always show at least Gmail/email from auth, even if Firestore fails
                  final data = snapshot.data ?? <String, dynamic>{};
                  final authEmail = auth.user?.email ?? 'No email';
                  final name = (data['name'] ?? 'User') as String;
                  final email = (data['email'] ?? authEmail) as String;

                  final baseUser = mockUser;
                  final merged = <String, dynamic>{
                    ...data,
                    'name': name,
                    'email': email,
                  };
                  final userFromFirebase = User.fromProfileMap(baseUser, merged);

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
            const SizedBox(height: 20),
            // Release 2: Status, Balance, Shifts (when user loaded)
            if (auth.user != null) _StatusBalanceShiftsStrip(auth: auth),
            const SizedBox(height: 20),
            // Quick Actions Title
            Text(
              l10n.quickActionsTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            // Help, Contacts, Finance, Company
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: Icons.help_outline,
                  label: l10n.helpLabel,
                  color: AppColors.warning,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpScreen()));
                  },
                ),
                _ActionButton(
                  icon: Icons.contacts,
                  label: l10n.contactsLabel,
                  color: AppColors.success,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactsScreen()));
                  },
                ),
                _ActionButton(
                  icon: Icons.account_balance_wallet,
                  label: l10n.financeTitle,
                  color: AppColors.info,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FinanceScreen()));
                  },
                ),
                _ActionButton(
                  icon: Icons.business_center,
                  label: l10n.companyTitle,
                  color: theme.colorScheme.primary,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CompanyScreen()));
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Bonus & Referral (Release 2)
            _BonusReferralSection(),
            const SizedBox(height: 24),
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
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: IconButton(
            icon: Icon(icon, size: 28, color: color),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ],
    );
  }
}

/// Release 2: status, balance, shifts strip (uses profile data).
class _StatusBalanceShiftsStrip extends StatelessWidget {
  final AuthProvider auth;

  const _StatusBalanceShiftsStrip({required this.auth});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder<Map<String, dynamic>?>(
      future: auth.getProfile(),
      builder: (context, snapshot) {
        final data = snapshot.data ?? <String, dynamic>{};
        final status = data['status'] as String? ?? 'active';
        final balance = (data['balance'] as num?)?.toDouble() ?? 0.0;
        final shifts = data['shiftsWorked'] as int? ?? 0;
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _stripChip(context, l10n.statusLabel, status == 'vacation' ? l10n.statusVacation : status == 'transfer' ? l10n.statusTransfer : l10n.statusActive, Icons.person),
                _stripChip(context, l10n.balanceLabel, '${balance.toStringAsFixed(0)} ₸', Icons.account_balance_wallet),
                _stripChip(context, l10n.shiftsWorkedLabel, '$shifts', Icons.work),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _stripChip(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        Text(label, style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
      ],
    );
  }
}

/// Release 2: bonus points and referral link.
class _BonusReferralSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    // Mock referral code/link
    const referralCode = 'REF-2024-USER';
    final referralLink = 'https://app.company.com/ref/$referralCode';
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.card_giftcard, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(l10n.bonusLabel, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            Text('${l10n.bonusPoints}: 1,250', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(l10n.referralProgram, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(l10n.referralCode, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.7))),
            SelectableText(referralCode, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: referralLink));
                AppSnackBars.showSuccess(context, l10n.linkCopied);
              },
              icon: const Icon(Icons.copy, size: 18),
              label: Text(l10n.copyLink),
            ),
          ],
        ),
      ),
    );
  }
}