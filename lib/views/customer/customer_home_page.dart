import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/bundle_provider.dart';
import '../../config/theme_config.dart';
import '../../widgets/product_card.dart';
import '../../widgets/bundle_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state_widget.dart';
import 'product_detail_page.dart';
import 'bundle_detail_page.dart';
import 'cart_page.dart';
import 'orders_page.dart';
import 'profile_page.dart';
import 'wishlist_page.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  int _selectedIndex = 0;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      Provider.of<ProductProvider>(context, listen: false).fetchCategories();
      Provider.of<BundleProvider>(context, listen: false).fetchBundles();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.user != null) {
        Provider.of<WishlistProvider>(context, listen: false).fetchWishlist(authProvider.user!.id);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildHomePage() {
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final bundleProvider = Provider.of<BundleProvider>(context);
    
    var products = _searchQuery.isEmpty
        ? productProvider.products
        : productProvider.searchProducts(_searchQuery);
        
    if (_selectedCategoryId != null) {
      products = products.where((p) => p.categoryId == _selectedCategoryId).toList();
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          pinned: true,
          elevation: 0,
          backgroundColor: ThemeConfig.backgroundColor,
          surfaceTintColor: Colors.transparent,
          title: Text(
            'SweetBake',
            style: ThemeConfig.heading2.copyWith(color: ThemeConfig.primaryColor),
          ),
          actions: [
            _buildCartAction(),
          ],
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, ${authProvider.user?.name.split(' ')[0] ?? "Customer"}! 👋',
                  style: ThemeConfig.heading1,
                ),
                const SizedBox(height: 8),
                Text(
                  'Temukan kue spesial untuk momen manismu hari ini.',
                  style: ThemeConfig.bodyLarge.copyWith(
                    color: ThemeConfig.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                
                Container(
                  decoration: BoxDecoration(
                    boxShadow: ThemeConfig.softShadow,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari kue favoritmu...',
                      prefixIcon: const Icon(Icons.search_rounded, color: ThemeConfig.primaryColor),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (!productProvider.isLoading && productProvider.categories.isNotEmpty)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Kategori', style: ThemeConfig.heading3),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: productProvider.categories.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildCategoryChip('Semua', null);
                      }
                      final category = productProvider.categories[index - 1];
                      return _buildCategoryChip(category.name, category.id);
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

        if (!bundleProvider.isLoading && bundleProvider.availableBundles.isNotEmpty)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.card_giftcard_rounded,
                        color: ThemeConfig.primaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text('Paket Bundling', style: ThemeConfig.heading3),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [ThemeConfig.primaryColor, ThemeConfig.accentColor],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'HEMAT!',
                          style: ThemeConfig.bodySmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 280, // Increased from 240 to fix bottom overflow
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: bundleProvider.availableBundles.length,
                    itemBuilder: (context, index) {
                      final bundle = bundleProvider.availableBundles[index];
                      return Container(
                        width: 200,
                        margin: const EdgeInsets.only(right: 12),
                        child: BundleCard(
                          bundle: bundle,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BundleDetailPage(bundle: bundle),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              _searchQuery.isNotEmpty ? 'Hasil Pencarian' : 'Rekomendasi Kami',
              style: ThemeConfig.heading3,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        if (productProvider.isLoading)
          const SliverFillRemaining(
            child: LoadingWidget(),
          )
        else if (productProvider.hasError)
          SliverFillRemaining(
            child: EmptyStateWidget(
              icon: Icons.wifi_off_rounded,
              title: 'Gagal Memuat Produk',
              subtitle: productProvider.errorMessage,
              buttonLabel: 'Coba Lagi',
              onButtonPressed: () {
                productProvider.fetchProducts();
                productProvider.fetchCategories();
              },
            ),
          )
        else if (products.isEmpty)
          SliverFillRemaining(
            child: EmptyStateWidget(
              icon: Icons.cake_outlined,
              title: _searchQuery.isNotEmpty
                  ? 'Produk tidak ditemukan'
                  : _selectedCategoryId != null
                      ? 'Belum ada produk di kategori ini'
                      : 'Belum ada produk',
              subtitle: _searchQuery.isNotEmpty
                  ? 'Coba kata kunci lain'
                  : null,
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = products[index];
                  return ProductCard(
                    product: product,
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => ProductDetailPage(product: product),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                        ),
                      );
                    },
                  );
                },
                childCount: products.length,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryChip(String label, int? categoryId) {
    final isSelected = _selectedCategoryId == categoryId;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategoryId = selected ? categoryId : null;
          });
        },
        backgroundColor: ThemeConfig.cardColor,
        selectedColor: ThemeConfig.primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : ThemeConfig.textPrimaryColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? ThemeConfig.primaryColor : Colors.grey.shade300,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildCartAction() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: Badge(
              isLabelVisible: cartProvider.itemCount > 0,
              label: Text('${cartProvider.itemCount}'),
              backgroundColor: ThemeConfig.primaryColor,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomePage(),
      const WishlistPage(),
      const OrdersPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_rounded),
              activeIcon: Icon(Icons.favorite_rounded),
              label: 'Favorit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long_rounded),
              label: 'Pesanan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
