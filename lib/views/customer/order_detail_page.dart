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

class OrderDetailPage extends StatefulWidget {
  final int orderId;

  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  Order? _order;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrder();
    });
  }

  Future<void> _loadOrder() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final order = await orderProvider.getOrder(widget.orderId);
    setState(() {
      _order = order;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: LoadingWidget(),
      );
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
                    Text(_order!.branchName!, style: ThemeConfig.bodyMedium
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
                    style: ThemeConfig.bodyMedium.copyWith(
                      color: _order!.shippingCost == 0
                          ? ThemeConfig.successColor
                          : null,
                      fontWeight: _order!.shippingCost == 0
                          ? FontWeight.w600
                          : null,
                    ),
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
            Text('Riwayat Pelacakan', style: ThemeConfig.heading3),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _order!.tracking!.length,
                  itemBuilder: (context, index) {
                    final track = _order!.tracking![index];
                    final isFirst = index == 0;
                    final isLast = index == _order!.tracking!.length - 1;
                    
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isFirst ? ThemeConfig.primaryColor : Colors.grey.shade400,
                              ),
                            ),
                            if (!isLast)
                              Container(
                                width: 2,
                                height: 40,
                                color: Colors.grey.shade300,
                              ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  track.status.toUpperCase(),
                                  style: ThemeConfig.bodySmall.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isFirst ? ThemeConfig.primaryColor : Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  track.description ?? track.status,
                                  style: ThemeConfig.bodyMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormatter.format(track.createdAt),
                                  style: ThemeConfig.bodySmall.copyWith(color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          Card(
            color: ThemeConfig.primaryColor.withValues(alpha: 0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: ThemeConfig.primaryColor.withValues(alpha: 0.2)),
            ),
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
          const SizedBox(height: 24),

          if (_order!.paymentStatus == 'unpaid' &&
              _order!.status != 'cancelled' &&
              _order!.status != 'delivered') ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: const Text('SUDAH BAYAR', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  showDialog<bool>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Konfirmasi Pembayaran'),
                      content: const Text('Apakah Anda sudah melakukan pembayaran? Admin akan memverifikasi pembayaran Anda.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext, false),
                          child: const Text('Belum'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(dialogContext, true);
                            setState(() => _isLoading = true);
                            final orderProvider = Provider.of<OrderProvider>(context, listen: false);
                            final result = await orderProvider.updateOrderStatus(
                              _order!.id,
                              _order!.status,
                              'Customer konfirmasi sudah bayar - menunggu verifikasi admin',
                            );
                            if (context.mounted) {
                              if (result['success']) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Konfirmasi pembayaran terkirim! Admin akan memverifikasi.'),
                                    backgroundColor: ThemeConfig.successColor,
                                  ),
                                );
                                _loadOrder();
                              } else {
                                setState(() => _isLoading = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result['message'] ?? 'Gagal mengirim konfirmasi')),
                                );
                              }
                            }
                          },
                          child: const Text('Ya, Sudah Bayar'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeConfig.successColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          if (_order!.status == 'pending')
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  showDialog<bool>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Batalkan Pesanan?'),
                      content: const Text('Apakah Anda yakin ingin membatalkan pesanan ini? Aksi ini tidak dapat dikembalikan.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext, false),
                          child: const Text('Tidak'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(dialogContext, true);
                            setState(() => _isLoading = true);
                            final orderProvider = Provider.of<OrderProvider>(context, listen: false);
                            final result = await orderProvider.updateOrderStatus(
                              _order!.id, 
                              'cancelled', 
                              'Dibatalkan oleh pelanggan'
                            );

                            if (context.mounted) {
                              if (result['success']) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Pesanan berhasil dibatalkan')),
                                );
                                _loadOrder(); // refresh data
                              } else {
                                setState(() => _isLoading = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result['message'] ?? 'Gagal membatalkan')),
                                );
                              }
                            }
                          },
                          style: TextButton.styleFrom(foregroundColor: ThemeConfig.errorColor),
                          child: const Text('Ya, Batalkan'),
                        ),
                      ],
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: ThemeConfig.errorColor,
                  side: BorderSide(color: ThemeConfig.errorColor),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('BATALKAN PESANAN', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }
}
