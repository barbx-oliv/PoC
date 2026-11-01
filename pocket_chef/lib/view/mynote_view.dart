import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/recipe_controller.dart';
import 'package:pocket_chef/model/recipe_model.dart';
import 'package:pocket_chef/view/recipe_view.dart';

class MyNotebookView extends StatelessWidget {
  const MyNotebookView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryRed = Color(0xFFc32f27);
    final Color warmOrange = Color(0xFFd8572a);
    final Color darkRed = Color(0xFF780116);

    final authController = Provider.of<AuthController>(context);
    final recipeController = Provider.of<RecipeController>(context);
    final user = authController.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Usuário não autenticado.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meu Caderno de Receitas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryRed,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<List<RecipeModel>>(
        stream: recipeController.getSavedRecipesStream(user.uid),
        builder: (context, snapshot) {
          // Tratando estados do Stream
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primaryRed));
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar o caderno: ${snapshot.error}'),
            );
          }

          final savedRecipes = snapshot.data ?? [];

          if (savedRecipes.isEmpty) {
            return const Center(
              child: Text(
                'Seu caderno ainda está vazio.\nSalve receitas da busca para vê-las aqui!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          // Exibindo a lista de receitas salvas do Firestore
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: savedRecipes.length,
            itemBuilder: (context, index) {
              final recipe = savedRecipes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      recipe.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 60),
                    ),
                  ),
                  title: Text(
                    recipe.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: darkRed,
                    ),
                  ),
                  subtitle: const Text('Toque para abrir a receita'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Remove a receita do Firestore
                      recipeController.removeRecipe(user.uid, recipe.idApi);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${recipe.title} removida do caderno.'),
                          backgroundColor: warmOrange,
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    // Abre os detalhes da receita salva
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailView(recipe: recipe),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}