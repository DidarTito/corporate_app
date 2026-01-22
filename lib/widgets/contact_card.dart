import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ContactCard extends StatelessWidget {
  final String department;
  final String phoneNumber;
  final IconData icon;
  final String description;
  final VoidCallback onCall;
  
  const ContactCard({
    super.key,
    required this.department,
    required this.phoneNumber,
    required this.icon,
    required this.description,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Logo/Icon left
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.primaryBlue),
                ),
                const SizedBox(width: 16),
                
                // Department Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        department,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        phoneNumber,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Description
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 66),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.grey,
                ),
              ),
            ),
            
            // Call Button bottom right
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                onPressed: onCall,
                icon: const Icon(Icons.call, size: 16),
                label: const Text('CALL'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
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