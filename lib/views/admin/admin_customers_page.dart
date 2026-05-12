import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/customer_provider.dart';
import '../../models/user_model.dart';
import '../../config/theme_config.dart';
import '../../widgets/loading_widget.dart';

class AdminCustomersPage extends StatefulWidget {
  const AdminCustomersPage({super.key});

  @override
  State<AdminCustomersPage> createState() => _AdminCustomersPageState();
}

class _AdminCustomersPageState extends State<AdminCustomersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CustomerProvider>(context, listen: false).fetchCustomers();
    });
  }

  void _showEditDialog(User customer) {
    final nameController = TextEditingController(text: customer.name);
    final emailController = TextEditingController(text: customer.email);
    final phoneController = TextEditingController(text: customer.phone ?? '');
    final addressController = TextEditingController(text: customer.address ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Pelanggan'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nama'),
                    validator: (v) => v!.isEmpty ? 'Nama wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => v!.isEmpty ? 'Email wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'No. HP (Opsional)'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Alamat (Opsional)'),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.of(dialogContext).pop();
                  final customerProvider = Provider.of<CustomerProvider>(context, listen: false);
                  final result = await customerProvider.updateCustomer({
                    'id': customer.id,
                    'name': nameController.text,
                    'email': emailController.text,
                    'phone': phoneController.text,
                    'address': addressController.text,
                  });

                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result['message'] ?? (result['success'] ? 'Berhasil' : 'Gagal')),
                      backgroundColor: result['success'] ? ThemeConfig.successColor : ThemeConfig.errorColor,
                    ),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(User customer) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Pelanggan'),
        content: Text('Anda yakin ingin menghapus akun pelanggan ${customer.name}? Operasi ini mungkin gagal jika pelanggan memiliki riwayat pesanan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final customerProvider = Provider.of<CustomerProvider>(context, listen: false);
              final result = await customerProvider.deleteCustomer(customer.id);
              
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(result['message'] ?? (result['success'] ? 'Berhasil dihapus' : 'Gagal dihapus')),
                  backgroundColor: result['success'] ? ThemeConfig.successColor : ThemeConfig.errorColor,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: ThemeConfig.errorColor),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Pelanggan'),
      ),
      body: RefreshIndicator(
        onRefresh: () => customerProvider.fetchCustomers(),
        child: customerProvider.isLoading && customerProvider.customers.isEmpty
            ? const LoadingWidget()
            : customerProvider.customers.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 100),
                      Center(child: Text('Belum ada pelanggan terdaftar')),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: customerProvider.customers.length,
                    itemBuilder: (context, index) {
                      final customer = customerProvider.customers[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ExpansionTile(
                          shape: const Border(),
                          leading: CircleAvatar(
                            backgroundColor: ThemeConfig.primaryColor.withValues(alpha: 0.1),
                            child: Text(
                              customer.name.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                color: ThemeConfig.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(customer.email, style: const TextStyle(fontSize: 12)),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.phone, size: 16, color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Text(customer.phone != null && customer.phone!.isNotEmpty ? customer.phone! : 'Belum diatur'),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(customer.address != null && customer.address!.isNotEmpty ? customer.address! : 'Belum diatur'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton.icon(
                                        onPressed: () => _showEditDialog(customer),
                                        icon: const Icon(Icons.edit, size: 16),
                                        label: const Text('Edit'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: ThemeConfig.primaryColor,
                                          side: const BorderSide(color: ThemeConfig.primaryColor),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      OutlinedButton.icon(
                                        onPressed: () => _confirmDelete(customer),
                                        icon: const Icon(Icons.delete, size: 16),
                                        label: const Text('Hapus'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: ThemeConfig.errorColor,
                                          side: const BorderSide(color: ThemeConfig.errorColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
