// Demo seed data used for first-run demo population.

final List<Map<String, dynamic>> demoPantryIngredients = [
  {
    'name': 'All-purpose flour',
    'category': 'Baking',
    'quantity': 2.0,
    'unit': 'kg',
    'expiration': DateTime.parse('2026-12-31'),
  },
  {
    'name': 'Brown rice',
    'category': 'Grains',
    'quantity': 1.5,
    'unit': 'kg',
    'expiration': DateTime.parse('2027-03-15'),
  },
  {
    'name': 'Large eggs',
    'category': 'Dairy',
    'quantity': 12,
    'unit': 'pcs',
    'expiration': DateTime.parse('2026-07-10'),
  },
  {
    'name': 'Whole milk',
    'category': 'Dairy',
    'quantity': 1.0,
    'unit': 'L',
    'expiration': DateTime.parse('2026-06-30'),
  },
  {
    'name': 'Chicken breast',
    'category': 'Meat',
    'quantity': 1.2,
    'unit': 'kg',
    'expiration': DateTime.parse('2026-07-04'),
  },
  {
    'name': 'Olive oil',
    'category': 'Oil',
    'quantity': 0.75,
    'unit': 'L',
    'expiration': DateTime.parse('2029-01-01'),
  },
  {
    'name': 'Garlic',
    'category': 'Produce',
    'quantity': 0.3,
    'unit': 'kg',
    'expiration': DateTime.parse('2026-08-01'),
  },
  {
    'name': 'Canned tomatoes',
    'category': 'Canned Goods',
    'quantity': 6,
    'unit': 'cans',
    'expiration': DateTime.parse('2028-05-01'),
  },
];

final List<Map<String, dynamic>> demoRecipes = [
  {
    'title': 'Classic Tomato Pasta',
    'description': 'Simple and comforting pasta with tomato sauce and garlic.',
    'prepTime': 10,
    'cookTime': 20,
    'macros': {'calories': 520, 'protein': 12, 'fat': 14, 'carbs': 78},
    'difficulty': 'Easy',
    'ingredients': [
      {'name': 'Pasta', 'quantity': 300, 'unit': 'g'},
      {'name': 'Canned tomatoes', 'quantity': 2, 'unit': 'cans'},
      {'name': 'Garlic', 'quantity': 3, 'unit': 'cloves'},
      {'name': 'Olive oil', 'quantity': 2, 'unit': 'tbsp'},
    ],
    'instructions': [
      'Boil pasta until al dente.',
      'Sauté garlic in olive oil, add tomatoes and simmer.',
      'Mix pasta with sauce and serve.'
    ],
    'cuisine': 'Italian',
    'tags': ['easy', 'vegetarian', 'quick'],
  },
  {
    'title': 'Chicken Stir-fry',
    'description': 'Quick stir-fry with vegetables and soy-ginger sauce.',
    'prepTime': 15,
    'cookTime': 12,
    'macros': {'calories': 450, 'protein': 35, 'fat': 18, 'carbs': 32},
    'difficulty': 'Medium',
    'ingredients': [
      {'name': 'Chicken breast', 'quantity': 400, 'unit': 'g'},
      {'name': 'Garlic', 'quantity': 2, 'unit': 'cloves'},
      {'name': 'Vegetable mix', 'quantity': 300, 'unit': 'g'},
      {'name': 'Olive oil', 'quantity': 1, 'unit': 'tbsp'},
    ],
    'instructions': [
      'Slice chicken and vegetables.',
      'Stir-fry chicken until cooked, remove.',
      'Stir-fry vegetables, add chicken back with sauce, serve.'
    ],
    'cuisine': 'Asian',
    'tags': ['protein', 'stir-fry'],
  },
  {
    'title': 'Oat Pancakes',
    'description': 'Healthy pancakes made with oats and bananas.',
    'prepTime': 10,
    'cookTime': 10,
    'macros': {'calories': 320, 'protein': 8, 'fat': 6, 'carbs': 58},
    'difficulty': 'Easy',
    'ingredients': [
      {'name': 'All-purpose flour', 'quantity': 150, 'unit': 'g'},
      {'name': 'Large eggs', 'quantity': 2, 'unit': 'pcs'},
      {'name': 'Milk', 'quantity': 200, 'unit': 'ml'},
      {'name': 'Banana', 'quantity': 1, 'unit': 'pcs'},
    ],
    'instructions': [
      'Mix dry and wet ingredients into a batter.',
      'Cook small pancakes on a griddle until golden.',
      'Serve with fruit or syrup.'
    ],
    'cuisine': 'International',
    'tags': ['breakfast', 'vegetarian'],
  },
];

final List<Map<String, dynamic>> demoShoppingItems = [
  {
    'name': 'Spaghetti pasta',
    'quantity': 1,
    'unit': 'pack',
    'note': 'For tomato pasta recipe',
  },
  {
    'name': 'Fresh broccoli',
    'quantity': 2,
    'unit': 'heads',
    'note': 'For stir-fry and sides',
  },
];
