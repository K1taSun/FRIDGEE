// Dialog dodawania nowej strefy przechowywania.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/storage_provider.dart';

abstract final class AddStorageZoneDialog {
  static void show(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    var selectedType = 'lodówka';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.surfaceElevated,
              title: const Text('Nowe miejsce przechowywania'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    style: TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Nazwa obiektu (np. Lodówka główna)',
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedType,
                    dropdownColor: AppColors.surfaceElevated,
                    decoration: const InputDecoration(labelText: 'Rodzaj obiektu'),
                    items: const [
                      DropdownMenuItem(value: 'lodówka', child: Text('Lodówka ❄️')),
                      DropdownMenuItem(value: 'zamrażarka', child: Text('Zamrażarka 🧊')),
                      DropdownMenuItem(value: 'szafka', child: Text('Szafka kuchenna 🚪')),
                      DropdownMenuItem(value: 'spiżarnia', child: Text('Spiżarnia 📦')),
                    ],
                    onChanged: (val) {
                      if (val != null) setDialogState(() => selectedType = val);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Anuluj', style: TextStyle(color: AppColors.textSecondary)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final text = nameController.text.trim();
                    if (text.isEmpty) return;

                    final emoji = switch (selectedType) {
                      'lodówka' => '❄️',
                      'zamrażarka' => '🧊',
                      'spiżarnia' => '📦',
                      _ => '🚪',
                    };

                    ref.read(customStorageObjectsProvider.notifier).addZone(text, emoji, selectedType);
                    Navigator.pop(context);
                  },
                  child: const Text('Utwórz'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
