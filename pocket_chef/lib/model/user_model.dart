class UserModel {
  final String id;
  final String email;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.createdAt
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> map){
    return UserModel(
      id: id,
      email: map['email'] ?? '',
      createdAt: map['createdAt'] != null 
          ? (map['createdAt']).toDate() 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'createdAt': createdAt,
    };
  }
}