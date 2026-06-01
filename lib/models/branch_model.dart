class Branch {
  final int id;
  final String name;
  final String? address;
  final String? phone;
  final double deliveryCost;
  final bool isActive;
  final DateTime? createdAt;

  Branch({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    required this.deliveryCost,
    this.isActive = true,
    this.createdAt,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      deliveryCost: double.parse(json['delivery_cost'].toString()),
      isActive: json['is_active'].toString() == '1' || json['is_active'] == true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'delivery_cost': deliveryCost,
      'is_active': isActive ? 1 : 0,
    };
  }
}
