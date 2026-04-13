// Grid produktów "szybkiego startu" — kliknięcie dodaje do bazy.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../domain/product_item.dart';
import '../domain/product_provider.dart';

class QuickStartGrid extends ConsumerWidget {
  const QuickStartGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presets = QuickStartPreset.all;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemCount: presets.length,
      itemBuilder: (context, index) {
        return _QuickStartTile(preset: presets[index]);
      },
    );
  }
}

class _QuickStartTile extends ConsumerStatefulWidget {
  const _QuickStartTile({required this.preset});

  final QuickStartPreset preset;

  @override
  ConsumerState<_QuickStartTile> createState() => _QuickStartTileState();
}

class _QuickStartTileState extends ConsumerState<_QuickStartTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _added = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    if (_added) return;

    await _controller.forward();
    await _controller.reverse();

    await ref
        .read(inventoryNotifierProvider.notifier)
        .addFromPreset(widget.preset);

    if (mounted) {
      setState(() => _added = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.preset.emoji} ${widget.preset.name} dodany!'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: _onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: _added
                ? AppColors.primary.withValues(alpha: 0.15)
                : AppColors.surface,
            borderRadius: AppTheme.radiusMedium,
            border: Border.all(
              color: _added ? AppColors.primary : AppColors.border,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.preset.emoji,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(height: 6),
              Text(
                widget.preset.name,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _added
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (_added)
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 14,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
