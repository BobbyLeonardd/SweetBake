import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/bundle_model.dart';
import '../../providers/bundle_provider.dart';
import '../../providers/product_provider.dart';
import '../../config/theme_config.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/loading_widget.dart';

class AdminBundleItemsPage extends StatefulWidget {
  final Bundle bundle;

  const AdminBundleItemsPage({super.key, required this.bundle});

  @override
  State<AdminBundleItemsPage> createState() => _AdminBundleItemsPageState();
}

class _AdminBundleItemsPageState extends State<AdminBundleItemsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      _refreshBundle();
    });
  }

  Future<void> _refreshBundle() async {
    final bundleProvider = Provider.of<BundleProvider>(context, listen: false);
    await bundleProvider.getBundleById(widget.bundle.id);
  }

  @override
  Widget build(BuildContext context) {
    final bundleProvider = Provider.of<BundleProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    final currentBundle = bundleProvider.bundles
        .firstWhere((b) => b.id == widget.bundle.id, orElse: () => widget.bundle);

    return Scaffold(
      backgroundColor: ThemeConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Kelola Isi Paket'),
        elevation: 0,
      ),
      body: productProvider.isLoading
          ? const LoadingWidget()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ThemeConfig.primaryColor, ThemeConfig.accentColor],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: ThemeConfig.softShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.card_giftcard_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                currentBundle.name,
                                style: ThemeConfig.heading2.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              CurrencyFormatter.format(currentBundle.originalPrice),
                              style: ThemeConfig.bodyMedium.copyWith(
                                color: Colors.white70,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              CurrencyFormatter.format(currentBundle.promoPrice),
                              style: ThemeConfig.heading3.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${currentBundle.discountPercentage.toStringAsFixed(0)}% OFF',
                                style: ThemeConfig.bodySmall.copyWith(
                                  color: ThemeConfig.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Text(
                        'Produk dalam Paket',
                        style: ThemeConfig.heading3,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: ThemeConfig.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${currentBundle.items?.length ?? 0}',
                          style: ThemeConfig.bodySmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (currentBundle.items == null || currentBundle.items!.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Belum ada produk dalam paket ini',
                              style: ThemeConfig.bodyMedium.copyWith(
                                color: ThemeConfig.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...currentBundle.items!.map((item) => _buildBundleItemCard(item)),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showAddProductDialog(currentBundle),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Tambah Produk ke Paket'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildBundleItemCard(BundleItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: ThemeConfig.softShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: ThemeConfig.secondaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.cake_rounded,
              color: ThemeConfig.accentColor,
              size: 32,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName ?? 'Produk',
                  style: ThemeConfig.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: ThemeConfig.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${item.quantity}x',
                        style: ThemeConfig.bodySmall.copyWith(
                          color: ThemeConfig.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (item.productPrice != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        CurrencyFormatter.format(item.productPrice!),
                        style: ThemeConfig.bodySmall.copyWith(
                          color: ThemeConfig.textSecondaryColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.delete_rounded, color: Colors.red),
            onPressed: () => _confirmRemoveItem(item),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog(Bundle bundle) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final availableProducts = productProvider.products.where((product) {
      return !(bundle.items?.any((item) => item.productId == product.id) ?? false);
    }).toList();

    if (availableProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua produk sudah ditambahkan ke paket ini'),
          backgroundColor: ThemeConfig.warningColor,
        ),
      );
      return;
    }

    int? selectedProductId;
    int quantity = 1;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Tambah Produk ke Paket'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilih Produk',
                  style: ThemeConfig.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  isExpanded: true,
                  initialValue: selectedProductId,
                  decoration: const InputDecoration(
                    hintText: 'Pilih produk...',
                    border: OutlineInputBorder(),
                  ),
                  items: availableProducts.map((product) {
                    return DropdownMenuItem(
                      value: product.id,
                      child: Text(
                        '${product.name} - ${CurrencyFormatter.format(product.price)}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedProductId = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Jumlah',
                  style: ThemeConfig.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (quantity > 1) {
                          setDialogState(() => quantity--);
                        }
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                      color: ThemeConfig.primaryColor,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$quantity',
                        style: ThemeConfig.heading3,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setDialogState(() => quantity++);
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      color: ThemeConfig.primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: selectedProductId == null
                  ? null
                  : () async {
                      final bundleProvider = Provider.of<BundleProvider>(
                        context,
                        listen: false,
                      );
                      final result = await bundleProvider.addBundleItem(
                        bundle.id,
                        selectedProductId!,
                        quantity,
                      );

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result['message']),
                            backgroundColor: result['success']
                                ? ThemeConfig.successColor
                                : ThemeConfig.errorColor,
                          ),
                        );

                        if (result['success']) {
                          _refreshBundle();
                        }
                      }
                    },
              child: const Text('Tambah'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmRemoveItem(BundleItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: Text(
          'Yakin ingin menghapus "${item.productName}" dari paket ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final bundleProvider = Provider.of<BundleProvider>(
                context,
                listen: false,
              );
              final result = await bundleProvider.removeBundleItem(item.id);

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result['message']),
                    backgroundColor: result['success']
                        ? ThemeConfig.successColor
                        : ThemeConfig.errorColor,
                  ),
                );

                if (result['success']) {
                  _refreshBundle();
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConfig.errorColor,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
