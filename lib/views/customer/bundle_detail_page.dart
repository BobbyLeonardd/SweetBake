import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/bundle_model.dart';
import '../../models/cart_item_model.dart';
import '../../config/theme_config.dart';
import '../../utils/currency_formatter.dart';
import '../../providers/cart_provider.dart';

class BundleDetailPage extends StatelessWidget {
  final Bundle bundle;

  const BundleDetailPage({super.key, required this.bundle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConfig.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: ThemeConfig.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  bundle.imageUrl != null && bundle.imageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: bundle.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: ThemeConfig.primaryColor,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey.shade200,
                            child: Icon(
                              Icons.card_giftcard_rounded,
                              size: 100,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade200,
                          child: Icon(
                            Icons.card_giftcard_rounded,
                            size: 100,
                            color: Colors.grey.shade400,
                          ),
                        ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [ThemeConfig.primaryColor, ThemeConfig.accentColor],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: ThemeConfig.softShadow,
                      ),
                      child: Text(
                        '${bundle.discountPercentage.toStringAsFixed(0)}% OFF',
                        style: ThemeConfig.bodyLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: ThemeConfig.secondaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.card_giftcard_rounded,
                          size: 16,
                          color: ThemeConfig.accentColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'PAKET BUNDLING',
                          style: ThemeConfig.bodySmall.copyWith(
                            color: ThemeConfig.accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    bundle.name,
                    style: ThemeConfig.heading1,
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ThemeConfig.secondaryColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: ThemeConfig.primaryColor.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Harga Normal:',
                              style: ThemeConfig.bodyMedium.copyWith(
                                color: ThemeConfig.textSecondaryColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              CurrencyFormatter.format(bundle.originalPrice),
                              style: ThemeConfig.bodyLarge.copyWith(
                                color: ThemeConfig.textSecondaryColor,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Harga Promo:',
                              style: ThemeConfig.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              CurrencyFormatter.format(bundle.promoPrice),
                              style: ThemeConfig.heading2.copyWith(
                                color: ThemeConfig.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: ThemeConfig.successColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Hemat ${CurrencyFormatter.format(bundle.savings)}!',
                            style: ThemeConfig.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (bundle.description != null && bundle.description!.isNotEmpty) ...[
                    Text(
                      'Deskripsi',
                      style: ThemeConfig.heading3,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bundle.description!,
                      style: ThemeConfig.bodyMedium.copyWith(
                        color: ThemeConfig.textSecondaryColor,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  if (bundle.items != null && bundle.items!.isNotEmpty) ...[
                    Text(
                      'Isi Paket (${bundle.items!.length} produk)',
                      style: ThemeConfig.heading3,
                    ),
                    const SizedBox(height: 12),
                    ...bundle.items!.map((item) => _buildBundleItem(item)),
                  ],

                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final isInCart = cartProvider.isBundleInCart(bundle.id);
          final quantityInCart = cartProvider.getQuantityInCart(bundle.id, CartItemType.bundle);

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isInCart)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: ThemeConfig.secondaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.shopping_cart_rounded,
                            size: 16,
                            color: ThemeConfig.accentColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$quantityInCart paket di keranjang',
                            style: ThemeConfig.bodySmall.copyWith(
                              color: ThemeConfig.accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                  ElevatedButton(
                    onPressed: bundle.isAvailable
                        ? () {
                            cartProvider.addBundleToCart(bundle);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.check_circle, color: Colors.white),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text('${bundle.name} ditambahkan ke keranjang'),
                                    ),
                                  ],
                                ),
                                backgroundColor: ThemeConfig.successColor,
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_shopping_cart_rounded),
                        const SizedBox(width: 8),
                        Text(
                          bundle.isAvailable ? 'Tambah ke Keranjang' : 'Tidak Tersedia',
                          style: ThemeConfig.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBundleItem(BundleItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: item.productImage != null && item.productImage!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: item.productImage!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey.shade200,
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey.shade200,
                      child: Icon(Icons.cake, color: Colors.grey.shade400),
                    ),
                  )
                : Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade200,
                    child: Icon(Icons.cake, color: Colors.grey.shade400),
                  ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName ?? 'Produk',
                  style: ThemeConfig.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.quantity}x',
                  style: ThemeConfig.bodySmall.copyWith(
                    color: ThemeConfig.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),

          if (item.productPrice != null)
            Text(
              CurrencyFormatter.format(item.productPrice!),
              style: ThemeConfig.bodySmall.copyWith(
                color: ThemeConfig.textSecondaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
