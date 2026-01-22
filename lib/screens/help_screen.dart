import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/custom_app_bar.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  Future<void> _callSupport(BuildContext context) async {
    final Uri url = Uri.parse('tel:+77770000000');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot make call to support'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'HELP',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'If you have issues with the app or questions, contact support',
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            
            // Support Card (Big - all components huge)
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Logo left (big)
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.support_agent,
                        size: 50,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Support service right (big)
                    Text(
                      'Support Service',
                      style: TextStyle(
                        fontSize: 28, // HUGE
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    
                    // Number bottom (big)
                    Text(
                      '+7 (777) 000-00-00',
                      style: TextStyle(
                        fontSize: 32, // HUGE
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    
                    Text(
                      '24/7 Support Available',
                      style: TextStyle(
                        fontSize: 18, // Big
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    
                    // Call support button bottom of that (big)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _callSupport(context),
                        icon: const Icon(Icons.call, size: 24),
                        label: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          child: Text(
                            'Call Support',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Contact email section
            const SizedBox(height: 40),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.email,
                      size: 40,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Email Support',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'support@company.com',
                      style: TextStyle(
                        fontSize: 18,
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Response time: within 24 hours',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () async {
                        final Uri url = Uri.parse('mailto:support@company.com');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        child: Text('SEND EMAIL'),
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
