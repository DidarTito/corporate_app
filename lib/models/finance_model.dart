class FinanceInfo {
  final String? currentObject;
  final List<FinanceHistoryItem> history;
  final int totalShiftsWorked;
  final double trainingDeductions;  // Deductions for training center
  final double totalBalance;  // Total amount owed to employee

  FinanceInfo({
    this.currentObject,
    this.history = const [],
    this.totalShiftsWorked = 0,
    this.trainingDeductions = 0.0,
    this.totalBalance = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'currentObject': currentObject,
      'history': history.map((h) => h.toMap()).toList(),
      'totalShiftsWorked': totalShiftsWorked,
      'trainingDeductions': trainingDeductions,
      'totalBalance': totalBalance,
    };
  }

  factory FinanceInfo.fromMap(Map<String, dynamic> map) {
    return FinanceInfo(
      currentObject: map['currentObject'],
      history: (map['history'] as List?)
              ?.map((h) => FinanceHistoryItem.fromMap(h))
              .toList() ??
          [],
      totalShiftsWorked: map['totalShiftsWorked'] ?? 0,
      trainingDeductions: map['trainingDeductions'] ?? 0.0,
      totalBalance: map['totalBalance'] ?? 0.0,
    );
  }
}

class FinanceHistoryItem {
  final String id;
  final String objectName;
  final double completedVolume;
  final double payment;
  final DateTime date;
  final int shiftsWorked;

  FinanceHistoryItem({
    required this.id,
    required this.objectName,
    required this.completedVolume,
    required this.payment,
    required this.date,
    this.shiftsWorked = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'objectName': objectName,
      'completedVolume': completedVolume,
      'payment': payment,
      'date': date.toIso8601String(),
      'shiftsWorked': shiftsWorked,
    };
  }

  factory FinanceHistoryItem.fromMap(Map<String, dynamic> map) {
    return FinanceHistoryItem(
      id: map['id'] ?? '',
      objectName: map['objectName'] ?? '',
      completedVolume: map['completedVolume'] ?? 0.0,
      payment: map['payment'] ?? 0.0,
      date: DateTime.parse(map['date']),
      shiftsWorked: map['shiftsWorked'] ?? 0,
    );
  }
}
