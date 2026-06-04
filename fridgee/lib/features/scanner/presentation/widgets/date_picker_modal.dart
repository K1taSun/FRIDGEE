import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePickerModal {
  static void show({
    required BuildContext context,
    required DateTime initialDate,
    required ValueChanged<DateTime> onDateTimeChanged,
    required VoidCallback onDone,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    //final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final sheetScheme = Theme.of(sheetContext).colorScheme;
        final sheetTextTheme = Theme.of(sheetContext).textTheme;
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      child: Text(
                        'Anuluj',
                        style: sheetTextTheme.labelLarge?.copyWith(
                          color: sheetScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Text(
                      'Ustaw Datę',
                      style: sheetTextTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: sheetScheme.onSurface,
                      ),
                    ),
                    TextButton(
                      onPressed: onDone,
                      child: Text(
                        'Gotowe',
                        style: sheetTextTheme.labelLarge?.copyWith(
                          color: sheetScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: sheetScheme.outline),
              Expanded(
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    brightness: Theme.of(sheetContext).brightness,
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: sheetTextTheme.titleMedium?.copyWith(
                        color: sheetScheme.onSurface,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    initialDateTime: initialDate,
                    mode: CupertinoDatePickerMode.date,
                    use24hFormat: true,
                    onDateTimeChanged: onDateTimeChanged,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}