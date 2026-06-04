// Hub skanera — główne skanowanie (AI + OCR) lub sam kod kreskowy.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../domain/live_scan_result.dart';
import 'add_product_sheet.dart';
import 'barcode_only_scanner.dart';
import 'hybrid_live_scanner.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  Future<void> _openHybridScanner(BuildContext context) async {
    final map = await Navigator.of(context, rootNavigator: true).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => const HybridLiveScannerPage()),
    );

    if (map != null && context.mounted) {
      final result = LiveScanResult.fromMap(map);
      await Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => AddProductPage(
            initialBarcode: result.barcode,
            initialProductName: result.productName,
            initialExpiryDate: result.expiryDate,
          ),
        ),
      );
    }
  }

  Future<void> _openBarcodeScanner(BuildContext context) async {
    final map = await Navigator.of(context, rootNavigator: true).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => const BarcodeOnlyScannerPage()),
    );

    if (map != null && context.mounted) {
      final barcode = map['barcode'] as String?;
      if (barcode == null) return;
      await Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => AddProductPage(initialBarcode: barcode),
        ),
      );
    }
  }

  void _openAddProduct(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (_) => const AddProductPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Skaner', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Skanuj kody kreskowe, świeże produkty lub etykiety',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textTertiary),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => _openHybridScanner(context),
                        child: Container(
                          width: 260,
                          height: 200,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: AppTheme.radiusLarge,
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.5), width: 2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.bolt, color: AppColors.primary, size: 64),
                              const SizedBox(height: 12),
                              const Text(
                                'Główne skanowanie',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Kod + AI + data ważności',
                                style: TextStyle(color: AppColors.textTertiary, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _openBarcodeScanner(context),
                        child: Container(
                          width: 260,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: AppTheme.radiusLarge,
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.qr_code_scanner, color: AppColors.primary, size: 48),
                              const SizedBox(height: 8),
                              Text(
                                'Tylko kod kreskowy',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton.icon(
                        onPressed: () => _openAddProduct(context),
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Dodaj ręcznie lub z OCR zdjęcia'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(260, 48),
                          side: BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.3)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
