import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_pantry/core/services/gemini_service.dart';
import 'package:smart_pantry/core/widgets/widgets.dart';
import 'package:smart_pantry/features/pantry/data/models/ingredient.dart';
import 'package:smart_pantry/features/pantry/presentation/providers/pantry_providers.dart';

enum _ScannerStep { capture, analyzing, confirm }

class _IdentifiedIngredient {
  _IdentifiedIngredient({
    required String name,
    required String quantity,
    required String unit,
    required this.category,
  })  : nameController = TextEditingController(text: name),
        quantityController = TextEditingController(text: quantity),
        unitController = TextEditingController(text: unit);

  final TextEditingController nameController;
  final TextEditingController quantityController;
  final TextEditingController unitController;
  final String category;

  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    unitController.dispose();
  }
}

class PantryScannerScreen extends ConsumerStatefulWidget {
  const PantryScannerScreen({super.key});

  @override
  ConsumerState<PantryScannerScreen> createState() => _PantryScannerScreenState();
}

class _PantryScannerScreenState extends ConsumerState<PantryScannerScreen> {
  final ImagePicker _picker = ImagePicker();

  _ScannerStep _step = _ScannerStep.capture;
  File? _imageFile;
  bool _isSaving = false;
  String? _errorMessage;
  List<_IdentifiedIngredient> _ingredients = [];

  void _disposeIngredients() {
    for (final item in _ingredients) {
      item.dispose();
    }
    _ingredients = [];
  }

  @override
  void dispose() {
    _disposeIngredients();
    super.dispose();
  }

  Future<void> _pickImage({required ImageSource source}) async {
    final picked = await _picker.pickImage(source: source);
    if (picked == null) return;

    setState(() {
      _imageFile = File(picked.path);
      _step = _ScannerStep.analyzing;
      _errorMessage = null;
      _disposeIngredients();
    });

    await _analyzeImage();
  }

  Future<void> _analyzeImage() async {
    if (_imageFile == null) return;

    try {
      final bytes = await _imageFile!.readAsBytes();
      final base64Image = base64Encode(bytes);
      final response = await GeminiService().identifyIngredientsFromBase64(base64Image);
      final rawIngredients = response['ingredients'];

      if (rawIngredients is! List || rawIngredients.isEmpty) {
        throw StateError('No ingredients were identified in this image');
      }

      final parsed = rawIngredients
          .whereType<Map>()
          .map(
            (item) => _IdentifiedIngredient(
              name: item['name']?.toString() ?? '',
              quantity: item['quantity']?.toString() ?? '1',
              unit: item['unit']?.toString() ?? 'piece',
              category: item['category']?.toString() ?? 'Other',
            ),
          )
          .where((item) => item.nameController.text.trim().isNotEmpty)
          .toList();

      if (parsed.isEmpty) {
        throw StateError('No valid ingredients were identified in this image');
      }

      if (!mounted) return;
      setState(() {
        _disposeIngredients();
        _ingredients = parsed;
        _step = _ScannerStep.confirm;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _step = _ScannerStep.capture;
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _addToPantry() async {
    if (_ingredients.isEmpty) {
      setState(() => _errorMessage = 'No ingredients to save');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final saveUseCase = ref.read(saveIngredientUseCaseProvider);
      final defaultExpiration = DateTime.now().add(const Duration(days: 7));

      for (final item in _ingredients) {
        final quantity = num.tryParse(item.quantityController.text.trim()) ?? 1;
        await saveUseCase.call(
          Ingredient(
            name: item.nameController.text.trim(),
            category: item.category.trim().isEmpty ? 'Other' : item.category.trim(),
            quantity: quantity,
            unit: item.unitController.text.trim().isEmpty ? 'piece' : item.unitController.text.trim(),
            expiration: defaultExpiration,
          ),
        );
      }

      if (!mounted) return;
      context.go('/pantry');
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = error.toString());
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _retakePhoto() {
    setState(() {
      _step = _ScannerStep.capture;
      _imageFile = null;
      _disposeIngredients();
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_step == _ScannerStep.confirm ? 'Confirm Ingredients' : 'Pantry Scanner'),
        leading: _step == _ScannerStep.confirm
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _isSaving ? null : _retakePhoto,
              )
            : null,
      ),
      body: SafeArea(
        child: switch (_step) {
          _ScannerStep.capture => _buildCaptureStep(context),
          _ScannerStep.analyzing => _buildAnalyzingStep(context),
          _ScannerStep.confirm => _buildConfirmStep(context),
        },
      ),
    );
  }

  Widget _buildCaptureStep(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: AppCard(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(8),
              child: _imageFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _imageFile!,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    )
                  : const EmptyStateView(
                      message: 'Take or choose a photo of your ingredients',
                      icon: Icons.camera_alt_outlined,
                    ),
            ),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            _ErrorBanner(message: _errorMessage!),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Camera',
                  onPressed: () => _pickImage(source: ImageSource.camera),
                  icon: Icons.camera_alt,
                  variant: AppButtonVariant.outlined,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(
                  label: 'Gallery',
                  onPressed: () => _pickImage(source: ImageSource.gallery),
                  icon: Icons.photo_library,
                  variant: AppButtonVariant.outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Gemini will identify ingredients from your photo',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzingStep(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: AppCard(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(8),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_imageFile != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _imageFile!,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            'Analyzing ingredients...',
                            style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmStep(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        if (_imageFile != null)
          SizedBox(
            height: 160,
            width: double.infinity,
            child: AppCard(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_imageFile!, fit: BoxFit.cover, width: double.infinity),
              ),
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _ingredients.length,
            itemBuilder: (context, index) {
              final item = _ingredients[index];
              return AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ingredient ${index + 1}', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      controller: item.nameController,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Quantity',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            controller: item.quantityController,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Unit',
                              border: OutlineInputBorder(),
                            ),
                            controller: item.unitController,
                          ),
                        ),
                      ],
                    ),
                    if (item.category.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        item.category,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _ErrorBanner(message: _errorMessage!),
          ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: AppButton(
            label: 'Add to Pantry',
            onPressed: _addToPantry,
            icon: Icons.add_shopping_cart,
            isLoading: _isSaving,
            expand: true,
          ),
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.onErrorContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
