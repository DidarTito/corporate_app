class BonusInfo {
  final int points;
  final double balance;
  final List<Reward> availableRewards;
  final List<Reward> redeemedRewards;

  BonusInfo({
    required this.points,
    required this.balance,
    this.availableRewards = const [],
    this.redeemedRewards = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'points': points,
      'balance': balance,
      'availableRewards': availableRewards.map((r) => r.toMap()).toList(),
      'redeemedRewards': redeemedRewards.map((r) => r.toMap()).toList(),
    };
  }

  factory BonusInfo.fromMap(Map<String, dynamic> map) {
    return BonusInfo(
      points: map['points'] ?? 0,
      balance: map['balance'] ?? 0.0,
      availableRewards: (map['availableRewards'] as List?)
              ?.map((r) => Reward.fromMap(r))
              .toList() ??
          [],
      redeemedRewards: (map['redeemedRewards'] as List?)
              ?.map((r) => Reward.fromMap(r))
              .toList() ??
          [],
    );
  }
}

class Reward {
  final String id;
  final String name;
  final String description;
  final int pointsRequired;
  final String? imageUrl;

  Reward({
    required this.id,
    required this.name,
    required this.description,
    required this.pointsRequired,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pointsRequired': pointsRequired,
      'imageUrl': imageUrl,
    };
  }

  factory Reward.fromMap(Map<String, dynamic> map) {
    return Reward(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      pointsRequired: map['pointsRequired'] ?? 0,
      imageUrl: map['imageUrl'],
    );
  }
}
