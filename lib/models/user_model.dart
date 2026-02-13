import 'child_info.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String iin;
  final String position;
  final String phoneNumber;
  final String clothingSize;
  final String shoeSize;
  
  // Release 2 fields
  final String? photoUrl;  // Avatar photo URL
  final double? rating;  // Average rating (0-5)
  final List<String> awards;  // List of award names
  final List<ChildInfo> children;  // Children information
  final String status;  // active, vacation, transfer
  final double balance;  // Current balance (bonus or salary)
  final int shiftsWorked;  // Total shifts worked
  
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.iin,
    required this.position,
    required this.phoneNumber,
    required this.clothingSize,
    required this.shoeSize,
    this.photoUrl,
    this.rating,
    this.awards = const [],
    this.children = const [],
    this.status = 'active',
    this.balance = 0.0,
    this.shiftsWorked = 0,
  });
  
  // Add copyWith method
  User copyWith({
    String? id,
    String? username,
    String? email,
    String? fullName,
    String? iin,
    String? position,
    String? phoneNumber,
    String? clothingSize,
    String? shoeSize,
    String? photoUrl,
    double? rating,
    List<String>? awards,
    List<ChildInfo>? children,
    String? status,
    double? balance,
    int? shiftsWorked,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      iin: iin ?? this.iin,
      position: position ?? this.position,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      clothingSize: clothingSize ?? this.clothingSize,
      shoeSize: shoeSize ?? this.shoeSize,
      photoUrl: photoUrl ?? this.photoUrl,
      rating: rating ?? this.rating,
      awards: awards ?? this.awards,
      children: children ?? this.children,
      status: status ?? this.status,
      balance: balance ?? this.balance,
      shiftsWorked: shiftsWorked ?? this.shiftsWorked,
    );
  }
  
  /// Build from Firestore profile map; use [base] for missing fields.
  static User fromProfileMap(User base, Map<String, dynamic> data) {
    List<ChildInfo> children = base.children;
    if (data['children'] is List) {
      children = (data['children'] as List)
          .map((e) => ChildInfo.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    List<String> awards = base.awards;
    if (data['awards'] is List) {
      awards = (data['awards'] as List).map((e) => e.toString()).toList();
    }
    return base.copyWith(
      fullName: data['name'] as String? ?? base.fullName,
      email: data['email'] as String? ?? base.email,
      phoneNumber: data['phoneNumber'] as String? ?? base.phoneNumber,
      clothingSize: data['clothingSize'] as String? ?? base.clothingSize,
      shoeSize: data['shoeSize'] as String? ?? base.shoeSize,
      photoUrl: data['photoUrl'] as String? ?? base.photoUrl,
      rating: (data['rating'] as num?)?.toDouble() ?? base.rating,
      awards: awards.isNotEmpty ? awards : null,
      children: children.isNotEmpty ? children : null,
      status: data['status'] as String? ?? base.status,
      balance: (data['balance'] as num?)?.toDouble() ?? base.balance,
      shiftsWorked: data['shiftsWorked'] as int? ?? base.shiftsWorked,
    );
  }

  // Mock user for testing
  static User mockUser = User(
    id: '1',
    username: 'johndoe',
    email: 'john.doe@company.com',
    fullName: 'John Doe',
    iin: '123456789012',
    position: 'Software Developer',
    phoneNumber: '+7 777 123 4567',
    clothingSize: 'M',
    shoeSize: '42',
    rating: 4.5,
    awards: ['Employee of the Month', 'Best Team Player'],
    children: [
      ChildInfo(
        name: 'Jane Doe',
        birthDate: DateTime(2015, 5, 15),
        certificateNumber: 'CERT-2024-001',
      ),
    ],
    status: 'active',
    balance: 15000.0,
    shiftsWorked: 45,
  );
}