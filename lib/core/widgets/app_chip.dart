import 'package:flutter/material.dart';

class AppChip extends StatelessWidget {
  const AppChip({super.key, required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Chip(
      avatar: icon == null ? null : Icon(icon, size: 18),
      label: Text(label),
      backgroundColor: colorScheme.secondaryContainer,
      labelStyle: Theme.of(context)
          .textTheme
          .labelLarge
          ?.copyWith(color: colorScheme.onSecondaryContainer),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
