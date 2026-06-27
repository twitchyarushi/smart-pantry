import 'package:flutter/material.dart';

enum AppButtonVariant { filled, outlined, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.variant = AppButtonVariant.filled,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final AppButtonVariant variant;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final progress = SizedBox.square(
      dimension: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: variant == AppButtonVariant.filled
            ? Theme.of(context).colorScheme.onPrimary
            : null,
      ),
    );
    final labelWidget = isLoading ? progress : Text(label);

    final button = switch (variant) {
      AppButtonVariant.filled => icon == null
          ? FilledButton(onPressed: isLoading ? null : onPressed, child: labelWidget)
          : FilledButton.icon(
              onPressed: isLoading ? null : onPressed,
              icon: Icon(icon),
              label: labelWidget,
            ),
      AppButtonVariant.outlined => icon == null
          ? OutlinedButton(onPressed: isLoading ? null : onPressed, child: labelWidget)
          : OutlinedButton.icon(
              onPressed: isLoading ? null : onPressed,
              icon: Icon(icon),
              label: labelWidget,
            ),
      AppButtonVariant.text => icon == null
          ? TextButton(onPressed: isLoading ? null : onPressed, child: labelWidget)
          : TextButton.icon(
              onPressed: isLoading ? null : onPressed,
              icon: Icon(icon),
              label: labelWidget,
            ),
    };

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
