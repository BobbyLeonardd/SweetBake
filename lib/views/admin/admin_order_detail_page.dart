import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/order_provider.dart';
import '../../models/order_model.dart';
import '../../config/theme_config.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/loading_widget.dart';

String _paymentMethodLabel(String method) {
  const labels = {
    'qris': 'QRIS',
    'transfer_bank': 'Transfer Bank',
    'cash': 'Cash / Tunai',
    'debit': 'Kartu Debit',
    'kredit': 'Kartu Kredit',
    'cod': 'COD',
  };
  return labels[method] ?? method;
}

class AdminOrderDetailPage extends StatefulWidget {
  final int orderId;

  const AdminOrderDetailPage({super.key, required this.orderId});

  @override
  State<AdminOrderDetailPage> createState() => _AdminOrderDetailPageState();
}

class _AdminOrderDetailPageState extends State<AdminOrderDetailPage> {
  Order? _order;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final order = await orderProvider.getOrder(widget.orderId);
    setState(() {
      _order = order;
      _isLoading = false;
    });
  }

  Future<void> _updateStatus(String status, String description) async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final result = await orderProvider.updateOrderStatus(
      widget.orderId,
      status,
      description,
    );

    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Status pesanan berhasil diupdate'),
          backgroundColor: ThemeConfig.successColor,
        ),
      );
      _loadOrder();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal update status'),
          backgroundColor: ThemeConfig.errorColor,
        ),
      );
    }
  }

  void _showUpdateStatusDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String selectedStatus = _order!.status;
        final descriptionController = TextEditingController();

        return AlertDialog(
          title: const Text('Update Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(value: 'pending', child: Text('Menunggu Konfirmasi')),
                  DropdownMenuItem(value: 'confirmed', child: Text('Dikonfirmasi')),
                  DropdownMenuItem(value: 'processing', child: Text('Diproses')),
                  DropdownMenuItem(value: 'shipped', child: Text('Dikirim')),
                  DropdownMenuItem(value: 'delivered', child: Text('Selesai')),
                  DropdownMenuItem(value: 'cancelled', child: Text('Dibatalkan')),
                ],
                onChanged: (value) => selectedStatus = value!,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Keterangan'),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateStatus(selectedStatus, descriptionController.text);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: LoadingWidget());
    }

    if (_order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Pesanan')),
        body: const Center(child: Text('Pesanan tidak ditemukan')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showUpdateStatusDialog,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nomor Pesanan', style: ThemeConfig.bodySmall),
                  Text(_order!.orderNumber, style: ThemeConfig.heading3),
                  const SizedBox(height: 8),
                  Text('Customer', style: ThemeConfig.bodySmall),
                  Text(_order!.customerName ?? '-'),
                  const SizedBox(height: 8),
                  Text('Tanggal', style: ThemeConfig.bodySmall),
                  Text(DateFormatter.format(_order!.createdAt)),
                  const SizedBox(height: 8),
                  Text('Status', style: ThemeConfig.bodySmall),
                  Text(_order!.statusText, style: ThemeConfig.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ThemeConfig.primaryColor,
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Produk', style: ThemeConfig.heading3),
          const SizedBox(height: 8),
          ...(_order!.items ?? []).map((item) => Card(
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl ?? '',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[200],
                        child: const Icon(Icons.cake),
                      ),
                    ),
                  ),
                  title: Text(item.productName ?? ''),
                  subtitle: Text('${item.quantity}x ${CurrencyFormatter.format(item.price)}'),
                  trailing: Text(
                    CurrencyFormatter.format(item.subtotal),
                    style: ThemeConfig.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              )),
          const SizedBox(height: 16),
          Text('Pengiriman', style: ThemeConfig.heading3),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_order!.branchName != null) ...[
                    Text('Cabang', style: ThemeConfig.bodySmall),
                    Text(_order!.branchName!,
                        style: ThemeConfig.bodyMedium
                            .copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                  ],
                  Text('Metode', style: ThemeConfig.bodySmall),
                  Row(children: [
                    Icon(
                      _order!.deliveryMethod == 'pickup'
                          ? Icons.storefront_rounded
                          : Icons.delivery_dining_rounded,
                      size: 16,
                      color: ThemeConfig.primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _order!.deliveryMethod == 'pickup'
                          ? 'Ambil Sendiri'
                          : 'Diantar',
                      style: ThemeConfig.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Text('Alamat', style: ThemeConfig.bodySmall),
                  Text(_order!.shippingAddress),
                  const SizedBox(height: 8),
                  Text('Ongkir', style: ThemeConfig.bodySmall),
                  Text(
                    _order!.shippingCost == 0
                        ? 'Gratis'
                        : CurrencyFormatter.format(_order!.shippingCost),
                  ),
                  if (_order!.paymentMethod != null) ...[  
                    const SizedBox(height: 8),
                    Text('Metode Pembayaran', style: ThemeConfig.bodySmall),
                    Text(
                      _paymentMethodLabel(_order!.paymentMethod!),
                      style: ThemeConfig.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_order!.tracking != null && _order!.tracking!.isNotEmpty) ...[
            Text('Tracking', style: ThemeConfig.heading3),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: _order!.tracking!.map((track) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.circle, size: 12, color: ThemeConfig.primaryColor),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(track.description ?? track.status),
                                  Text(
                                    DateFormatter.format(track.createdAt),
                                    style: ThemeConfig.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Card(
            color: ThemeConfig.primaryColor.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Pembayaran', style: ThemeConfig.heading3),
                  Text(
                    CurrencyFormatter.format(_order!.totalAmount + _order!.shippingCost),
                    style: ThemeConfig.heading3.copyWith(
                      color: ThemeConfig.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
