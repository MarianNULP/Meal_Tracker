// lib/data/meal_api_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meal_tracker/models/meal.dart';

/// Репозиторій для завантаження рецептів з https://www.themealdb.com
class MealApiRepository {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  /// Пошук рецептів за назвою (якщо query = '', то повертає різні рецепти)
  Future<List<Meal>> searchMeals(String query) async {
    final uri = Uri.parse('$baseUrl/search.php?s=$query');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonData['meals'] == null) {
        // Нічого не знайдено
        return [];
      }
      final mealsList = jsonData['meals'] as List;
      return mealsList
          .map((mealJson) => Meal.fromJson(mealJson as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Помилка завантаження: ${response.statusCode}');
    }
  }

  /// Випадковий рецепт (повертає 1 страву або null)
  Future<Meal?> fetchRandomMeal() async {
    final uri = Uri.parse('$baseUrl/random.php');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final mealsList = data['meals'] as List?;
      if (mealsList != null && mealsList.isNotEmpty) {
        return Meal.fromJson(mealsList.first as Map<String, dynamic>);
      }
      return null;
    } else {
      throw Exception('Помилка завантаження випадкового рецепта');
    }
  }
}
