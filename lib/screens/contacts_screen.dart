import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/custom_app_bar.dart';
import '../data/contacts_data.dart';
import '../widgets/contact_card.dart';
import '../utils/constants.dart';
import '../utils/localization.dart';
import '../utils/app_snackbars.dart';
import 'chat_screen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {

  Future<void> _makeCall(BuildContext context, String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Fallback for web or unsupported platforms
      if (context.mounted) {
        final l10n = AppLocalizations.of(context);
        // ignore: use_build_context_synchronously
        AppSnackBars.showError(context, l10n.cannotCall(phoneNumber));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.contactsTitle,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Release 2: Online Chat
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(Icons.chat, color: theme.colorScheme.primary),
                title: Text(l10n.onlineChat),
                subtitle: Text(l10n.faqTitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ChatScreen(title: l10n.onlineChat, subtitle: l10n.contactsTitle),
                  ));
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.selectDepartmentToCall,
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // List of department contacts
            ...departmentContacts.map((contact) => ContactCard(
              department: contact.department,
              phoneNumber: contact.phoneNumber,
              icon: _getIconFromString(contact.icon),
              description: contact.description,
              onCall: () => _makeCall(context, contact.phoneNumber),
            )),
            
            // Emergency contact section
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),
            Text(
              l10n.emergencyContacts,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            // Emergency contact card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: AppColors.error.withValues(alpha: 0.3), width: 1),
              ),
              color: AppColors.error.withValues(alpha: 0.05),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(
                      Icons.emergency,
                      size: 40,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.emergencyServices,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.generalEmergency,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.ambulance,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _makeCall(context, '112'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(150, 45),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.emergency_outlined),
                          const SizedBox(width: 8),
                          Text(l10n.emergencyCall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Release 2: FAQ
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              l10n.faqTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            _FaqTile(
              question: 'Как связаться с HR отделом?',
              answer: 'Позвоните по номеру отдела кадров из списка контактов выше или воспользуйтесь онлайн-чатом.',
            ),
            _FaqTile(
              question: 'Как оформить отпуск?',
              answer: 'Обратитесь в HR отдел с заявлением. Документы можно подать через корпоративный портал.',
            ),
            _FaqTile(
              question: 'Где посмотреть график смен?',
              answer: 'График смен доступен в разделе "Финансы" и у вашего непосредственного руководителя.',
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'people':
        return Icons.people;
      case 'computer':
        return Icons.computer;
      case 'attach_money':
        return Icons.attach_money;
      case 'security':
        return Icons.security;
      case 'home_repair_service':
        return Icons.home_repair_service;
      case 'gavel':
        return Icons.gavel;
      default:
        return Icons.help_outline;
    }
  }
}

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;

  const _FaqTile({required this.question, required this.answer});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 8),
                Text(
                  widget.answer,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}