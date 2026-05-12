class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'role': role,
    };
  }

  bool get isAdmin => role == 'admin';
  bool get isCustomer => role == 'customer';
}
