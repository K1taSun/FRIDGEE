import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart'; 

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../inventory/domain/opened_products_provider.dart';
import '../../inventory/domain/product_category_codec.dart';
import '../../inventory/domain/product_item.dart';
import '../../inventory/domain/product_provider.dart';
import '../../inventory/domain/storage_provider.dart';
import '../data/local_vision_service.dart';
import '../data/openfoodfacts_client.dart';
import '../domain/detected_product_category.dart';
import '../domain/live_scan_result.dart';
import '../utils/expiry_date_calculator.dart';
import 'barcode_only_scanner.dart';
import 'hybrid_live_scanner.dart';
import 'widgets/date_picker_modal.dart';
import 'widgets/product_form_fields.dart';

class AddProductPage extends ConsumerStatefulWidget {
  final String? initialBarcode;
  final String? initialProductName;
  final DateTime? initialExpiryDate;
  final ProductItem? productToEdit;

  const AddProductPage({
    super.key,
    this.initialBarcode,
    this.initialProductName,
    this.initialExpiryDate,
    this.productToEdit,
  });

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _openFoodFactsClient = OpenFoodFactsClient();
  final _localVisionService = LocalVisionService();
  final _imagePicker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(text: '1.0');
  
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  bool _hasUserModifiedDate = false; 
  
  String? _selectedStorageObjectId; 
  StorageUnit _selectedUnit = StorageUnit.szt;
  String _selectedType = 'inne'; 
  bool _isOpened = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    if (widget.productToEdit != null) {
      final p = widget.productToEdit!;
      _nameController.text = p.name;
      _barcodeController.text = p.barcode ?? '';
      _brandController.text = ''; 
      _caloriesController.text = p.caloriesPer100g != null ? p.caloriesPer100g!.toStringAsFixed(0) : '';
      _quantityController.text = p.quantity.toString();
      _selectedDate = p.expiryDate;
      _hasUserModifiedDate = true; 
      _selectedUnit = p.unit;
      
      _selectedType = ProductCategoryCodec.type(p.category) ?? 'inne';
      _selectedStorageObjectId = ProductCategoryCodec.storageId(p.category);
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ref.read(openedProductsProvider).contains(p.uuid)) {
          setState(() => _isOpened = true);
        }
      });
    } else {
      _calculateDefaultExpiryDate();
      _applyScannerResults(
        barcode: widget.initialBarcode,
        productName: widget.initialProductName,
        expiryDate: widget.initialExpiryDate,
      );
    }
  }

  void _applyScannerResults({
    String? barcode,
    String? productName,
    DateTime? expiryDate,
  }) {
    if (barcode != null) {
      _barcodeController.text = barcode;
      _fetchData(barcode);
    }
    if (productName != null) {
      _nameController.text = productName;
      _applyProductTypeFromAiName(productName);
      _calculateDefaultExpiryDate();
    }
    if (expiryDate != null) {
      _selectedDate = expiryDate;
      _hasUserModifiedDate = true;
    }
  }

  void _applyProductTypeFromAiName(String aiName) {
    final type = DetectedProductCategory.typeForName(aiName);
    if (type != null) _selectedType = type;
  }

  void _calculateDefaultExpiryDate() {
    if (_hasUserModifiedDate) return; 
    setState(() {
      _selectedDate = ExpiryDateCalculator.calculate(
        ref: ref,
        storageObjectId: _selectedStorageObjectId,
        productType: _selectedType,
      );
    });
  }

  Future<void> _fetchData(String barcode) async {
    setState(() => _isLoading = true);
    try {
      final result = await _openFoodFactsClient.lookupBarcode(barcode);
      if (result.found && result.hasData) {
        setState(() {
          if (result.name != null) _nameController.text = result.name!;
          if (result.brand != null) _brandController.text = result.brand!;
          if (result.caloriesPer100g != null) {
            _caloriesController.text = result.caloriesPer100g!.toStringAsFixed(0);
          }
        });
      } else if (result.errorMessage != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.errorMessage!), backgroundColor: AppColors.error),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white),
                SizedBox(width: 12),
                Expanded(child: Text('Tego produktu nie ma jeszcze w bazie. Proszę, wpisz jego nazwę ręcznie.', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            backgroundColor: AppColors.warning,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      debugPrint('Błąd API OFF: $e');
    } finally { 
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _startBarcodeScanner() async {
    final map = await Navigator.of(context, rootNavigator: true).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => const BarcodeOnlyScannerPage()),
    );

    if (map == null) return;
    final barcode = map['barcode'] as String?;
    if (barcode == null) return;
    setState(() {
      _barcodeController.text = barcode;
      _fetchData(barcode);
    });
  }

  Future<void> _startHybridLiveScanner() async {
    final map = await Navigator.of(context, rootNavigator: true).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => const HybridLiveScannerPage()),
    );

    if (map == null) return;
    final result = LiveScanResult.fromMap(map);
    setState(() {
      _applyScannerResults(
        barcode: result.barcode,
        productName: result.productName,
        expiryDate: result.expiryDate,
      );
    });
  }

  Future<void> _scanExpiryDateOcr() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(source: ImageSource.camera);
      if (!mounted || photo == null) return;
        
      setState(() => _isLoading = true);
      final ocrResult = await _localVisionService.recognizeLabel(photo.path);

      if (!mounted) return;
      if (ocrResult.extractedDate != null) {
        setState(() {
          _selectedDate = ocrResult.extractedDate!;
          _hasUserModifiedDate = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Odczytano datę: ${DateFormat('dd.MM.yyyy').format(_selectedDate)}'), backgroundColor: AppColors.success),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nie udało się odczytać daty z tego zdjęcia.'), backgroundColor: AppColors.error),
        );
      }
    } catch (e) {
      debugPrint('Błąd OCR: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showDatePickerModal() {
    DatePickerModal.show(
      context: context,
      initialDate: _selectedDate,
      onDateTimeChanged: (newDate) {
        setState(() {
          _selectedDate = newDate;
          _hasUserModifiedDate = true;
        });
      },
      onDone: () {
        setState(() => _hasUserModifiedDate = true); 
        Navigator.pop(context);
      },
    );
  }

  void _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final currentStorageObjects = ref.read(customStorageObjectsProvider);
    if (_selectedStorageObjectId == null && currentStorageObjects.isNotEmpty) {
      _selectedStorageObjectId = currentStorageObjects.first['id'] as String;
    }

    if (_selectedStorageObjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dodaj strefę (np. Lodówkę) w Magazynie!'), backgroundColor: AppColors.error));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final targetStorage = currentStorageObjects.firstWhere((o) => o['id'] == _selectedStorageObjectId);
      StorageLocation baseLocation = StorageLocation.fridge;
      final storageType = targetStorage['type'] as String? ?? 'lodówka';
      if (storageType == 'zamrażarka') {
        baseLocation = StorageLocation.freezer;
      } else if (storageType == 'szafka' || storageType == 'spiżarnia') {
        baseLocation = StorageLocation.pantry;
      }

      final serializedCategory = ProductCategoryCodec.encode(
        type: _selectedType,
        storageId: _selectedStorageObjectId!,
      );

      final product = ProductItem(
        dbId: widget.productToEdit?.dbId, 
        uuid: widget.productToEdit?.uuid ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        quantity: double.tryParse(_quantityController.text) ?? 1.0,
        unit: _selectedUnit,
        expiryDate: _selectedDate,
        storageLocation: baseLocation,
        barcode: _barcodeController.text.trim().isEmpty ? null : _barcodeController.text.trim(),
        category: serializedCategory, 
        caloriesPer100g: double.tryParse(_caloriesController.text),
        imageUrl: widget.productToEdit?.imageUrl,
        addedDate: widget.productToEdit?.addedDate ?? DateTime.now(),
        isConsumed: widget.productToEdit?.isConsumed ?? false,
      );

      await ref.read(inventoryNotifierProvider.notifier).addProduct(product);

      final isCurrentlyOpened = ref.read(openedProductsProvider).contains(product.uuid);
      if (_isOpened != isCurrentlyOpened) {
        ref.read(openedProductsProvider.notifier).toggle(product.uuid);
      }

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.productToEdit != null ? 'Zapisano zmiany' : 'Produkt dodany!'), backgroundColor: AppColors.success),
      );

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Błąd zapisu: $e'), backgroundColor: AppColors.error));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStorageObjects = ref.watch(customStorageObjectsProvider);
    if (_selectedStorageObjectId == null && currentStorageObjects.isNotEmpty) {
      _selectedStorageObjectId = currentStorageObjects.first['id'] as String;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.productToEdit != null ? 'Modyfikacja' : 'Nowy produkt'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _startHybridLiveScanner,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          side: const BorderSide(color: AppColors.primary, width: 2.0),
                          shape: const RoundedRectangleBorder(borderRadius: AppTheme.radiusMedium),
                        ),
                        icon: const Icon(Icons.bolt, color: AppColors.primary, size: 28),
                        label: const Text('Włącz Główne Skanowanie', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      const SizedBox(height: 24),
                      
                      ProductBasicInfoFields(
                        nameController: _nameController,
                        selectedType: _selectedType,
                        onTypeChanged: (v) {
                          setState(() {
                            _selectedType = v!;
                            _calculateDefaultExpiryDate(); 
                          });
                        },
                        barcodeController: _barcodeController,
                        onBarcodeScannerTapped: _startBarcodeScanner,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      ProductQuantityFields(
                        quantityController: _quantityController,
                        selectedUnit: _selectedUnit,
                        onUnitChanged: (v) => setState(() => _selectedUnit = v as StorageUnit),
                      ),
                      
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 20),
                      
                      ProductStorageFields(
                        currentStorageObjects: currentStorageObjects,
                        selectedStorageObjectId: _selectedStorageObjectId,
                        onStorageChanged: (v) {
                          setState(() {
                            _selectedStorageObjectId = v!;
                            _calculateDefaultExpiryDate(); 
                          });
                        },
                        selectedDate: _selectedDate,
                        onDatePickerTapped: _showDatePickerModal,
                        onOcrScannerTapped: _scanExpiryDateOcr,
                        isOpened: _isOpened,
                        onIsOpenedChanged: (v) => setState(() => _isOpened = v),
                      ),
                      
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity, height: 52,
                        child: ElevatedButton(
                          onPressed: _saveProduct,
                          child: Text(widget.productToEdit != null ? 'Zapisz zmiany' : 'Zapisz produkt', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}