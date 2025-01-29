// lib/models/meal.dart
class Meal {
  final String id;
  final String name;
  final String category;
  final String instructions;
  final String thumbnail;

  Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.instructions,
    required this.thumbnail,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      category: json['strCategory'] as String,
      instructions: json['strInstructions'] as String,
      thumbnail: json['strMealThumb'] as String,
    );
  }
}
