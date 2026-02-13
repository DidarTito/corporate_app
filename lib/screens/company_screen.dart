import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/localization.dart';
import '../utils/app_snackbars.dart';
import '../models/news_model.dart';
import '../models/project_vacancy_model.dart';
import '../models/training_material_model.dart';
import '../utils/constants.dart';
import '../widgets/app_widgets.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<NewsItem> _news = [];
  List<ProjectVacancy> _vacancies = [];
  List<TrainingMaterial> _trainingMaterials = [];
  bool _isLoading = true;
  
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      // Try to load from Firebase
      final newsSnapshot = await _db.collection('news').orderBy('publishDate', descending: true).limit(10).get();
      final vacanciesSnapshot = await _db.collection('vacancies').orderBy('publishDate', descending: true).limit(10).get();
      final materialsSnapshot = await _db.collection('training_materials').orderBy('publishDate', descending: true).limit(10).get();
      
      setState(() {
        _news = newsSnapshot.docs.map((doc) => NewsItem.fromMap(doc.data())).toList();
        _vacancies = vacanciesSnapshot.docs.map((doc) => ProjectVacancy.fromMap(doc.data())).toList();
        _trainingMaterials = materialsSnapshot.docs.map((doc) => TrainingMaterial.fromMap(doc.data())).toList();
      });
    } catch (e) {
      // Fallback to mock data if Firebase fails
      _loadMockData();
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  void _loadMockData() {
    // TODO: Load from Firebase
    // Mock data for now
    setState(() {
      _news = [
        NewsItem(
          id: '1',
          title: 'Company Expansion Announcement',
          content: 'We are excited to announce the opening of new offices...',
          imageUrl: null,
          publishDate: DateTime.now().subtract(const Duration(days: 2)),
          author: 'HR Department',
          isCorporate: true,
        ),
        NewsItem(
          id: '2',
          title: 'Team Building Event',
          content: 'Join us for the annual team building event...',
          imageUrl: null,
          publishDate: DateTime.now().subtract(const Duration(days: 5)),
          author: 'Events Team',
          isCorporate: true,
        ),
      ];
      _vacancies = [
        ProjectVacancy(
          id: '1',
          title: 'Construction Project Manager',
          description: 'Looking for experienced project manager...',
          location: 'Almaty',
          latitude: 43.2220,
          longitude: 76.8512,
          projectType: 'construction',
          publishDate: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ProjectVacancy(
          id: '2',
          title: 'Installation Specialist',
          description: 'Join our installation team...',
          location: 'Astana',
          latitude: 51.1694,
          longitude: 71.4491,
          projectType: 'installation',
          publishDate: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];
      _trainingMaterials = [
        TrainingMaterial(
          id: '1',
          title: 'Safety Guidelines for Masters',
          description: 'Important safety procedures...',
          category: 'master',
          publishDate: DateTime.now().subtract(const Duration(days: 10)),
          isMemo: true,
        ),
        TrainingMaterial(
          id: '2',
          title: 'Installation Best Practices',
          description: 'Learn best practices for installation...',
          category: 'installer',
          publishDate: DateTime.now().subtract(const Duration(days: 15)),
          isMemo: false,
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.companyTitle),
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.companyNews),
            Tab(text: l10n.projectRecruitment),
            Tab(text: l10n.trainingMaterials),
          ],
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          indicatorSize: TabBarIndicatorSize.label,
        ),
      ),
      body: _isLoading
          ? const AppLoadingIndicator()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildNewsTab(context, l10n),
                _buildVacanciesTab(context, l10n),
                _buildTrainingTab(context, l10n),
              ],
            ),
    );
  }

  Widget _buildNewsTab(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return _news.isEmpty
        ? AppEmptyStateWidget(
            title: l10n.noResults,
            icon: Icons.newspaper_outlined,
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _news.length,
            itemBuilder: (context, index) {
              final news = _news[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // News image or video placeholder
                    if (news.imageUrl != null && news.imageUrl!.isNotEmpty)
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.network(
                              news.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 40,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    else if (news.videoUrl != null && news.videoUrl!.isNotEmpty)
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.video_library,
                              size: 60,
                              color: theme.colorScheme.primary,
                            ),
                            Positioned(
                              bottom: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Video',
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    // News content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            news.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            news.content,
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      news.author,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${news.publishDate.day}/${news.publishDate.month}/${news.publishDate.year}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (news.tags.isNotEmpty)
                                Wrap(
                                  spacing: 4,
                                  children: news.tags.take(2).map((tag) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        tag,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }

  Widget _buildVacanciesTab(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return _vacancies.isEmpty
        ? AppEmptyStateWidget(
            title: l10n.noResults,
            icon: Icons.work_outline,
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _vacancies.length,
            itemBuilder: (context, index) {
              final vacancy = _vacancies[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location Map placeholder
                    Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Map background (simplified)
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  theme.colorScheme.primary.withValues(alpha: 0.1),
                                  theme.colorScheme.primary.withValues(alpha: 0.05),
                                ],
                              ),
                            ),
                          ),
                          // Location pin
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.error,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                vacancy.location,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '(${vacancy.latitude?.toStringAsFixed(2) ?? 'N/A'}, ${vacancy.longitude?.toStringAsFixed(2) ?? 'N/A'})',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Vacancy details
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vacancy.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            vacancy.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Chip(
                                label: Text(vacancy.projectType),
                                backgroundColor: AppColors.info.withValues(alpha: 0.1),
                                labelStyle: TextStyle(
                                  color: AppColors.info,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '${vacancy.publishDate.day}/${vacancy.publishDate.month}/${vacancy.publishDate.year}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                AppSnackBars.showSuccess(context, l10n.applyForThisVacancy);
                              },
                              icon: const Icon(Icons.check_circle),
                              label: Text(l10n.applyNow),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }

  Widget _buildTrainingTab(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final memos = _trainingMaterials.where((m) => m.isMemo).toList();
    final materials = _trainingMaterials.where((m) => !m.isMemo).toList();

    if (memos.isEmpty && materials.isEmpty) {
      return AppEmptyStateWidget(
        title: l10n.noResults,
        icon: Icons.school_outlined,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Memos Section
          if (memos.isNotEmpty) ...[
            Text(
              l10n.memosLabel,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            ...memos.map((memo) => _buildTrainingCard(context, memo, l10n)),
            const SizedBox(height: 24),
          ],
          // Training Materials Section
          if (materials.isNotEmpty) ...[
            Text(
              l10n.trainingMaterials,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            ...materials.map((material) => _buildTrainingCard(context, material, l10n)),
          ],
        ],
      ),
    );
  }

  Widget _buildTrainingCard(
      BuildContext context, TrainingMaterial material, AppLocalizations l10n) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image or Icon header
          Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: material.imageUrl != null && material.imageUrl!.isNotEmpty
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        material.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              material.isMemo ? Icons.note : Icons.school,
                              size: 50,
                              color: theme.colorScheme.primary,
                            ),
                          );
                        },
                      ),
                      if (material.isMemo)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              l10n.memo,
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ),
                        ),
                    ],
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.colorScheme.primary.withValues(alpha: 0.1),
                              theme.colorScheme.primary.withValues(alpha: 0.05),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            material.isMemo ? Icons.note : Icons.school,
                            size: 50,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            material.isMemo ? l10n.memo : l10n.trainingMaterial,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
          
          // Material details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      material.isMemo ? Icons.note : Icons.school,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        material.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  material.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        material.category,
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '${material.publishDate.day}/${material.publishDate.month}/${material.publishDate.year}',
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (material.fileUrl != null && material.fileUrl!.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        AppSnackBars.showInfo(context, '${l10n.openingMessage} ${material.isMemo ? l10n.memo.toLowerCase() : l10n.trainingMaterial.toLowerCase()}...');
                      },
                      icon: const Icon(Icons.file_download),
                      label: Text(material.isMemo ? l10n.viewMemo : l10n.downloadMaterial),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}