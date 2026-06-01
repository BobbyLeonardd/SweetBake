import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../providers/category_provider.dart';
import '../../config/theme_config.dart';
import '../../services/api_service.dart';

enum _ImageMode { url, local }

class ProductFormPage extends StatefulWidget {
  final Product? product;

  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageUrlController = TextEditingController();
  int _categoryId = 1;
  bool _isAvailable = true;
  bool _isLoading = false;

  _ImageMode _imageMode = _ImageMode.url;
  String? _localFilePath;
  String? _localFileName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });

    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description ?? '';
      _priceController.text = widget.product!.price.toString();
      _stockController.text = widget.product!.stock.toString();
      _imageUrlController.text = widget.product!.imageUrl ?? '';
      _categoryId = widget.product!.categoryId ?? 1;
      _isAvailable = widget.product!.isAvailable;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _localFilePath = result.files.single.path;
        _localFileName = result.files.single.name;
      });
    }
  }

  Future<String?> _resolveImageUrl() async {
    if (_imageMode == _ImageMode.url) {
      return _imageUrlController.text.trim();
    }

    if (_localFilePath == null) return null;

    setState(() => _isLoading = true);
    final uploadResult = await ApiService.uploadImage(_localFilePath!);
    setState(() => _isLoading = false);

    if (!mounted) return null;

    if (uploadResult['success'] == true) {
      return uploadResult['image_url'] as String?;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(uploadResult['message'] ?? 'Gagal mengupload gambar'),
          backgroundColor: ThemeConfig.errorColor,
        ),
      );
      return null;
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (_imageMode == _ImageMode.local && _localFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih gambar terlebih dahulu'),
          backgroundColor: ThemeConfig.warningColor,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final imageUrl = await _resolveImageUrl();

    if (_imageMode == _ImageMode.local && imageUrl == null) {
      setState(() => _isLoading = false);
      return;
    }

    if (!mounted) return;
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    final productData = {
      'category_id': _categoryId,
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'price': double.parse(_priceController.text),
      'stock': int.parse(_stockController.text),
      'image_url': imageUrl ?? '',
      'is_available': _isAvailable ? 1 : 0,
    };

    Map<String, dynamic> result;
    if (widget.product != null) {
      productData['id'] = widget.product!.id;
      result = await productProvider.updateProduct(productData);
    } else {
      result = await productProvider.createProduct(productData);
    }

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.product != null ? 'Produk berhasil diupdate' : 'Produk berhasil ditambahkan',
          ),
          backgroundColor: ThemeConfig.successColor,
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal menyimpan produk'),
          backgroundColor: ThemeConfig.errorColor,
        ),
      );
    }
  }

  Future<void> _deleteProduct() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    if (!mounted) return;

    setState(() => _isLoading = true);

    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final result = await productProvider.deleteProduct(widget.product!.id);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil dihapus'),
          backgroundColor: ThemeConfig.successColor,
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal menghapus produk'),
          backgroundColor: ThemeConfig.errorColor,
        ),
      );
    }
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gambar Produk',
          style: ThemeConfig.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),

        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: _ModeTab(
                  label: '🔗  URL',
                  isSelected: _imageMode == _ImageMode.url,
                  onTap: () => setState(() {
                    _imageMode = _ImageMode.url;
                    _localFilePath = null;
                    _localFileName = null;
                  }),
                  color: ThemeConfig.primaryColor,
                ),
              ),
              Expanded(
                child: _ModeTab(
                  label: '📁  Lokal',
                  isSelected: _imageMode == _ImageMode.local,
                  onTap: () => setState(() {
                    _imageMode = _ImageMode.local;
                    _imageUrlController.clear();
                  }),
                  color: ThemeConfig.primaryColor,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        if (_imageMode == _ImageMode.url) ...[
          TextFormField(
            controller: _imageUrlController,
            decoration: const InputDecoration(
              labelText: 'URL Gambar',
              hintText: 'https://contoh.com/gambar.jpg',
              prefixIcon: Icon(Icons.link_rounded),
            ),
            onChanged: (_) => setState(() {}),
          ),
          if (_imageUrlController.text.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            _ImagePreviewFromUrl(url: _imageUrlController.text.trim()),
          ],
        ] else ...[
          GestureDetector(
            onTap: _pickFile,
            child: Container(
              width: double.infinity,
              height: _localFilePath != null ? null : 130,
              decoration: BoxDecoration(
                color: ThemeConfig.primaryColor.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: ThemeConfig.primaryColor.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: _localFilePath != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                            File(_localFilePath!),
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => setState(() {
                              _localFilePath = null;
                              _localFileName = null;
                            }),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(14),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.image_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    _localFileName ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _pickFile,
                                  child: const Text(
                                    'Ganti',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_rounded,
                          size: 40,
                          color: ThemeConfig.primaryColor.withValues(alpha: 0.6),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Ketuk untuk pilih gambar',
                          style: ThemeConfig.bodyMedium.copyWith(
                            color: ThemeConfig.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'JPG, PNG, WEBP · Maks 5 MB',
                          style: ThemeConfig.bodySmall,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product != null ? 'Edit Produk' : 'Tambah Produk'),
        actions: widget.product != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteProduct,
                ),
              ]
            : null,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Produk',
                prefixIcon: Icon(Icons.inventory_2_outlined),
              ),
              validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                prefixIcon: Icon(Icons.notes_rounded),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Harga',
                prefixIcon: Icon(Icons.attach_money_rounded),
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Harga tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _stockController,
              decoration: const InputDecoration(
                labelText: 'Stok',
                prefixIcon: Icon(Icons.layers_rounded),
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Stok tidak boleh kosong' : null,
            ),
            const SizedBox(height: 20),

            _buildImageSection(),

            const SizedBox(height: 20),
            Consumer<CategoryProvider>(
              builder: (context, categoryProvider, child) {
                if (categoryProvider.isLoading && categoryProvider.categories.isEmpty) {
                  return const CircularProgressIndicator();
                }

                if (categoryProvider.categories.isNotEmpty) {
                  final exists = categoryProvider.categories.any((c) => c.id == _categoryId);
                  if (!exists) {
                    _categoryId = categoryProvider.categories.first.id;
                  }
                }

                return DropdownButtonFormField<int>(
                  initialValue: _categoryId,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: categoryProvider.categories.map((category) {
                    return DropdownMenuItem(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _categoryId = value!),
                );
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Tersedia'),
              subtitle: const Text('Produk dapat dipesan oleh pelanggan'),
              value: _isAvailable,
              onChanged: (value) => setState(() => _isAvailable = value),
              activeThumbColor: ThemeConfig.primaryColor,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveProduct,
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
                  : Text(widget.product != null ? 'Update Produk' : 'Simpan Produk'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _ModeTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : ThemeConfig.textSecondaryColor,
          ),
        ),
      ),
    );
  }
}

class _ImagePreviewFromUrl extends StatelessWidget {
  final String url;

  const _ImagePreviewFromUrl({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        url,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            height: 180,
            color: Colors.grey.shade100,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image_rounded, color: Colors.grey.shade400),
                const SizedBox(width: 8),
                Text(
                  'URL tidak valid atau gambar tidak bisa dimuat',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
