import 'package:flutter/material.dart';
import '../utils/localization.dart';

class FAQItem {
  final String question;
  final String answer;
  bool isExpanded;

  FAQItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}

class FAQWidget extends StatefulWidget {
  final bool compact;

  const FAQWidget({
    super.key,
    this.compact = true,
  });

  @override
  State<FAQWidget> createState() => _FAQWidgetState();
}

class _FAQWidgetState extends State<FAQWidget> {
  late List<FAQItem> faqItems;

  @override
  void initState() {
    super.initState();
    _initializeFAQ();
  }

  void _initializeFAQ() {
    faqItems = [
      FAQItem(
        question: 'Как изменить свой профиль?',
        answer: 'Перейдите в раздел "Профиль" и нажмите на кнопку "Редактировать". Вы можете обновить свой телефон, электронную почту и другую информацию.',
      ),
      FAQItem(
        question: 'Могу ли я загрузить свою фотографию?',
        answer: 'Да, в экране редактирования профиля нажмите на значок камеры рядом с вашей фотографией, чтобы загрузить новый аватар.',
      ),
      FAQItem(
        question: 'Как узнать свой баланс бонусов?',
        answer: 'Информация о бонусах отображается на главной странице в разделе "Бонусы и реферальная программа".',
      ),
      FAQItem(
        question: 'Как использовать реферальную программу?',
        answer: 'Скопируйте вашу реферальную ссылку на главной странице и поделитесь ею с друзьями. За каждого приглашённого человека вы получите бонусные баллы.',
      ),
      FAQItem(
        question: 'Где я могу увидеть свою историю зарплаты?',
        answer: 'В разделе "Финансы" вы найдёте полную историю выплат, отработанные смены и удержания за обучение.',
      ),
      FAQItem(
        question: 'Как связаться со службой поддержки?',
        answer: 'Вы можете позвонить по номеру +7 (777) 000-00-00, отправить письмо на support@company.com или использовать онлайн-чат в разделе "Помощь".',
      ),
      FAQItem(
        question: 'Как найти информацию о вакансиях?',
        answer: 'В разделе "Компания" перейдите на вкладку "Набор на проекты" для просмотра доступных вакансий и объектов.',
      ),
      FAQItem(
        question: 'Где находятся учебные материалы?',
        answer: 'Все учебные материалы и памятки находятся в разделе "Компания" на вкладке "Учебные материалы".',
      ),
      FAQItem(
        question: 'Как обновить информацию о своих детях?',
        answer: 'В профиле найдите раздел "Дети" и используйте кнопку "+" для добавления или "Удалить" для удаления информации о детях.',
      ),
      FAQItem(
        question: 'Как подать вопрос в другой отдел?',
        answer: 'Используйте онлайн-чат в разделе "Контакты" для связи с нужным отделом.',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: widget.compact ? const EdgeInsets.all(16) : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!widget.compact) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.frequentlyAskedQuestions,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
          ...List.generate(
            faqItems.length,
            (index) {
              final item = faqItems[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  title: Text(
                    item.question,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  trailing: Icon(
                    item.isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: theme.colorScheme.primary,
                  ),
                  onExpansionChanged: (expanded) {
                    setState(() {
                      item.isExpanded = expanded;
                    });
                  },
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        item.answer,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (widget.compact) const SizedBox(height: 16),
        ],
      ),
    );
  }
}
