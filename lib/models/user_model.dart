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
  );
}