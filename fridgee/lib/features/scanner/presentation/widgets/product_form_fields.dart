import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../inventory/domain/product_item.dart';

// 1. Sekcja: Nazwa, Kategoria, Kod Kreskowy
class ProductBasicInfoFields extends StatelessWidget {
  final TextEditingController nameController;
  final String selectedType;
  final ValueChanged<String?> onTypeChanged;
  final TextEditingController barcodeController;
  final VoidCallback onBarcodeScannerTapped;

  const ProductBasicInfoFields({
    super.key, required this.nameController, required this.selectedType, 
    required this.onTypeChanged, required this.barcodeController, required this.onBarcodeScannerTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
          style: TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(labelText: 'Nazwa produktu *', prefixIcon: Icon(Icons.shopping_bag_outlined)),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Wpisz nazwę produktu' : null,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: selectedType,
          decoration: const InputDecoration(labelText: 'Rodzaj produktu *', prefixIcon: Icon(Icons.category_outlined)),
          dropdownColor: AppColors.surfaceElevated,
          items: const [
            DropdownMenuItem(value: 'warzywa', child: Text('Warzywa 🥦')),
            DropdownMenuItem(value: 'owoce', child: Text('Owoce 🍎')),
            DropdownMenuItem(value: 'pieczywo', child: Text('Pieczywo 🥖')),
            DropdownMenuItem(value: 'nabiał', child: Text('Nabiał / Mleko 🥛')),
            DropdownMenuItem(value: 'mięso', child: Text('Mięso / Ryby 🥩')),
            DropdownMenuItem(value: 'napoje', child: Text('Napoje 🧃')),
            DropdownMenuItem(value: 'inne', child: Text('Inne zapasy 🥫')),
          ],
          onChanged: onTypeChanged,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: barcodeController,
          style: TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            labelText: 'Kod kreskowy', 
            prefixIcon: const Icon(Icons.pin_outlined),
            suffixIcon: IconButton(
              icon: const Icon(Icons.qr_code_scanner, color: AppColors.primary),
              onPressed: onBarcodeScannerTapped,
            ),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}

// 2. Sekcja: Ilość i Jednostka
class ProductQuantityFields extends StatelessWidget {
  final TextEditingController quantityController;
  final StorageUnit selectedUnit;
  final ValueChanged<StorageUnit?> onUnitChanged;

  const ProductQuantityFields({
    super.key, required this.quantityController, required this.selectedUnit, required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: quantityController,
            style: TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(labelText: 'Ilość', prefixIcon: Icon(Icons.scale_outlined)),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<StorageUnit>(
            initialValue: selectedUnit,
            decoration: const InputDecoration(labelText: 'Jednostka'),
            dropdownColor: AppColors.surfaceElevated,
            items: StorageUnit.values.map((u) => DropdownMenuItem(value: u, child: Text(u.name))).toList(),
            onChanged: onUnitChanged,
          ),
        ),
      ],
    );
  }
}

// 3. Sekcja: Magazyn, Data i Otwarcie
class ProductStorageFields extends StatelessWidget {
  final List<Map<String, dynamic>> currentStorageObjects;
  final String? selectedStorageObjectId;
  final ValueChanged<String?> onStorageChanged;
  final DateTime selectedDate;
  final VoidCallback onDatePickerTapped;
  final VoidCallback onOcrScannerTapped;
  final bool isOpened;
  final ValueChanged<bool> onIsOpenedChanged;

  const ProductStorageFields({
    super.key, required this.currentStorageObjects, required this.selectedStorageObjectId,
    required this.onStorageChanged, required this.selectedDate, required this.onDatePickerTapped,
    required this.onOcrScannerTapped, required this.isOpened, required this.onIsOpenedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        currentStorageObjects.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('⚠️ Brak stref. Dodaj miejsce w Magazynie!', style: TextStyle(color: AppColors.warning, fontSize: 13, fontWeight: FontWeight.bold)),
              )
            : DropdownButtonFormField<String>(
                initialValue: currentStorageObjects.any((o) => o['id'] == selectedStorageObjectId)
                    ? selectedStorageObjectId : currentStorageObjects.first['id'] as String,
                decoration: const InputDecoration(labelText: 'Gdzie to schowasz? *', prefixIcon: Icon(Icons.kitchen_outlined)),
                dropdownColor: AppColors.surfaceElevated,
                items: currentStorageObjects.map((obj) => DropdownMenuItem<String>(value: obj['id'] as String, child: Text('${obj['name']} ${obj['emoji']}'))).toList(),
                onChanged: onStorageChanged,
              ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onDatePickerTapped,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppTheme.radiusMedium, border: Border.all(color: AppColors.border)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Text(DateFormat('dd.MM.yyyy').format(selectedDate), style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(color: AppColors.surfaceElevated, borderRadius: AppTheme.radiusMedium, border: Border.all(color: AppColors.warning.withValues(alpha: 0.5))),
              child: IconButton(
                icon: const Icon(Icons.document_scanner_outlined, color: AppColors.warning),
                tooltip: 'Skanuj datę ważności (OCR)',
                onPressed: onOcrScannerTapped,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          title: Text('Produkt został otwarty', style: TextStyle(fontSize: 14, color: AppColors.textPrimary)),
          secondary: const Icon(Icons.lock_open_outlined, color: AppColors.primary),
          value: isOpened,
          onChanged: onIsOpenedChanged,
        ),
      ],
    );
  }
}