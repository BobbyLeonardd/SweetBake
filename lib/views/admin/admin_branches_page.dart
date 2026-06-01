import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/branch_model.dart';
import '../../providers/branch_provider.dart';
import '../../config/theme_config.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state_widget.dart';

class AdminBranchesPage extends StatefulWidget {
  const AdminBranchesPage({super.key});

  @override
  State<AdminBranchesPage> createState() => _AdminBranchesPageState();
}

class _AdminBranchesPageState extends State<AdminBranchesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BranchProvider>(context, listen: false).fetchAllBranches();
    });
  }

  void _showBranchForm({Branch? branch}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BranchFormSheet(branch: branch),
    );
  }

  Future<void> _deleteBranch(Branch branch) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Cabang'),
        content: Text('Hapus cabang "${branch.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    final result = await Provider.of<BranchProvider>(context, listen: false)
        .deleteBranch(branch.id);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message'] ?? 'Operasi selesai'),
        backgroundColor:
            result['success'] == true ? ThemeConfig.successColor : ThemeConfig.errorColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Kelola Cabang'),
        elevation: 0,
      ),
      body: Consumer<BranchProvider>(
        builder: (context, branchProvider, _) {
          if (branchProvider.isLoading) return const LoadingWidget();

          if (branchProvider.branches.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.storefront_rounded,
              title: 'Belum ada cabang',
              subtitle: 'Ketuk tombol + untuk menambah cabang baru',
            );
          }

          return RefreshIndicator(
            onRefresh: () => branchProvider.fetchAllBranches(),
            color: ThemeConfig.primaryColor,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: branchProvider.branches.length,
              itemBuilder: (context, index) {
                final branch = branchProvider.branches[index];
                return _buildBranchCard(branch);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBranchForm(),
        backgroundColor: ThemeConfig.primaryColor,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Tambah Cabang',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildBranchCard(Branch branch) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: ThemeConfig.softShadow,
        border: Border.all(
          color: branch.isActive
              ? ThemeConfig.primaryColor.withValues(alpha: 0.2)
              : Colors.grey.shade200,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        leading: CircleAvatar(
          backgroundColor: branch.isActive
              ? ThemeConfig.primaryColor.withValues(alpha: 0.1)
              : Colors.grey.shade100,
          child: Icon(
            Icons.storefront_rounded,
            color: branch.isActive ? ThemeConfig.primaryColor : Colors.grey,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                branch.name,
                style: ThemeConfig.bodyMedium
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: branch.isActive
                    ? ThemeConfig.successColor.withValues(alpha: 0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                branch.isActive ? 'Aktif' : 'Nonaktif',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: branch.isActive
                      ? ThemeConfig.successColor
                      : Colors.grey,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (branch.address != null && branch.address!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded,
                      size: 13, color: ThemeConfig.textSecondaryColor),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      branch.address!,
                      style: ThemeConfig.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            if (branch.phone != null && branch.phone!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.phone_rounded,
                      size: 13, color: ThemeConfig.textSecondaryColor),
                  const SizedBox(width: 3),
                  Text(branch.phone!, style: ThemeConfig.bodySmall),
                ],
              ),
            ],
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.delivery_dining_rounded,
                    size: 13, color: ThemeConfig.primaryColor),
                const SizedBox(width: 3),
                Text(
                  'Ongkir: ${CurrencyFormatter.format(branch.deliveryCost)}',
                  style: ThemeConfig.bodySmall.copyWith(
                    color: ThemeConfig.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') _showBranchForm(branch: branch);
            if (value == 'delete') _deleteBranch(branch);
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}

// Bottom sheet form tambah/edit cabang
class _BranchFormSheet extends StatefulWidget {
  final Branch? branch;
  const _BranchFormSheet({this.branch});

  @override
  State<_BranchFormSheet> createState() => _BranchFormSheetState();
}

class _BranchFormSheetState extends State<_BranchFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _deliveryCostController = TextEditingController();
  bool _isActive = true;
  bool _isLoading = false;

  bool get _isEdit => widget.branch != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _nameController.text = widget.branch!.name;
      _addressController.text = widget.branch!.address ?? '';
      _phoneController.text = widget.branch!.phone ?? '';
      _deliveryCostController.text =
          widget.branch!.deliveryCost.toStringAsFixed(0);
      _isActive = widget.branch!.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _deliveryCostController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final branchProvider =
        Provider.of<BranchProvider>(context, listen: false);

    final data = {
      if (_isEdit) 'id': widget.branch!.id,
      'name': _nameController.text.trim(),
      'address': _addressController.text.trim(),
      'phone': _phoneController.text.trim(),
      'delivery_cost':
          double.tryParse(_deliveryCostController.text) ?? 0,
      'is_active': _isActive ? 1 : 0,
    };

    final result = _isEdit
        ? await branchProvider.updateBranch(data)
        : await branchProvider.createBranch(data);

    setState(() => _isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message'] ?? 'Operasi selesai'),
        backgroundColor: result['success'] == true
            ? ThemeConfig.successColor
            : ThemeConfig.errorColor,
      ),
    );

    if (result['success'] == true) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _isEdit ? 'Edit Cabang' : 'Tambah Cabang',
                style: ThemeConfig.heading3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Cabang *',
                  prefixIcon: Icon(Icons.storefront_rounded),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  prefixIcon: Icon(Icons.location_on_rounded),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'No. Telepon',
                  prefixIcon: Icon(Icons.phone_rounded),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _deliveryCostController,
                decoration: const InputDecoration(
                  labelText: 'Biaya Pengiriman (Rp)',
                  prefixIcon: Icon(Icons.delivery_dining_rounded),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Biaya wajib diisi';
                  if (double.tryParse(v) == null) return 'Format tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Cabang Aktif'),
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
                activeThumbColor: ThemeConfig.primaryColor,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(_isEdit ? 'Update Cabang' : 'Simpan Cabang'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
