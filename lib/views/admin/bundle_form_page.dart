import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/bundle_model.dart';
import '../../providers/bundle_provider.dart';
import '../../config/theme_config.dart';
import '../../services/api_service.dart';

enum _ImageMode { url, local }

class BundleFormPage extends StatefulWidget {
  final Bundle? bundle;

  const BundleFormPage({super.key, this.bundle});

  @override
  State<BundleFormPage> createState() => _BundleFormPageState();
}

class _BundleFormPageState extends State<BundleFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _promoPriceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isAvailable = true;
  bool _isLoading = false;

  _ImageMode _imageMode = _ImageMode.url;
  String? _localFilePath;

  @override
  void initState() {
    super.initState();

    if (widget.bundle != null) {
      _nameController.text = widget.bundle!.name;
      _descriptionController.text = widget.bundle!.description ?? '';
      _originalPriceController.text = widget.bundle!.originalPrice.toString();
      _promoPriceController.text = widget.bundle!.promoPrice.toString();
      _imageUrlController.text = widget.bundle!.imageUrl ?? '';
      _isAvailable = widget.bundle!.isAvailable;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _originalPriceController.dispose();
    _promoPriceController.dispose();
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

  Future<void> _saveBundle() async {
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
    final bundleProvider = Provider.of<BundleProvider>(context, listen: false);

    final bundleData = {
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'original_price': double.parse(_originalPriceController.text),
      'promo_price': double.parse(_promoPriceController.text),
      'image_url': imageUrl ?? '',
      'is_available': _isAvailable ? 1 : 0,
    };

    Map<String, dynamic> result;
    if (widget.bundle != null) {
      bundleData['id'] = widget.bundle!.id;
      result = await bundleProvider.updateBundle(widget.bundle!.id, bundleData);
    } else {
      result = await bundleProvider.createBundle(bundleData);
    }

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.bundle != null ? 'Paket berhasil diupdate' : 'Paket berhasil ditambahkan',
          ),
          backgroundColor: ThemeConfig.successColor,
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal menyimpan paket'),
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
          'Gambar Paket',
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
                  }),
                  color: ThemeConfig.accentColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (_imageMode == _ImageMode.url)
          TextFormField(
            controller: _imageUrlController,
            decoration: const InputDecoration(
              labelText: 'URL Gambar (Unsplash/Imgur)',
              prefixIcon: Icon(Icons.link_rounded),
              hintText: 'https://...',
            ),
          )
        else
          _buildUploadArea(),
      ],
    );
  }

  Widget _buildUploadArea() {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: ThemeConfig.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _localFilePath != null
                ? ThemeConfig.accentColor
                : Colors.grey.shade300,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: _localFilePath != null
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      File(_localFilePath!),
                      fit: BoxFit.cover,
                    ),
                    Container(
                      color: Colors.black.withValues(alpha: 0.4),
                      child: const Center(
                        child: Icon(
                          Icons.edit_rounded,
                          color: Colors.white,
                          size: 32,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bundle != null ? 'Edit Paket' : 'Tambah Paket'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Paket',
                prefixIcon: Icon(Icons.card_giftcard_rounded),
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
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _originalPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Harga Normal',
                      prefixText: 'Rp ',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Tidak boleh kosong' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _promoPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Harga Promo',
                      prefixText: 'Rp ',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Tidak boleh kosong' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildImageSection(),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('Status Aktif'),
              subtitle: Text(_isAvailable ? 'Paket tersedia' : 'Paket disembunyikan'),
              value: _isAvailable,
              activeThumbColor: ThemeConfig.primaryColor,
              onChanged: (val) => setState(() => _isAvailable = val),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveBundle,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: ThemeConfig.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text(
                    'Simpan Paket',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
