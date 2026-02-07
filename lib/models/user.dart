class User {
  final int id;
  final String name;
  final String email;
  final String? avatarUrl;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? 'John Doe',
      email: json['email'] ?? 'user@example.com',
      avatarUrl: json['avatarUrl'] ?? 
          'https://ui-avatars.com/api/?name=${json['name'] ?? 'User'}',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
    };
  }
}