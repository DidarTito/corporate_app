import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/user_model.dart';
import '../utils/localization.dart';

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
              // Profile Avatar (photo or placeholder)
              _buildAvatar(context, 60),
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
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    // Position - нормальный размер
                    Text(
                      user.position,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    
                    // IIN - маленький, серый
                    Builder(
                      builder: (context) {
                        final l10n = AppLocalizations.of(context);
                        return Text(
                          '${l10n.iinLabel}: ${user.iin}',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        );
                      },
                    ),
                    // Status badge (Release 2)
                    if (user.status.isNotEmpty && user.status != 'active')
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: _buildStatusChip(context),
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

  Widget _buildAvatar(BuildContext context, double size) {
    final theme = Theme.of(context);
    if (user.photoUrl != null && user.photoUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: CachedNetworkImage(
          imageUrl: user.photoUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            child: Icon(Icons.person, size: size * 0.5, color: theme.colorScheme.primary),
          ),
          errorWidget: (_, __, ___) => Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(size / 2),
            ),
            child: Icon(Icons.person, size: size * 0.5, color: theme.colorScheme.primary),
          ),
        ),
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Icon(Icons.person, size: size * 0.5, color: theme.colorScheme.primary),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String label;
    Color color;
    switch (user.status) {
      case 'vacation':
        label = l10n.statusVacation;
        color = Colors.orange;
        break;
      case 'transfer':
        label = l10n.statusTransfer;
        color = Colors.blue;
        break;
      default:
        label = l10n.statusActive;
        color = Colors.green;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildFullCard(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
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
            _buildAvatar(context, 80),
            const SizedBox(height: 8),
            _buildStatusChip(context),
            const SizedBox(height: 16),
            // User Info
            _buildInfoRow(context, l10n.fullNameLabel, user.fullName, isTitle: true),
            _buildInfoRow(context, l10n.iinLabel, user.iin),
            _buildInfoRow(context, l10n.positionLabel, user.position),
            _buildInfoRow(context, l10n.phoneLabel, user.phoneNumber),
            _buildInfoRow(context, l10n.emailLabel, user.email),
            _buildInfoRow(context, l10n.clothingSizeLabel, user.clothingSize),
            _buildInfoRow(context, l10n.shoeSizeLabel, user.shoeSize),
            // Rating (Release 2)
            if (user.rating != null && user.rating! > 0) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${l10n.ratingLabel}: ', style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 14)),
                  ...List.generate(5, (i) => Icon(
                    i < (user.rating ?? 0).round() ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  )),
                  const SizedBox(width: 8),
                  Text('${user.rating!.toStringAsFixed(1)}/5', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                ],
              ),
            ],
            // Awards (Release 2)
            if (user.awards.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(l10n.awardsLabel, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
              const SizedBox(height: 6),
              ...user.awards.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(Icons.emoji_events, size: 18, color: Colors.amber.shade700),
                    const SizedBox(width: 8),
                    Expanded(child: Text(a, style: const TextStyle(fontSize: 14))),
                  ],
                ),
              )),
            ],
            // Children (Release 2)
            if (user.children.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(l10n.childrenLabel, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
              const SizedBox(height: 6),
              ...user.children.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text('${c.birthDate.day}/${c.birthDate.month}/${c.birthDate.year}', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                      if (c.certificateNumber != null) Text('${c.certificateNumber}', style: TextStyle(fontSize: 12, color: theme.colorScheme.primary)),
                    ],
                  ),
                ),
              )),
            ],
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
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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