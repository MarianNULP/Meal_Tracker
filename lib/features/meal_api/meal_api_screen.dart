// lib/features/meal_api/meal_api_screen.dart
import 'package:flutter/material.dart';
import 'package:meal_tracker/data/meal_api_repository.dart';
import 'package:meal_tracker/models/meal.dart';

/// Екран, який відображає список рецептів з TheMealDB.
/// За замовчуванням робить пошук за порожнім query, щоб отримати "випадкові" страви.
class MealApiScreen extends StatefulWidget {
  const MealApiScreen({super.key});

  @override
  State<MealApiScreen> createState() => _MealApiScreenState();
}

class _MealApiScreenState extends State<MealApiScreen> {
  final MealApiRepository _repository = MealApiRepository();

  // Можеш задати query = '' для "випадкового" списку
  // або введення поля пошуку, але тут - статично
  String query = '';

  late Future<List<Meal>> _futureMeals;

  @override
  void initState() {
    super.initState();
    _futureMeals = _repository.searchMeals(query);
  }

  // Якщо хочеш додати пошук:
  // _futureMeals = _repository.searchMeals(userInput);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TheMealDB Recipes'),
      ),
      body: FutureBuilder<List<Meal>>(
        future: _futureMeals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Показуємо індикатор завантаження
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Якщо помилка
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Якщо дані порожні
            return const Center(child: Text('No meals found.'));
          } else {
            // Є дані
            final meals = snapshot.data!;
            return ListView.builder(
              itemCount: meals.length,
              itemBuilder: (ctx, index) {
                final meal = meals[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        meal.thumbnail,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      meal.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(meal.category),
                    onTap: () {
                      // Тут можна показати деталі
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(meal.name),
                          content: SingleChildScrollView(
                            child: Text(meal.instructions),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
