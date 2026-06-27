# Architecture

- Added a GoRouter-based app shell with auth redirect behavior and feature routes for auth, dashboard, pantry, recipes, shopping, and profile.
- Screens are wired to Riverpod providers generated from the existing domain use cases and repositories.
- Pantry scanning is connected to the camera/crop flow and the pantry repository save path, and recipe generation is connected to the recipe repository generation path.

