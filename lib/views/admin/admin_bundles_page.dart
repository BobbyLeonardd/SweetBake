import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bundle_provider.dart';
import '../../providers/product_provider.dart';
import '../../config/theme_config.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state_widget.dart';
import 'admin_bundle_items_page.dart';
import 'bundle_form_page.dart';

class AdminBundlesPage extends StatefulWidget {
  const AdminBundlesPage({super.key});

  @override
  State<AdminBundlesPage> createState() => _AdminBundlesPageState();
}

class _AdminBundlesPageState extends State<AdminBundlesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // print('DEBUG: mulai fetch data bundle...'); // jgn dihapus buat debug ntar
      Provider.of<BundleProvider>(context, listen: false).fetchBundles();
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bundleProvider = Provider.of<BundleProvider>(context);

    return Scaffold(
      backgroundColor: ThemeConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Kelola Paket Bundling'),
        elevation: 0,
      ),
      body: bundleProvider.isLoading
          ? const LoadingWidget()
          : bundleProvider.bundles.isEmpty
              ? const EmptyStateWidget(
                  icon: Icons.card_giftcard_rounded,
                  title: 'Belum ada paket bundling',
                  subtitle: 'Klik tombol di bawah untuk menambah paket',
                )
              : RefreshIndicator(
                  onRefresh: () => bundleProvider.fetchBundles(),
                  color: ThemeConfig.primaryColor,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: bundleProvider.bundles.length,
                    itemBuilder: (context, index) {
                      final bundle = bundleProvider.bundles[index];
                      return _buildBundleCard(bundle);
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const BundleFormPage(),
            ),
          );
        },
        backgroundColor: ThemeConfig.primaryColor,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Paket'),
      ),
    );
  }

  Widget _buildBundleCard(dynamic bundle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: ThemeConfig.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Bundle icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: ThemeConfig.secondaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.card_giftcard_rounded,
                    color: ThemeConfig.accentColor,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),

                // Bundle info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bundle.name,
                        style: ThemeConfig.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${bundle.items?.length ?? 0} produk',
                        style: ThemeConfig.bodySmall.copyWith(
                          color: ThemeConfig.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Text(
                            CurrencyFormatter.format(bundle.originalPrice),
                            style: ThemeConfig.bodySmall.copyWith(
                              color: ThemeConfig.textSecondaryColor,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(bundle.promoPrice),
                            style: ThemeConfig.bodyMedium.copyWith(
                              color: ThemeConfig.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: ThemeConfig.successColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${bundle.discountPercentage.toStringAsFixed(0)}%',
                              style: ThemeConfig.bodySmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Actions
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert_rounded),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'items',
                      child: Row(
                        children: [
                          Icon(Icons.inventory_2_rounded, size: 20),
                          SizedBox(width: 12),
                          Text('Kelola Produk'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_rounded, size: 20),
                          SizedBox(width: 12),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_rounded, size: 20, color: Colors.red),
                          SizedBox(width: 12),
                          Text('Hapus', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'items') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AdminBundleItemsPage(bundle: bundle),
                        ),
                      );
                    } else if (value == 'edit') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BundleFormPage(bundle: bundle),
                        ),
                      );
                    } else if (value == 'delete') {
                      _confirmDelete(bundle);
                    }
                  },
                ),
              ],
            ),
          ),

          // Bundle items
          if (bundle.items != null && bundle.items!.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Isi Paket:',
                    style: ThemeConfig.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ThemeConfig.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...bundle.items!.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              size: 16,
                              color: ThemeConfig.successColor,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${item.quantity}x ${item.productName ?? "Produk"}',
                                style: ThemeConfig.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            // kalau bundle kosong ga ditampilin ya
        ],
      ),
    );
  }

  void _confirmDelete(dynamic bundle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Paket'),
        content: Text('Yakin ingin menghapus paket "${bundle.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final bundleProvider = Provider.of<BundleProvider>(context, listen: false);
              final result = await bundleProvider.deleteBundle(bundle.id);

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
