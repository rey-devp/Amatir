class UserModel {
  final String uid;
  final String email;
  final String name;
  final String
  password; // Note: Storing passwords in Firestore is generally not recommended if using Firebase Auth.
  final String role; // 'courier', 'customer', 'gudang', 'admin'
  final String createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.password,
    required this.role,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'password': password,
      'role': role,
      'created_at': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? 'customer',
      createdAt: map['created_at'] ?? '',
    );
  }
}

