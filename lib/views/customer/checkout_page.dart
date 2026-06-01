import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/branch_provider.dart';
import '../../models/branch_model.dart';
import '../../models/cart_item_model.dart';
import '../../config/theme_config.dart';
import '../../utils/currency_formatter.dart';

enum _DeliveryMethod { delivery, pickup }

enum _PaymentMethod { qris, transferBank, cash, debit, kredit, cod }

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

  Branch? _selectedBranch;
  _DeliveryMethod _deliveryMethod = _DeliveryMethod.delivery;
  _PaymentMethod? _selectedPaymentMethod;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BranchProvider>(context, listen: false).fetchBranches();
      _loadUserAddress();
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadUserAddress() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user?.address != null) {
      _addressController.text = authProvider.user!.address!;
    }
  }

  List<CartItem> get _orderItems {
    if (widget.buyNowItem != null) return [widget.buyNowItem!];
    return Provider.of<CartProvider>(context, listen: false).items;
  }

  double get _subtotal {
    if (widget.buyNowItem != null) return widget.buyNowItem!.subtotal;
    return Provider.of<CartProvider>(context, listen: false).totalAmount;
  }

  double get _shippingCost {
    if (_deliveryMethod == _DeliveryMethod.pickup) return 0;
    return _selectedBranch?.deliveryCost ?? 0;
  }

  String _paymentMethodValue(_PaymentMethod method) {
    switch (method) {
      case _PaymentMethod.qris:         return 'qris';
      case _PaymentMethod.transferBank: return 'transfer_bank';
      case _PaymentMethod.cash:         return 'cash';
      case _PaymentMethod.debit:        return 'debit';
      case _PaymentMethod.kredit:       return 'kredit';
      case _PaymentMethod.cod:          return 'cod';
    }
  }

  String _paymentMethodLabel(_PaymentMethod method) {
    switch (method) {
      case _PaymentMethod.qris:         return 'QRIS';
      case _PaymentMethod.transferBank: return 'Transfer Bank';
      case _PaymentMethod.cash:         return 'Cash / Tunai';
      case _PaymentMethod.debit:        return 'Kartu Debit';
      case _PaymentMethod.kredit:       return 'Kartu Kredit';
      case _PaymentMethod.cod:          return 'COD';
    }
  }

  IconData _paymentMethodIcon(_PaymentMethod method) {
    switch (method) {
      case _PaymentMethod.qris:         return Icons.qr_code_rounded;
      case _PaymentMethod.transferBank: return Icons.account_balance_rounded;
      case _PaymentMethod.cash:         return Icons.money_rounded;
      case _PaymentMethod.debit:        return Icons.credit_card_rounded;
      case _PaymentMethod.kredit:       return Icons.credit_score_rounded;
      case _PaymentMethod.cod:          return Icons.delivery_dining_rounded;
    }
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedBranch == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih cabang terlebih dahulu')),
      );
      return;
    }

    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih metode pembayaran terlebih dahulu')),
      );
      return;
    }

    // Validasi stok: cek semua produk di cart masih tersedia
    final outOfStockItems = _orderItems.where((item) {
      if (item.isProduct) {
        return item.product!.stock < item.quantity;
      } else if (item.isBundle) {
        return !item.bundle!.isAvailable;
      }
      return false; // pastikan tipe yang lain false
    }).toList();

    if (outOfStockItems.isNotEmpty) {
      final names = outOfStockItems.map((i) => i.name).join(', ');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Stok habis: $names. Hapus dari keranjang sebelum checkout.'),
            backgroundColor: ThemeConfig.errorColor,
            duration: const Duration(seconds: 4),
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    if (!mounted) return;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    final shippingAddress = _deliveryMethod == _DeliveryMethod.pickup
        ? 'Ambil di ${_selectedBranch!.name}'
        : _addressController.text.trim();

    final orderData = {
      'customer_id': authProvider.user!.id,
      'total_amount': _subtotal + _shippingCost,
      'shipping_cost': _shippingCost,
      'shipping_address': shippingAddress,
      'shipping_city': _selectedBranch!.name,
      'branch_id': _selectedBranch!.id,
      'branch_name': _selectedBranch!.name,
      'delivery_method': _deliveryMethod == _DeliveryMethod.delivery ? 'delivery' : 'pickup',
      'payment_method': _paymentMethodValue(_selectedPaymentMethod!),
      'notes': _notesController.text.trim(),
      'items': _orderItems.map((item) => item.toJson()).toList(),
    };

    final result = await orderProvider.createOrder(orderData);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success']) {
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
    final total = _subtotal + _shippingCost;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
                        Text('Pilih Cabang', style: ThemeConfig.heading3),
            const SizedBox(height: 8),
            Consumer<BranchProvider>(
              builder: (context, branchProvider, _) {
                if (branchProvider.isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: CircularProgressIndicator(
                        color: ThemeConfig.primaryColor,
                      ),
                    ),
                  );
                }

                if (branchProvider.branches.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Belum ada cabang tersedia. Hubungi admin.',
                      style: ThemeConfig.bodySmall.copyWith(
                        color: Colors.orange.shade800,
                      ),
                    ),
                  );
                }

                return DropdownButtonFormField<Branch>(
                  // ignore: deprecated_member_use
                  value: _selectedBranch,
                  decoration: const InputDecoration(
                    hintText: 'Pilih cabang',
                    prefixIcon: Icon(Icons.storefront_rounded),
                  ),
                  items: branchProvider.branches.map((branch) {
                    return DropdownMenuItem<Branch>(
                      value: branch,
                      child: Text(branch.name),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedBranch = value),
                  validator: (value) =>
                      value == null ? 'Pilih cabang terlebih dahulu' : null,
                );
              },
            ),

            // Alamat cabang
            if (_selectedBranch?.address != null &&
                _selectedBranch!.address!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded,
                      size: 14, color: ThemeConfig.textSecondaryColor),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _selectedBranch!.address!,
                      style: ThemeConfig.bodySmall.copyWith(
                        color: ThemeConfig.textSecondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),

                        Text('Metode Pengambilan', style: ThemeConfig.heading3),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _DeliveryTab(
                      icon: Icons.delivery_dining_rounded,
                      label: 'Diantar',
                      isSelected: _deliveryMethod == _DeliveryMethod.delivery,
                      onTap: () => setState(
                        () => _deliveryMethod = _DeliveryMethod.delivery,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _DeliveryTab(
                      icon: Icons.storefront_rounded,
                      label: 'Ambil Sendiri',
                      isSelected: _deliveryMethod == _DeliveryMethod.pickup,
                      onTap: () => setState(
                        () => _deliveryMethod = _DeliveryMethod.pickup,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

                        Text('Metode Pembayaran', style: ThemeConfig.heading3),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.8,
              children: _PaymentMethod.values.map((method) {
                final isSelected = _selectedPaymentMethod == method;
                return GestureDetector(
                  onTap: () => setState(() => _selectedPaymentMethod = method),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ThemeConfig.primaryColor.withValues(alpha: 0.1)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? ThemeConfig.primaryColor
                            : Colors.grey.shade300,
                        width: isSelected ? 1.8 : 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            _paymentMethodIcon(method),
                            size: 20,
                            color: isSelected
                                ? ThemeConfig.primaryColor
                                : ThemeConfig.textSecondaryColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _paymentMethodLabel(method),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? ThemeConfig.primaryColor
                                    : ThemeConfig.textSecondaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            // Info rekening (hanya jika Transfer Bank)
            if (_selectedPaymentMethod == _PaymentMethod.transferBank) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline_rounded,
                            size: 16, color: Colors.blue.shade700),
                        const SizedBox(width: 6),
                        Text(
                          'Info Rekening Transfer',
                          style: ThemeConfig.bodySmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Bank BCA',
                        style: ThemeConfig.bodyMedium
                            .copyWith(fontWeight: FontWeight.w600)),
                    Text('No. Rek : 1234567890'),
                    Text('a.n. SweetBake'),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),

                        if (_deliveryMethod == _DeliveryMethod.delivery) ...[
              Text('Alamat Pengiriman', style: ThemeConfig.heading3),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Masukkan alamat lengkap',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 48),
                    child: Icon(Icons.home_rounded),
                  ),
                ),
                validator: (value) {
                  if (_deliveryMethod == _DeliveryMethod.delivery &&
                      (value == null || value.trim().isEmpty)) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
            ],

                        Text('Catatan (Opsional)', style: ThemeConfig.heading3),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Catatan untuk penjual',
                prefixIcon: Icon(Icons.notes_rounded),
              ),
            ),
            const SizedBox(height: 24),

                        Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _SummaryRow(
                      label: 'Subtotal',
                      value: CurrencyFormatter.format(_subtotal),
                    ),
                    const SizedBox(height: 8),
                    _SummaryRow(
                      label: _deliveryMethod == _DeliveryMethod.pickup
                          ? 'Ongkir (Ambil Sendiri)'
                          : 'Ongkir',
                      value: _deliveryMethod == _DeliveryMethod.pickup
                          ? 'Gratis'
                          : CurrencyFormatter.format(_shippingCost),
                      valueColor: _deliveryMethod == _DeliveryMethod.pickup
                          ? ThemeConfig.successColor
                          : null,
                    ),
                    const Divider(height: 24),
                    _SummaryRow(
                      label: 'Total',
                      value: CurrencyFormatter.format(total),
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _placeOrder,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text('Buat Pesanan'),
          ),
        ),
      ),
    );
  }
}

class _DeliveryTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DeliveryTab({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? ThemeConfig.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? Colors.white : ThemeConfig.textSecondaryColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : ThemeConfig.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal ? ThemeConfig.heading3 : ThemeConfig.bodyMedium,
        ),
        Text(
          value,
          style: (isTotal ? ThemeConfig.heading3 : ThemeConfig.bodyMedium)
              .copyWith(
            color: valueColor ??
                (isTotal ? ThemeConfig.primaryColor : null),
            fontWeight: isTotal ? FontWeight.bold : null,
          ),
        ),
      ],
    );
  }
}
