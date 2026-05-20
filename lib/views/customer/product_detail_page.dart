import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/product_model.dart';
import '../../models/cart_item_model.dart';
import '../../providers/cart_provider.dart';
import '../../config/theme_config.dart';
import '../../utils/currency_formatter.dart';
import 'checkout_page.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // foto produk
            CachedNetworkImage(
              imageUrl: widget.product.imageUrl ?? '',
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 300,
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                height: 300,
                color: Colors.grey[200],
                child: const Icon(Icons.cake, size: 100, color: Colors.grey),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: ThemeConfig.heading2,
                  ),
                  const SizedBox(height: 8),

                  if (widget.product.categoryName != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: ThemeConfig.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.product.categoryName!,
                        style: ThemeConfig.bodySmall.copyWith(
                          color: ThemeConfig.primaryColor,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  Text(
                    CurrencyFormatter.format(widget.product.price),
                    style: ThemeConfig.heading2.copyWith(
                      color: ThemeConfig.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      const Icon(Icons.inventory_2, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Stok: ${widget.product.stock}',
                        style: ThemeConfig.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Divider(),
                  const SizedBox(height: 16),

                  Text(
                    'Deskripsi',
                    style: ThemeConfig.heading3,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description ?? 'Tidak ada deskripsi',
                    style: ThemeConfig.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // pilih jumlah
                  Text(
                    'Jumlah',
                    style: ThemeConfig.heading3,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _quantity > 1
                            ? () => setState(() => _quantity--)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                        color: ThemeConfig.primaryColor,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$_quantity',
                          style: ThemeConfig.heading3,
                        ),
                      ),
                      IconButton(
                        onPressed: _quantity < widget.product.stock
                            ? () => setState(() => _quantity++)
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                        color: ThemeConfig.primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: widget.product.isAvailable && widget.product.stock > 0
              ? Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          cartProvider.addToCart(widget.product, quantity: _quantity);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Produk ditambahkan ke keranjang'),
                              backgroundColor: ThemeConfig.successColor,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: ThemeConfig.primaryColor),
                        ),
                        child: const Text(
                          'Keranjang',
                          style: TextStyle(fontSize: 16, color: ThemeConfig.primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final buyNowItem = CartItem.fromProduct(
                            widget.product,
                            quantity: _quantity,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutPage(buyNowItem: buyNowItem),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Beli Langsung',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                )
              : ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Stok Habis',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
        ),
      ),
    );
  }
}
