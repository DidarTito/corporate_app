import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/app_widgets.dart';
import '../utils/localization.dart';
import '../models/finance_model.dart';
import '../utils/constants.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  FinanceInfo? _financeInfo;
  bool _isLoading = true;
  
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadFinanceInfo();
  }

  Future<void> _loadFinanceInfo() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        _loadMockData();
        return;
      }

      // Try to load user's finance data from Firebase
      final financeDoc = await _db.collection('users').doc(user.uid).collection('finance').doc('info').get();
      
      if (financeDoc.exists) {
        setState(() {
          _financeInfo = FinanceInfo.fromMap(financeDoc.data() ?? {});
        });
      } else {
        _loadMockData();
      }
    } catch (e) {
      // Fallback to mock data
      _loadMockData();
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  void _loadMockData() {
    // TODO: Load from Firebase
    // For now, use mock data
    setState(() {
      _financeInfo = FinanceInfo(
        currentObject: 'Project Alpha',
        totalShiftsWorked: 45,
        trainingDeductions: 5000.0,
        totalBalance: 150000.0,
        history: [
          FinanceHistoryItem(
            id: '1',
            objectName: 'Project Alpha',
            completedVolume: 1000.0,
            payment: 50000.0,
            date: DateTime.now().subtract(const Duration(days: 30)),
            shiftsWorked: 15,
          ),
          FinanceHistoryItem(
            id: '2',
            objectName: 'Project Beta',
            completedVolume: 800.0,
            payment: 40000.0,
            date: DateTime.now().subtract(const Duration(days: 60)),
            shiftsWorked: 12,
          ),
          FinanceHistoryItem(
            id: '3',
            objectName: 'Project Gamma',
            completedVolume: 1200.0,
            payment: 60000.0,
            date: DateTime.now().subtract(const Duration(days: 90)),
            shiftsWorked: 18,
          ),
        ],
      );
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.financeTitle,
        showBackButton: true,
      ),
      body: _isLoading
          ? const AppLoadingIndicator()
          : _financeInfo == null
              ? AppEmptyStateWidget(
                  title: l10n.noResults,
                  icon: Icons.account_balance_wallet_outlined,
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Current Object Card
                      if (_financeInfo!.currentObject != null)
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.business,
                                        color: theme.colorScheme.primary),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.currentObject,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _financeInfo!.currentObject!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 16),

                      // Summary Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildSummaryCard(
                              context,
                              l10n.totalShifts,
                              '${_financeInfo!.totalShiftsWorked}',
                              Icons.work,
                              AppColors.info,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSummaryCard(
                              context,
                              l10n.trainingDeductions,
                              '${_financeInfo!.trainingDeductions.toStringAsFixed(0)} ₸',
                              Icons.school,
                              AppColors.warning,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Total Balance Card
                      Card(
                        elevation: 3,
                        color: AppColors.success.withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: AppColors.success.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                l10n.totalBalance,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${_financeInfo!.totalBalance.toStringAsFixed(2)} ₸',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // History Section
                      Text(
                        l10n.historyLabel,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // History List
                      ..._financeInfo!.history.map((item) => Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.objectName,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: theme.colorScheme.onSurface,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${item.payment.toStringAsFixed(2)} ₸',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.success,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today,
                                          size: 14,
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.6)),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${item.date.day}/${item.date.month}/${item.date.year}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Icon(Icons.work,
                                          size: 14,
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.6)),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${item.shiftsWorked} ${l10n.shiftsWorkedLabel.toLowerCase()}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${l10n.completedVolume}: ${item.completedVolume.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
