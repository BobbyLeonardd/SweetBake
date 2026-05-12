class Product {
  final int id;
  final int? categoryId;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String? imageUrl;
  final bool isAvailable;
  final String? categoryName;

  Product({
    required this.id,
    this.categoryId,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.imageUrl,
    this.isAvailable = true,
    this.categoryName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.parse(json['id'].toString()),
      categoryId: json['category_id'] != null ? int.parse(json['category_id'].toString()) : null,
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      stock: int.parse(json['stock'].toString()),
      imageUrl: json['image_url'],
      isAvailable: json['is_available'].toString() == '1' || json['is_available'] == true,
      categoryName: json['category_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'image_url': imageUrl,
      'is_available': isAvailable ? 1 : 0,
    };
  }
}
