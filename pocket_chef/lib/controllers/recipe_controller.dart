import 'package:flutter/material.dart';
import 'package:pocket_chef/controllers/recipe_controller.dart';
import '../services/api_service.dart';
import '../services/firebase_service.dart';

class RecipeController extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<RecipeModel> searchResults = [];
  bool isLoading = false;
  String errorMessage = '';

  // Funcao para buscar receitas na API do TheMealDB
  Future<void> searchRecipes(String query) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      searchResults = await ApiService.searchRecipes(query);
    } catch (e) {
      errorMessage = e.toString();
      searchResults = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Funcao para salvar a receita no Firestore do usuario
  Future<void> saveRecipe(String userId, RecipeModel recipe) async {
    try {
      await _firebaseService.saveRecipe(userId, recipe);
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao salvar receita: $e');
    }
  }

  // Funcao para remover a receita do caderno do usuario
  Future<void> removeRecipe(String userId, String recipeId) async {
    try {
      await _firebaseService.removeRecipe(userId, recipeId);
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao remover receita: $e');
    }
  }

  // Stream para escutar as receitas salvas em tempo real
  Stream<List<RecipeModel>> getSavedRecipesStream(String userId) {
    return _firebaseService.getSavedRecipes(userId);
  }
}