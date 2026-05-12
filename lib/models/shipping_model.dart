class ShippingCost {
  final int id;
  final String city;
  final double cost;
  final int estimatedDays;

  ShippingCost({
    required this.id,
    required this.city,
    required this.cost,
    required this.estimatedDays,
  });

  factory ShippingCost.fromJson(Map<String, dynamic> json) {
    return ShippingCost(
      id: int.parse(json['id'].toString()),
      city: json['city'],
      cost: double.parse(json['cost'].toString()),
      estimatedDays: int.parse(json['estimated_days'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city': city,
      'cost': cost,
      'estimated_days': estimatedDays,
    };
  }
}
