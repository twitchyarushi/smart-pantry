# Data Models

This document lists the data models used by the app and their fields.

**Ingredient**

Pantry ingredient used for inventory and expiry tracking.

- name: String — ingredient name
- category: String — category (e.g., Dairy, Grains)
- quantity: num — amount available
- unit: String — unit of measure (e.g., kg, pcs)
- expiration: DateTime — expiration date

**Recipe**

Full recipe model used for saved recipes and generation.

- title: String — recipe title
- description: String — short description
- prepTime: int — minutes to prepare
- cookTime: int — minutes to cook
- macros: Map<String,num> — nutrition values (calories, protein, fat, carbs)
- difficulty: String — difficulty label (Easy/Medium/Hard)
- ingredients: List<Map<String,dynamic>> — list of ingredient entries (name, quantity, unit)
- instructions: List<String> — ordered instruction steps
- cuisine: String — cuisine tag
- tags: List<String> — additional tags

**ShoppingItem**

Item for shopping lists.

- name: String — item name
- quantity: num — desired quantity
- unit: String — unit of measure
- note: String? — optional note

**User (AppUser)**

Authenticated user record.

- id: String — user id
- displayName: String? — display name
- email: String? — email address
- photoUrl: String? — profile photo URL

**Preferences**

User preferences stored locally or in Firestore.

- locale: String? — locale code
- darkMode: bool? — preferred theme mode
- defaultUnits: String? — preferred measurement units (metric/imperial)

