class ReferralInfo {
  final String referralCode;
  final String referralLink;
  final int totalReferrals;
  final List<Referral> referrals;

  ReferralInfo({
    required this.referralCode,
    required this.referralLink,
    this.totalReferrals = 0,
    this.referrals = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'referralCode': referralCode,
      'referralLink': referralLink,
      'totalReferrals': totalReferrals,
      'referrals': referrals.map((r) => r.toMap()).toList(),
    };
  }

  factory ReferralInfo.fromMap(Map<String, dynamic> map) {
    return ReferralInfo(
      referralCode: map['referralCode'] ?? '',
      referralLink: map['referralLink'] ?? '',
      totalReferrals: map['totalReferrals'] ?? 0,
      referrals: (map['referrals'] as List?)
              ?.map((r) => Referral.fromMap(r))
              .toList() ??
          [],
    );
  }
}

class Referral {
  final String id;
  final String name;
  final String email;
  final DateTime referredDate;
  final bool isActive;

  Referral({
    required this.id,
    required this.name,
    required this.email,
    required this.referredDate,
    this.isActive = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'referredDate': referredDate.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory Referral.fromMap(Map<String, dynamic> map) {
    return Referral(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      referredDate: DateTime.parse(map['referredDate']),
      isActive: map['isActive'] ?? false,
    );
  }
}
