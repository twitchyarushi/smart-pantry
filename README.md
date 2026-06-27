# Smart Pantry

Smart Pantry is a Flutter app prototype that helps users track pantry inventory, save recipes, and manage shopping lists. It is demo-ready with bundled seed data for judges.

## Tech stack
- Flutter / Dart 3
- Riverpod for state management
- GoRouter for navigation
- Firebase Auth and Cloud Firestore
- flutter_dotenv for environment secrets
- image_picker and image_cropper for pantry image capture
- shimmer and intl for UI polish and formatting

## Setup
1. Install Flutter and ensure the Flutter SDK is on your PATH.
2. From the project root run:

```bash
flutter pub get
```

3. Firebase Android and web options are present. For new Firebase projects or additional platforms, run:

```bash
flutterfire configure
```

4. Create a `.env` file in the project root:

```env
GEMINI_API_KEY=your_key_here
```

5. Regenerate model code after changing Freezed/JSON models:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Demo mode
On first launch, the app seeds demo pantry, recipe, and shopping data from `lib/core/constants/seed_data.dart`. Recipe generation falls back to bundled demo recipes if Gemini is unavailable.

## Known limitations
- Gemini calls still need a real production endpoint/key for live AI generation.
- Firebase options are configured for Android and web; run `flutterfire configure` for other platforms.
