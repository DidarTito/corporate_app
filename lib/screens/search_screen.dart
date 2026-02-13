import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/localization.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_widgets.dart';
import '../data/contacts_data.dart';
import '../data/mock_data.dart';

/// Release 2: Search across profile (name), news, contacts.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _query = TextEditingController();
  List<_SearchResult> _results = [];
  bool _searched = false;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  void _runSearch(String q) {
    if (q.trim().isEmpty) {
      setState(() {
        _results = [];
        _searched = true;
      });
      return;
    }
    final lower = q.trim().toLowerCase();
    final list = <_SearchResult>[];
    final auth = context.read<AuthProvider>();
    final name = auth.user?.displayName ?? '';
    final email = auth.user?.email ?? '';
    if (name.toLowerCase().contains(lower)) {
      list.add(_SearchResult(_SearchType.profile, 'Profile', name, ''));
    }
    if (email.toLowerCase().contains(lower)) {
      list.add(_SearchResult(_SearchType.profile, 'Profile', email, ''));
    }
    // News (mock)
    for (final n in mockNotifications) {
      if (n.title.toLowerCase().contains(lower) || n.description.toLowerCase().contains(lower)) {
        list.add(_SearchResult(_SearchType.news, n.title, n.description, n.id));
      }
    }
    // Contacts
    for (final c in departmentContacts) {
      if (c.department.toLowerCase().contains(lower) ||
          (c.description.toLowerCase().contains(lower))) {
        list.add(_SearchResult(_SearchType.contact, c.department, c.phoneNumber, c.description));
      }
    }
    setState(() {
      _results = list;
      _searched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _query,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.searchHint,
            border: InputBorder.none,
          ),
          onSubmitted: _runSearch,
          onChanged: (v) {
            if (v.trim().isEmpty) setState(() => _results = []);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _runSearch(_query.text),
          ),
        ],
      ),
      body: _results.isEmpty && !_searched
          ? AppEmptyStateWidget(
              title: l10n.searchHint,
              icon: Icons.search,
            )
          : _results.isEmpty
              ? AppEmptyStateWidget(
                  title: l10n.noResults,
                  icon: Icons.inbox_outlined,
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _results.length,
                  itemBuilder: (context, i) {
                    final r = _results[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(
                          r.type == _SearchType.profile
                              ? Icons.person
                              : r.type == _SearchType.news
                                  ? Icons.newspaper
                                  : Icons.contacts,
                          color: theme.colorScheme.primary,
                        ),
                        title: Text(r.title),
                        subtitle: r.subtitle.isNotEmpty ? Text(r.subtitle, maxLines: 2) : null,
                      ),
                    );
                  },
                ),
    );
  }
}

enum _SearchType { profile, news, contact }

class _SearchResult {
  final _SearchType type;
  final String title;
  final String subtitle;
  final String id;

  _SearchResult(this.type, this.title, this.subtitle, this.id);
}
