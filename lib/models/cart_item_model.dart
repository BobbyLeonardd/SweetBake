import 'product_model.dart';
import 'bundle_model.dart';

enum CartItemType { product, bundle }

class CartItem {
  final Product? product;
  final Bundle? bundle;
  final CartItemType type;
  int quantity;

  CartItem({
    this.product,
    this.bundle,
    required this.type,
    this.quantity = 1,
  }) : assert(
          (type == CartItemType.product && product != null) ||
              (type == CartItemType.bundle && bundle != null),
          'Product must be provided for product type, Bundle for bundle type',
        );

  // Factory constructor untuk product
  factory CartItem.fromProduct(Product product, {int quantity = 1}) {
    return CartItem(
      product: product,
      type: CartItemType.product,
      quantity: quantity,
    );
  }

  // Factory constructor untuk bundle
  factory CartItem.fromBundle(Bundle bundle, {int quantity = 1}) {
    return CartItem(
      bundle: bundle,
      type: CartItemType.bundle,
      quantity: quantity,
    );
  }

  int get id => type == CartItemType.product ? product!.id : bundle!.id;

  String get name => type == CartItemType.product ? product!.name : bundle!.name;

  double get price => type == CartItemType.product ? product!.price : bundle!.promoPrice;

  String? get imageUrl => type == CartItemType.product ? product!.imageUrl : bundle!.imageUrl;

  double get subtotal => price * quantity;

  bool get isProduct => type == CartItemType.product;

  bool get isBundle => type == CartItemType.bundle;

  // untuk kirim ke API (tanpa data lengkap)
  Map<String, dynamic> toJson() {
    if (type == CartItemType.product) {
      return {
        'type': 'product',
        'product_id': product!.id,
        'quantity': quantity,
        'price': product!.price,
        'subtotal': subtotal,
      };
    } else {
      return {
        'type': 'bundle',
        'bundle_id': bundle!.id,
        'quantity': quantity,
        'price': bundle!.promoPrice,
        'subtotal': subtotal,
      };
    }
  }

  // untuk simpan ke shared_preferences (butuh data lengkap)
  Map<String, dynamic> toJsonFull() {
    if (type == CartItemType.product) {
      return {
        'type': 'product',
        'product': product!.toJson(),
        'quantity': quantity,
      };
    } else {
      return {
        'type': 'bundle',
        'bundle': bundle!.toJson(),
        'quantity': quantity,
      };
    }
  }

  factory CartItem.fromJsonFull(Map<String, dynamic> json) {
    final type = json['type'] as String;
    
    if (type == 'product') {
      return CartItem.fromProduct(
        Product.fromJson(json['product']),
        quantity: json['quantity'] as int,
      );
    } else {
      return CartItem.fromBundle(
        Bundle.fromJson(json['bundle']),
        quantity: json['quantity'] as int,
      );
    }
  }
}
