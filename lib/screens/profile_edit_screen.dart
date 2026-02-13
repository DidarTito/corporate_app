import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/custom_app_bar.dart';
import '../models/user_model.dart';
import '../models/child_info.dart';
import '../providers/settings_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../utils/localization.dart';
import '../utils/app_snackbars.dart';

class ProfileEditScreen extends StatefulWidget {
  final User user;
  
  const ProfileEditScreen({
    super.key,
    required this.user,
  });

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _clothingSizeController;
  late TextEditingController _shoeSizeController;
  
  // Release 2: Photo, Rating, Awards, Children
  File? _selectedPhoto;
  late double _rating;
  late List<String> _awards;
  late List<ChildInfo> _children;
  final ImagePicker _picker = ImagePicker();
  
  @override
  void initState() {
    super.initState();
    // Инициализируем поля напрямую из текущего пользователя,
    // который уже собран из Firebase / кэша в ProfileScreen.
    _phoneController = TextEditingController(text: widget.user.phoneNumber);
    _emailController = TextEditingController(text: widget.user.email);
    _clothingSizeController =
        TextEditingController(text: widget.user.clothingSize);
    _shoeSizeController = TextEditingController(text: widget.user.shoeSize);
    
    // Release 2 initialization
    _rating = widget.user.rating ?? 0.0;
    _awards = List.from(widget.user.awards);
    _children = List.from(widget.user.children);
  }
  
  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _clothingSizeController.dispose();
    _shoeSizeController.dispose();
    super.dispose();
  }
  
  Future<void> _pickPhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedPhoto = File(pickedFile.path);
      });
    }
  }
  Future<void> _saveChanges(BuildContext context) async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context);

    print('[ProfileEdit] Save started');
    print('[ProfileEdit] Current user UID: ${authProvider.user?.uid}');

    // Получаем новый email
    final newEmail = _emailController.text.trim();

    // Update local settings immediately
    settings.updateUserData('phoneNumber', _phoneController.text);
    settings.updateUserData('email', newEmail);
    settings.updateUserData('clothingSize', _clothingSizeController.text);
    settings.updateUserData('shoeSize', _shoeSizeController.text);

    // Prepare payload to persist
    final Map<String, dynamic> payload = {
      'phoneNumber': _phoneController.text,
      'email': newEmail,
      'clothingSize': _clothingSizeController.text,
      'shoeSize': _shoeSizeController.text,
      'rating': _rating,
      'awards': _awards,
      'children': _children.map((c) => c.toMap()).toList(),
    };
    print('[ProfileEdit] Payload prepared: $payload');

    // If a new photo was selected, upload it to Firebase Storage first
    if (_selectedPhoto != null) {
      try {
        final uid = authProvider.user?.uid;
        if (uid == null || uid.isEmpty) {
          throw Exception('User not available for upload');
        }

        final ref = FirebaseStorage.instance
            .ref()
            .child('users')
            .child(uid)
            .child('avatar_${DateTime.now().millisecondsSinceEpoch}.jpg');

        final uploadTask = ref.putFile(_selectedPhoto!);

        // Show a simple uploading indicator while waiting
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );

        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();

        payload['photoUrl'] = downloadUrl;
        Navigator.pop(context); // close progress dialog
      } catch (e) {
        // Close any progress dialog if open
        try {
          Navigator.pop(context);
        } catch (_) {}

        AppSnackBars.showError(context, l10n.photoUploadFailed);
        return; // abort save
      }
    }

    // Persist to Firebase so data is available across devices
    try {
      print('[ProfileEdit] Saving to Firebase...');
      await authProvider.updateProfile(payload);
      print('[ProfileEdit] Successfully saved to Firebase!');
    } catch (e) {
      print('[ProfileEdit] ERROR saving to Firebase: $e');
      AppSnackBars.showError(context, '${l10n.errorSavingToFirebase}: $e');
      return;
    }

    // Обновляем loginEmail если он отличается
    if (settings.loginEmail != newEmail) {
      settings.saveLoginEmail(newEmail);
    }

    // Show success message
    AppSnackBars.showSuccess(context, l10n.profileUpdatedSuccessfully);

    // Navigate back
    Navigator.pop(context);
  }
  
  void _showSaveConfirmation(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.saveChanges),
        content: Text(l10n.saveChangesQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _saveChanges(context); // Save changes
            },
            child: Text(l10n.saveButton),
          ),
        ],
      ),
    );
  }

void _showAddAwardDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addAward),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: l10n.awardName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _awards.add(controller.text.trim());
                });
                Navigator.pop(context);
              }
            },
            child: Text(l10n.addButton),
          ),
        ],
      ),
    );
  }
  
  void _showAddChildDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final nameController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    final certController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, dialogSetState) => AlertDialog(
          title: Text(l10n.addChild),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: l10n.childName),
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: Text('${l10n.birthDateLabel}: ${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}'),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(1990),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      dialogSetState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: certController,
                  decoration: InputDecoration(hintText: l10n.certificateNumber),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancelButton),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  final child = ChildInfo(
                    name: nameController.text.trim(),
                    birthDate: selectedDate,
                    certificateNumber: certController.text.trim().isEmpty ? null : certController.text.trim(),
                  );
                  setState(() {
                    _children.add(child);
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(l10n.addButton),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = Provider.of<SettingsProvider>(context);
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.editProfileTitle,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Avatar with Photo Upload
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: _selectedPhoto != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.file(_selectedPhoto!, fit: BoxFit.cover),
                                )
                              : Icon(
                                  Icons.person,
                                  size: 50,
                                  color: theme.colorScheme.primary,
                                ),
                        ),
                        // Upload button
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                            onPressed: _pickPhoto,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.uploadPhotoLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Non-editable fields
                    _buildReadOnlyField(context, l10n.iinLabel, widget.user.iin),
                    _buildReadOnlyField(context, l10n.fullNameLabel, widget.user.fullName),
                    _buildReadOnlyField(context, l10n.positionLabel, widget.user.position),
                    
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    
                    // Editable fields
                    _buildEditableField(
                      context,
                      l10n.phoneLabel,
                      _phoneController,
                      TextInputType.phone,
                      Icons.phone,
                    ),
                    _buildEditableField(
                      context,
                      l10n.emailLabel,
                      _emailController,
                      TextInputType.emailAddress,
                      Icons.email,
                    ),
                    _buildEditableField(
                      context,
                      l10n.clothingSizeLabel,
                      _clothingSizeController,
                      TextInputType.text,
                      Icons.checkroom,
                    ),
                    _buildEditableField(
                      context,
                      l10n.shoeSizeLabel,
                      _shoeSizeController,
                      TextInputType.text,
                      Icons.directions_walk,
                    ),
                    
                    // Email source info (debug, можно убрать)
                    if (settings.loginEmail.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Divider(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.info_outline, size: 16, color: AppColors.info),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Email from login: ${settings.loginEmail}',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.info,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    // Save Button (inside card)
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _showSaveConfirmation(context),
                        icon: const Icon(Icons.save),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            l10n.saveChanges,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Release 2: Rating Card
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.ratingLabel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(5, (i) {
                          return IconButton(
                            icon: Icon(
                              i < _rating.round() ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 32,
                            ),
                            onPressed: () {
                              setState(() {
                                _rating = (i + 1).toDouble();
                              });
                            },
                          );
                        }),
                        const SizedBox(width: 16),
                        Text(
                          '${_rating.toStringAsFixed(1)}/5.0',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Release 2: Awards Card
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.awardsLabel,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, color: theme.colorScheme.primary),
                          onPressed: () => _showAddAwardDialog(context),
                        ),
                      ],
                    ),
                    if (_awards.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          l10n.noAwards,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      )
                    else
                      ...List.generate(_awards.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Icon(Icons.emoji_events, size: 18, color: Colors.amber.shade700),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _awards[i],
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, size: 18, color: Colors.red.shade400),
                                onPressed: () {
                                  setState(() {
                                    _awards.removeAt(i);
                                  });
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
            
            // Release 2: Children Card
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.childrenLabel,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, color: theme.colorScheme.primary),
                          onPressed: () => _showAddChildDialog(context),
                        ),
                      ],
                    ),
                    if (_children.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          l10n.noChildren,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      )
                    else
                      ...List.generate(_children.length, (i) {
                        final child = _children[i];
                        final age = DateTime.now().year - child.birthDate.year;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        child.name,
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    PopupMenuButton(
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: Text(l10n.deleteButton),
                                          onTap: () {
                                            setState(() {
                                              _children.removeAt(i);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Born: ${child.birthDate.year}-${child.birthDate.month.toString().padLeft(2, '0')}-${child.birthDate.day.toString().padLeft(2, '0')} (Age: $age)',
                                  style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                                ),
                                if (child.certificateNumber != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Certificate: ${child.certificateNumber}',
                                    style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
            
            // Note
            const SizedBox(height: 20),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: AppColors.info.withValues(alpha: 0.05),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.info, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.hrManagedFieldsNote,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.info,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.emailLoginNote,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.info.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
  
  Widget _buildReadOnlyField(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
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
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEditableField(
    BuildContext context,
    String label,
    TextEditingController controller,
    TextInputType keyboardType,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
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
            flex: 2,
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                prefixIcon: Icon(icon, size: 20),
                isDense: true,
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}