import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/bundle_model.dart';
import '../config/theme_config.dart';
import '../utils/currency_formatter.dart';

class BundleCard extends StatelessWidget {
  final Bundle bundle;
  final VoidCallback onTap;

  const BundleCard({
    super.key,
    required this.bundle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: ThemeConfig.softShadow,
          border: Border.all(color: Colors.grey.shade200, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with discount badge
            Flexible(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: SizedBox(
                      width: double.infinity,
                      child: bundle.imageUrl != null && bundle.imageUrl!.isNotEmpty
                          ? (bundle.imageUrl!.startsWith('http')
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
                                      size: 50,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                )
                              : Image.asset(
                                  bundle.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: Colors.grey.shade200,
                                    child: Icon(
                                      Icons.card_giftcard_rounded,
                                      size: 50,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ))
                          : Container(
                              color: Colors.grey.shade200,
                              child: Icon(
                                Icons.card_giftcard_rounded,
                                size: 50,
                                color: Colors.grey.shade400,
                              ),
                            ),
                    ),
                  ),
                  // Discount badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [ThemeConfig.primaryColor, ThemeConfig.accentColor],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: ThemeConfig.primaryColor.withValues(alpha: 0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${bundle.discountPercentage.toStringAsFixed(0)}% OFF',
                        style: ThemeConfig.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  // Bundle badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: ThemeConfig.secondaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.card_giftcard_rounded,
                            size: 12,
                            color: ThemeConfig.accentColor,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'PAKET',
                            style: ThemeConfig.bodySmall.copyWith(
                              color: ThemeConfig.accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Bundle name
                    Text(
                      bundle.name,
                      style: ThemeConfig.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ThemeConfig.textPrimaryColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),

                    // Items count
                    if (bundle.items != null && bundle.items!.isNotEmpty)
                      Text(
                        '${bundle.items!.length} produk',
                        style: ThemeConfig.bodySmall.copyWith(
                          color: ThemeConfig.textSecondaryColor,
                          fontSize: 11,
                        ),
                      ),
                    const Spacer(),

                    // Prices
                    Row(
                      children: [
                        // Original price (strikethrough)
                        Text(
                          CurrencyFormatter.format(bundle.originalPrice),
                          style: ThemeConfig.bodySmall.copyWith(
                            color: ThemeConfig.textSecondaryColor,
                            decoration: TextDecoration.lineThrough,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Promo price
                        Expanded(
                          child: Text(
                            CurrencyFormatter.format(bundle.promoPrice),
                            style: ThemeConfig.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: ThemeConfig.primaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    // Savings
                    const SizedBox(height: 2),
                    Text(
                      'Hemat ${CurrencyFormatter.format(bundle.savings)}',
                      style: ThemeConfig.bodySmall.copyWith(
                        color: ThemeConfig.successColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
