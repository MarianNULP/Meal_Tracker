// lib/models/recipe_model.dart
class Recipe {
  final int id;
  final String title;
  final String description;

  const Recipe({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
}
