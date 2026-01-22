import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ProfileCard extends StatelessWidget {
  final User user;
  final VoidCallback? onPressed;
  final bool minimized;

  const ProfileCard({
    super.key,
    required this.user,
    this.onPressed,
    this.minimized = true,
  });

  @override
  Widget build(BuildContext context) {
    if (minimized) {
      return _buildMinimizedCard(context);
    } else {
      return _buildFullCard(context);
    }
  }

  Widget _buildMinimizedCard(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Profile Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              
              // User Info - 1:2 или 1:3 пропорции
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name - больше и жирнее
                    Text(
                      user.fullName,
                      style: TextStyle(
                        fontSize: 18, // Увеличили
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6), // Увеличили отступ
                    
                    // Email - нормальный размер
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    // Position - нормальный размер
                    Text(
                      user.position,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    
                    // IIN - маленький, серый
                    Text(
                      'IIN: ${user.iin}',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullCard(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Avatar (bigger)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.person,
                size: 40,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            
            // User Info - правильные пропорции (1:3)
            _buildInfoRow(context, 'Full Name', user.fullName, isTitle: true),
            _buildInfoRow(context, 'IIN', user.iin),
            _buildInfoRow(context, 'Position', user.position),
            _buildInfoRow(context, 'Phone Number', user.phoneNumber),
            _buildInfoRow(context, 'Email', user.email),
            _buildInfoRow(context, 'Clothing Size', user.clothingSize),
            _buildInfoRow(context, 'Shoe Size', user.shoeSize),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, {bool isTitle = false}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10), // Увеличили отступ
      child: Row(
        children: [
          Expanded(
            flex: 1, // 1 часть для лейбла
            child: Text(
              label,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2, // 2 части для значения (1:2 пропорция)
            child: Text(
              value,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: isTitle ? 16 : 14,
                fontWeight: isTitle ? FontWeight.w600 : FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}