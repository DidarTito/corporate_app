import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/app_widgets.dart';
import '../utils/localization.dart';
import '../utils/app_snackbars.dart';
import '../providers/auth_provider.dart';

/// Release 2: Simple online chat UI (mock messages; backend TBD).
class ChatScreen extends StatefulWidget {
  final String title;
  final String? subtitle;

  const ChatScreen({
    super.key,
    this.title = 'Chat',
    this.subtitle,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final uid = auth.user?.uid;
    if (uid == null) {
      // cannot send without auth
      AppSnackBars.showError(context, AppLocalizations.of(context).cannotCallSupport);
      return;
    }

    final messagesRef = FirebaseFirestore.instance
        .collection('support_chats')
        .doc(uid)
        .collection('messages');

    try {
      await messagesRef.add({
        'text': text,
        'fromUid': uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _input.clear();
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scroll.hasClients) {
          _scroll.animateTo(
            _scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      AppSnackBars.showError(context, AppLocalizations.of(context).failedToSendMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        showBackButton: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                final auth = Provider.of<AuthProvider>(context, listen: false);
                final uid = auth.user?.uid;
                if (uid == null) {
                  return AppEmptyStateWidget(
                    title: 'Please log in',
                    subtitle: AppLocalizations.of(context).pleaseLoginToViewProfile,
                    icon: Icons.lock_outline,
                  );
                }

                final messagesStream = FirebaseFirestore.instance
                    .collection('support_chats')
                    .doc(uid)
                    .collection('messages')
                    .orderBy('createdAt', descending: false)
                    .snapshots();

                return StreamBuilder<QuerySnapshot>(
                  stream: messagesStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const AppLoadingIndicator();
                    }
                    final docs = snapshot.data?.docs ?? [];
                    if (docs.isEmpty) {
                      return AppEmptyStateWidget(
                        title: 'No messages yet',
                        subtitle: 'Start a conversation with support',
                        icon: Icons.chat,
                      );
                    }
                    return ListView.builder(
                      controller: _scroll,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: docs.length,
                      itemBuilder: (context, i) {
                        final d = docs[i];
                        final data = d.data() as Map<String, dynamic>;
                        final text = data['text'] as String? ?? '';
                        final fromUid = data['fromUid'] as String? ?? '';
                        final ts = data['createdAt'] as Timestamp?;
                        final time = ts?.toDate() ?? DateTime.now();
                        final isMe = fromUid == uid;

                        return Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? theme.colorScheme.primary.withValues(alpha: 0.2)
                                  : theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(text, style: const TextStyle(fontSize: 15)),
                                const SizedBox(height: 4),
                                Text(
                                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _input,
                    decoration: InputDecoration(
                      hintText: l10n.typeMessage,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _send,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// _ChatMessage class removed; chat now uses Firestore-backed messages
