import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pocket_chef/model/recipe_model.dart';

class ApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1/';

  // Buscar receitas por nome
  static Future<List<RecipeModel>> searchRecipes(String query) async {
    try {
      final url = Uri.parse('${_baseUrl}search.php?s=$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List? meals = data['meals'];

        if (meals == null) return [];

        return meals.map((jsonRecipe) => RecipeModel.fromJson(jsonRecipe)).toList();
      } else {
        throw Exception('Erro ao carregar receitas da API');
      }
    } catch (e) {
      throw Exception('Erro de conexao: $e');
    }
  }
}