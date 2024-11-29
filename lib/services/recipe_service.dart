import 'dart:convert';
import 'package:http/http.dart' as http;

class RecipeService {
  final String apiKey = '3fc94d9307a54a5684f7436161176f55'; // Ваш API-ключ

  Future fetchRecipes(String query) async {
    final url = Uri.parse(
        'https://api.spoonacular.com/recipes/complexSearch?query=$query&apiKey=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results']; // Результати рецептів
    } else {
      throw Exception('Помилка завантаження рецептів');
    }
  }
}
