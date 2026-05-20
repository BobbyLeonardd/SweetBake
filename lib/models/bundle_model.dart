class Bundle {
  final int id;
  final String name;
  final String? description;
  final double originalPrice;
  final double promoPrice;
  final String? imageUrl;
  final bool isAvailable;
  final List<BundleItem>? items;
  final DateTime? createdAt;

  Bundle({
    required this.id,
    required this.name,
    this.description,
    required this.originalPrice,
    required this.promoPrice,
    this.imageUrl,
    this.isAvailable = true,
    this.items,
    this.createdAt,
  });

  factory Bundle.fromJson(Map<String, dynamic> json) {
    return Bundle(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      description: json['description'],
      originalPrice: double.parse(json['original_price'].toString()),
      promoPrice: double.parse(json['promo_price'].toString()),
      imageUrl: json['image_url'],
      isAvailable: json['is_available'].toString() == '1' || json['is_available'] == true,
      items: json['items'] != null
          ? (json['items'] as List).map((i) => BundleItem.fromJson(i)).toList()
          : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'original_price': originalPrice,
      'promo_price': promoPrice,
      'image_url': imageUrl,
      'is_available': isAvailable ? 1 : 0,
    };
  }

  double get discountPercentage {
    if (originalPrice <= 0) return 0;
    return ((originalPrice - promoPrice) / originalPrice * 100);
  }

  double get savings {
    return originalPrice - promoPrice;
  }
}

class BundleItem {
  final int id;
  final int bundleId;
  final int productId;
  final int quantity;
  final String? productName;
  final String? productImage;
  final double? productPrice;

  BundleItem({
    required this.id,
    required this.bundleId,
    required this.productId,
    required this.quantity,
    this.productName,
    this.productImage,
    this.productPrice,
  });

  factory BundleItem.fromJson(Map<String, dynamic> json) {
    return BundleItem(
      id: int.parse(json['id'].toString()),
      bundleId: int.parse(json['bundle_id'].toString()),
      productId: int.parse(json['product_id'].toString()),
      quantity: int.parse(json['quantity'].toString()),
      productName: json['product_name'],
      productImage: json['product_image'],
      productPrice: json['product_price'] != null 
          ? double.parse(json['product_price'].toString()) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bundle_id': bundleId,
      'product_id': productId,
      'quantity': quantity,
    };
  }
}
