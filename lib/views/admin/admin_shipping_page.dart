import 'package:flutter/material.dart';
import '../../models/shipping_model.dart';
import '../../services/api_service.dart';
import '../../config/theme_config.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/loading_widget.dart';

class AdminShippingPage extends StatefulWidget {
  const AdminShippingPage({super.key});

  @override
  State<AdminShippingPage> createState() => _AdminShippingPageState();
}

class _AdminShippingPageState extends State<AdminShippingPage> {
  List<ShippingCost> _shippingCosts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadShippingCosts();
  }

  Future<void> _loadShippingCosts() async {
    setState(() => _isLoading = true);
    final data = await ApiService.getShippingCosts();
    setState(() {
      _shippingCosts = data;
      _isLoading = false;
    });
  }

  void _showShippingDialog({ShippingCost? shipping}) {
    final isEditing = shipping != null;
    final formKey = GlobalKey<FormState>();
    final cityController = TextEditingController(text: shipping?.city ?? '');
    final costController = TextEditingController(text: shipping?.cost.toString() ?? '');
    final daysController = TextEditingController(text: shipping?.estimatedDays.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Ongkos Kirim' : 'Tambah Ongkos Kirim'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: cityController,
                  decoration: const InputDecoration(labelText: 'Kota'),
                  validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: costController,
                  decoration: const InputDecoration(labelText: 'Biaya (Rp)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Wajib diisi';
                    if (double.tryParse(value) == null) return 'Harus berupa angka';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: daysController,
                  decoration: const InputDecoration(labelText: 'Estimasi Hari (Misal: 2-3 hari)'),
                  validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, {
                  'city': cityController.text,
                  'cost': double.parse(costController.text),
                  'estimated_days': daysController.text,
                });
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: ThemeConfig.primaryColor),
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ).then((dynamic result) async {
      if (result != null && mounted) {
        final Map<String, dynamic> data = result as Map<String, dynamic>;
        setState(() => _isLoading = true);
        
        Map<String, dynamic> response;
        if (isEditing) {
          data['id'] = shipping.id;
          response = await ApiService.updateShippingCost(data);
        } else {
          response = await ApiService.createShippingCost(data);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? (response['success'] ? 'Berhasil disimpan' : 'Gagal menyimpan'))),
          );
          if (response['success']) {
            _loadShippingCosts();
          } else {
            setState(() => _isLoading = false);
          }
        }
      }
    });
  }

  void _deleteShipping(ShippingCost shipping) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Ongkos Kirim?'),
        content: Text('Yakin ingin menghapus ongkos kirim untuk kota ${shipping.city}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: ThemeConfig.errorColor),
            child: const Text('Hapus'),
          ),
        ],
      ),
    ).then((confirm) async {
      if (confirm == true && mounted) {
        setState(() => _isLoading = true);
        final response = await ApiService.deleteShippingCost(shipping.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? (response['success'] ? 'Berhasil dihapus' : 'Gagal menghapus'))),
          );
          if (response['success']) {
            _loadShippingCosts();
          } else {
            setState(() => _isLoading = false);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Ongkos Kirim'),
        backgroundColor: ThemeConfig.backgroundColor,
      ),
      body: _isLoading
          ? const LoadingWidget()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _shippingCosts.length,
              itemBuilder: (context, index) {
                final shipping = _shippingCosts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(shipping.city, style: ThemeConfig.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                    subtitle: Text('Estimasi: ${shipping.estimatedDays}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          CurrencyFormatter.format(shipping.cost),
                          style: ThemeConfig.bodyMedium.copyWith(color: ThemeConfig.primaryColor, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showShippingDialog(shipping: shipping),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: ThemeConfig.errorColor),
                          onPressed: () => _deleteShipping(shipping),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ThemeConfig.primaryColor,
        onPressed: () => _showShippingDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
