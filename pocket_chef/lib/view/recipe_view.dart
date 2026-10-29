import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pocket_chef/model/recipe_model.dart';
import '../controllers/auth_controller.dart';
import '../controllers/recipe_controller.dart';

class RecipeDetailView extends StatelessWidget {
  final RecipeModel recipe;

  const RecipeDetailView({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    // Cores da nossa paleta personalizada
    final Color primaryRed = Color(0xFFc32f27);
    final Color warmOrange = Color(0xFFd8572a);
    final Color darkRed = Color(0xFF780116);

    final authController = Provider.of<AuthController>(context);
    final recipeController = Provider.of<RecipeController>(context);
    final user = authController.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipe.title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryRed,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem Grande da Receita
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                recipe.image,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 220,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.broken_image, size: 60)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Título
            Text(
              recipe.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: darkRed,
              ),
            ),
            const SizedBox(height: 20),

            // Seção de Ingredientes (Listando os dados complexos/arrays)
            const Text(
              'Ingredientes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...recipe.ingredients.map((ingredient) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.fiber_manual_record, size: 10, color: warmOrange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          ingredient,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 24),

            // Seção de Modo de Preparo
            const Text(
              'Modo de Preparo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...recipe.instructions.map((step) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text(
                    step,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),
                )),
            const SizedBox(height: 32),

            // Botão para Salvar no Caderno Pessoal
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (user != null) {
                    recipeController.saveRecipe(user.uid, recipe);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${recipe.title} salva no seu caderno!'),
                        backgroundColor: warmOrange,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Salvar no Meu Caderno',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}