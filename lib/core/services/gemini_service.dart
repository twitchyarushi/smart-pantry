import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  GeminiService._();

  static final _instance = GeminiService._();
  factory GeminiService() => _instance;

  static const _model = 'gemini-2.0-flash';
  static const _ingredientPrompt =
      'Identify all food ingredients visible in this image. Return only JSON: {"ingredients": [{"name": "ingredient name", "quantity": 1, "unit": "piece", "category": "category name"}]}';

  String _getApiKey() {
    final key = dotenv.isInitialized ? dotenv.env['GEMINI_API_KEY'] : null;
    if (key == null || key.isEmpty) {
      throw StateError('Gemini needs configuration: add GEMINI_API_KEY to .env');
    }
    return key;
  }

  Uri _endpoint() {
    return Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=${_getApiKey()}',
    );
  }

  Future<Map<String, dynamic>> _generateContent(List<Map<String, dynamic>> parts) async {
    final resp = await http.post(
      _endpoint(),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {'parts': parts},
        ],
      }),
    );

    if (resp.statusCode != 200) {
      throw http.ClientException('Gemini request failed: ${resp.statusCode} ${resp.body}');
    }

    return jsonDecode(resp.body) as Map<String, dynamic>;
  }

  String _extractText(Map<String, dynamic> response) {
    final candidates = response['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) {
      throw StateError('Gemini returned no candidates');
    }

    final content = candidates.first['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List?;
    if (parts == null || parts.isEmpty) {
      throw StateError('Gemini returned no content parts');
    }

    final text = parts.first['text'];
    if (text is! String || text.trim().isEmpty) {
      throw StateError('Gemini returned empty text');
    }

    return text.trim();
  }

  Map<String, dynamic> _parseJsonFromText(String text) {
    var cleaned = text.trim();
    if (cleaned.startsWith('```')) {
      cleaned = cleaned.replaceFirst(RegExp(r'^```(?:json)?\s*'), '');
      cleaned = cleaned.replaceFirst(RegExp(r'\s*```$'), '');
    }

    return jsonDecode(cleaned) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> identifyIngredientsFromBase64(String base64Image) async {
    final response = await _generateContent([
      {'text': _ingredientPrompt},
      {
        'inline_data': {
          'mime_type': 'image/jpeg',
          'data': base64Image,
        },
      },
    ]);

    return _parseJsonFromText(_extractText(response));
  }

  Future<Map<String, dynamic>> identifyIngredientFromImage(Uri imageUrl) async {
    final file = File.fromUri(imageUrl);
    final bytes = await file.readAsBytes();
    return identifyIngredientsFromBase64(base64Encode(bytes));
  }

  Future<Map<String, dynamic>> generateRecipeSuggestions(List<String> ingredients) async {
    final prompt =
        'Given these pantry ingredients: ${ingredients.join(', ')}, suggest 3 recipes. Return only JSON: {"recipes": [{"title": "", "description": "", "prepTime": 10, "cookTime": 20, "difficulty": "Easy", "cuisine": "", "tags": [], "ingredients": [], "instructions": []}]}';

    final response = await _generateContent([
      {'text': prompt},
    ]);

    return _parseJsonFromText(_extractText(response));
  }
}
