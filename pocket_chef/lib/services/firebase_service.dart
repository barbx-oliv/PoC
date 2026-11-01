import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocket_chef/model/recipe_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Salvar receita na subcoleção do usuário
  Future<void> saveRecipe(String userId, RecipeModel recipe) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('savedRecipes')
        .doc(recipe.idApi)
        .set(recipe.toMap());
  }

  // Remover receita da subcoleção do usuário
  Future<void> removeRecipe(String userId, String recipeId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('savedRecipes')
        .doc(recipeId)
        .delete();
  }

  // Stream para escutar as receitas em tempo real
  Stream<List<RecipeModel>> getSavedRecipes(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('savedRecipes')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RecipeModel.fromMap(doc.data()))
            .toList());
  }
}