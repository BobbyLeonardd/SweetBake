import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../services/api_service.dart';
import '../../models/shipping_model.dart';
import '../../models/cart_item_model.dart';
import '../../config/theme_config.dart';
import '../../utils/currency_formatter.dart';

class CheckoutPage extends StatefulWidget {
  final CartItem? buyNowItem;

  const CheckoutPage({super.key, this.buyNowItem});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  
  List<ShippingCost> _shippingCosts = [];
  ShippingCost? _selectedShipping;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadShippingCosts();
    _loadUserAddress();
  }

  Future<void> _loadShippingCosts() async {
    final costs = await ApiService.getShippingCosts();
    setState(() {
      _shippingCosts = costs;
    });
  }

  Future<void> _loadUserAddress() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user?.address != null) {
      _addressController.text = authProvider.user!.address!;
    }
  }

  List<CartItem> get _orderItems {
    if (widget.buyNowItem != null) {
      return [widget.buyNowItem!];
    }
    return Provider.of<CartProvider>(context, listen: false).items;
  }

  double get _totalAmount {
    if (widget.buyNowItem != null) {
      return widget.buyNowItem!.subtotal;
    }
    return Provider.of<CartProvider>(context, listen: false).totalAmount;
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedShipping == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih kota tujuan pengiriman')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    final orderData = {
      'customer_id': authProvider.user!.id,
      'total_amount': _totalAmount,
      'shipping_cost': _selectedShipping!.cost,
      'shipping_address': _addressController.text,
      'shipping_city': _selectedShipping!.city,
      'notes': _notesController.text,
      'items': _orderItems.map((item) => item.toJson()).toList(),
    };

    final result = await orderProvider.createOrder(orderData);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success']) {
      // kosongin cart kl dari halaman keranjang
      if (widget.buyNowItem == null) {
        Provider.of<CartProvider>(context, listen: false).clearCart();
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pesanan berhasil dibuat!'),
          backgroundColor: ThemeConfig.successColor,
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal membuat pesanan'),
          backgroundColor: ThemeConfig.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final shippingCost = _selectedShipping?.cost ?? 0;
    final total = _totalAmount + shippingCost;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Alamat Pengiriman', style: ThemeConfig.heading3),
            const SizedBox(height: 8),
            TextFormField(
              controller: _addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Masukkan alamat lengkap',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Alamat tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            Text('Kota Tujuan', style: ThemeConfig.heading3),
            const SizedBox(height: 8),
            DropdownButtonFormField<ShippingCost>(
              initialValue: _selectedShipping,
              decoration: const InputDecoration(
                hintText: 'Pilih kota',
              ),
              items: _shippingCosts.map((shipping) {
                return DropdownMenuItem(
                  value: shipping,
                  child: Text(
                    '${shipping.city} - ${CurrencyFormatter.format(shipping.cost)} (${shipping.estimatedDays} hari)',
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedShipping = value;
                });
              },
            ),
            const SizedBox(height: 16),
            
            Text('Catatan (Opsional)', style: ThemeConfig.heading3),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Catatan untuk penjual',
              ),
            ),
            const SizedBox(height: 24),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal', style: ThemeConfig.bodyMedium),
                        Text(CurrencyFormatter.format(_totalAmount)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Ongkir', style: ThemeConfig.bodyMedium),
                        Text(CurrencyFormatter.format(shippingCost)),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: ThemeConfig.heading3),
                        Text(
                          CurrencyFormatter.format(total),
                          style: ThemeConfig.heading3.copyWith(
                            color: ThemeConfig.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _placeOrder,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Buat Pesanan'),
          ),
        ),
      ),
    );
  }
}
