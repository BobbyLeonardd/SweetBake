import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/order_provider.dart';
import '../../config/theme_config.dart';
import 'admin_products_page.dart';
import 'admin_orders_page.dart';
import 'admin_customers_page.dart';
import 'admin_categories_page.dart';
import 'admin_shipping_page.dart';
import 'admin_bundles_page.dart';
import 'admin_branches_page.dart';
import '../auth/login_page.dart';
import '../about_page.dart';
import '../../services/api_service.dart';
import '../../utils/currency_formatter.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  late Future<Map<String, dynamic>> _analyticsFuture;

  @override
  void initState() {
    super.initState();
    _analyticsFuture = ApiService.getAnalytics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    final pendingOrders = orderProvider.getOrdersByStatus('pending').length;
    final processingOrders = orderProvider
        .getOrdersByStatus('processing')
        .length;

    return Scaffold(
      backgroundColor: ThemeConfig.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: ThemeConfig.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                'Admin Dashboard',
                style: ThemeConfig.heading3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeConfig.primaryColor, ThemeConfig.accentColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -20,
                      right: -20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -40,
                      right: 60,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                tooltip: 'Logout',
                onPressed: () async {
                  await authProvider.logout();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  }
                },
              ),
              const SizedBox(width: 8),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, ${authProvider.user?.name.split(' ')[0] ?? "Admin"} 👋',
                    style: ThemeConfig.heading1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ringkasan aktivitas toko Anda hari ini',
                    style: ThemeConfig.bodyMedium.copyWith(
                      color: ThemeConfig.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // load data statistik
                  FutureBuilder<Map<String, dynamic>>(
                    future: _analyticsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final analytics = snapshot.data ?? {};
                      final revenue = (analytics['total_revenue'] ?? 0)
                          .toDouble();
                      final totalCustomers = analytics['total_customers'] ?? 0;

                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  title: 'Total Pendapatan',
                                  value: CurrencyFormatter.format(revenue),
                                  icon: Icons.account_balance_wallet_rounded,
                                  color: Colors.green.shade600,
                                  gradientColors: [
                                    Colors.green.withValues(alpha: 0.15),
                                    Colors.green.withValues(alpha: 0.05),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  title: 'Total Pesanan',
                                  value: '${orderProvider.orders.length}',
                                  icon: Icons.shopping_bag_rounded,
                                  color: Colors.blue.shade600,
                                  gradientColors: [
                                    Colors.blue.withValues(alpha: 0.15),
                                    Colors.blue.withValues(alpha: 0.05),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _StatCard(
                                  title: 'Total Pelanggan',
                                  value: '$totalCustomers',
                                  icon: Icons.people_rounded,
                                  color: Colors.orange.shade600,
                                  gradientColors: [
                                    Colors.orange.withValues(alpha: 0.15),
                                    Colors.orange.withValues(alpha: 0.05),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  title: 'Pesanan Baru',
                                  value: '$pendingOrders',
                                  icon: Icons.notifications_active_rounded,
                                  color: ThemeConfig.warningColor,
                                  gradientColors: [
                                    ThemeConfig.warningColor.withValues(
                                      alpha: 0.15,
                                    ),
                                    ThemeConfig.warningColor.withValues(
                                      alpha: 0.05,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _StatCard(
                                  title: 'Diproses',
                                  value: '$processingOrders',
                                  icon: Icons.hourglass_top_rounded,
                                  color: Colors.purple.shade500,
                                  gradientColors: [
                                    Colors.purple.withValues(alpha: 0.15),
                                    Colors.purple.withValues(alpha: 0.05),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  Text('Menu Manajemen', style: ThemeConfig.heading3),
                  const SizedBox(height: 16),

                  // menu admin
                  _MenuCard(
                    title: 'Kelola Produk',
                    subtitle: 'Tambah, edit, dan hapus katalog produk Anda',
                    icon: Icons.inventory_2_rounded,
                    color: ThemeConfig.primaryColor,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AdminProductsPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _MenuCard(
                    title: 'Kelola Pesanan',
                    subtitle: 'Lacak pesanan dan perbarui status pengiriman',
                    icon: Icons.local_shipping_rounded,
                    color: ThemeConfig.accentColor,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AdminOrdersPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _MenuCard(
                    title: 'Kelola Pelanggan',
                    subtitle: 'Lihat daftar customer dan update datanya',
                    icon: Icons.people_alt_rounded,
                    color: Colors.teal.shade500,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AdminCustomersPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _MenuCard(
                    title: 'Kelola Kategori',
                    subtitle: 'Tambah, edit, dan hapus kategori produk',
                    icon: Icons.category_rounded,
                    color: Colors.orange.shade500,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AdminCategoriesPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _MenuCard(
                    title: 'Kelola Ongkos Kirim',
                    subtitle: 'Atur tarif pengiriman untuk setiap kota',
                    icon: Icons.map_rounded,
                    color: Colors.indigo.shade500,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AdminShippingPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _MenuCard(
                    title: 'Kelola Paket Bundling',
                    subtitle: 'Buat paket bundling dengan harga promo spesial',
                    icon: Icons.card_giftcard_rounded,
                    color: Colors.pink.shade500,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AdminBundlesPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _MenuCard(
                    title: 'Kelola Cabang',
                    subtitle: 'Tambah dan atur cabang toko untuk layanan pengiriman',
                    icon: Icons.storefront_rounded,
                    color: Colors.deepPurple.shade500,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AdminBranchesPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _MenuCard(
                    title: 'Tentang Aplikasi',
                    subtitle: 'Informasi aplikasi dan tim developer SweetBake',
                    icon: Icons.info_outline_rounded,
                    color: Colors.blueGrey.shade500,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AboutPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final List<Color> gradientColors;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeConfig.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: ThemeConfig.softShadow,
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: ThemeConfig.heading1.copyWith(
                color: ThemeConfig.textPrimaryColor,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: ThemeConfig.bodyMedium.copyWith(
                color: ThemeConfig.textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeConfig.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: ThemeConfig.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          highlightColor: color.withValues(alpha: 0.05),
          splashColor: color.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: ThemeConfig.heading3.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: ThemeConfig.bodyMedium.copyWith(
                          color: ThemeConfig.textSecondaryColor,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ThemeConfig.backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: ThemeConfig.textSecondaryColor,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
