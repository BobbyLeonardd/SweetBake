class Order {
  final int id;
  final int customerId;
  final String orderNumber;
  final double totalAmount;
  final double shippingCost;
  final String shippingAddress;
  final String? shippingCity;
  final String status;
  final String paymentStatus;
  final String? notes;
  final String? customerName;
  final List<OrderItem>? items;
  final List<OrderTracking>? tracking;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.customerId,
    required this.orderNumber,
    required this.totalAmount,
    required this.shippingCost,
    required this.shippingAddress,
    this.shippingCity,
    required this.status,
    this.paymentStatus = 'unpaid',
    this.notes,
    this.customerName,
    this.items,
    this.tracking,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: int.parse(json['id'].toString()),
      customerId: int.parse(json['customer_id'].toString()),
      orderNumber: json['order_number'],
      totalAmount: double.parse(json['total_amount'].toString()),
      shippingCost: double.parse(json['shipping_cost'].toString()),
      shippingAddress: json['shipping_address'],
      shippingCity: json['shipping_city'],
      status: json['status'],
      paymentStatus: json['payment_status'] ?? 'unpaid',
      notes: json['notes'],
      customerName: json['customer_name'],
      items: json['items'] != null
          ? (json['items'] as List).map((i) => OrderItem.fromJson(i)).toList()
          : null,
      tracking: json['tracking'] != null
          ? (json['tracking'] as List).map((t) => OrderTracking.fromJson(t)).toList()
          : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  String get statusText {
    switch (status) {
      case 'pending':
        return 'Menunggu Konfirmasi';
      case 'confirmed':
        return 'Dikonfirmasi';
      case 'processing':
        return 'Diproses';
      case 'shipped':
        return 'Dikirim';
      case 'delivered':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }
}

class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final double price;
  final double subtotal;
  final String? productName;
  final String? imageUrl;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.subtotal,
    this.productName,
    this.imageUrl,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: int.parse(json['id'].toString()),
      orderId: int.parse(json['order_id'].toString()),
      productId: int.parse(json['product_id'].toString()),
      quantity: int.parse(json['quantity'].toString()),
      price: double.parse(json['price'].toString()),
      subtotal: double.parse(json['subtotal'].toString()),
      productName: json['product_name'],
      imageUrl: json['image_url'],
    );
  }
}

class OrderTracking {
  final int id;
  final int orderId;
  final String status;
  final String? description;
  final DateTime createdAt;

  OrderTracking({
    required this.id,
    required this.orderId,
    required this.status,
    this.description,
    required this.createdAt,
  });

  factory OrderTracking.fromJson(Map<String, dynamic> json) {
    return OrderTracking(
      id: int.parse(json['id'].toString()),
      orderId: int.parse(json['order_id'].toString()),
      status: json['status'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
