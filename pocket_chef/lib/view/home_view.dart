import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/recipe_controller.dart';
import 'login_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Cores da nossa paleta personalizada
    final Color primaryRed = Color(0xFFc32f27);
    final Color warmOrange = Color(0xFFd8572a);
    final Color darkRed = Color(0xFF780116);
    final Color lightYellow = Color(0xFFf7b538);

    final recipeController = Provider.of<RecipeController>(context);
    final authController = Provider.of<AuthController>(context);
    final user = authController.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pocket Chef',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryRed,
        actions: [
          // Botão para deslogar
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await authController.logout();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barra de Pesquisa
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar receita (ex: Pizza, Pasta...)',
                prefixIcon: Icon(Icons.search, color: warmOrange),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: primaryRed),
                  onPressed: () {
                    if (_searchController.text.trim().isNotEmpty) {
                      recipeController.searchRecipes(_searchController.text.trim());
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: warmOrange, width: 2),
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  recipeController.searchRecipes(value.trim());
                }
              },
            ),
            const SizedBox(height: 20),

            // Exibição do Conteúdo (Carregando, Vazio ou Lista)
            Expanded(
              child: recipeController.isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: primaryRed),
                    )
                  : recipeController.searchResults.isEmpty
                      ? const Center(
                          child: Text(
                            'Nenhuma receita buscada ainda.\nDigite algo acima para comecar!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: recipeController.searchResults.length,
                          itemBuilder: (context, index) {
                            final recipe = recipeController.searchResults[index];
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
                                  image: NetworkImage(recipe.image),
                                  // Tratamento básico caso a imagem demore ou falhe
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
                                subtitle: const Text('Toque para ver os detalhes'),
                                trailing: IconButton(
                                  icon: Icon(Icons.favorite_border, color: warmOrange),
                                  onPressed: () {
                                    if (user != null) {
                                      recipeController.saveRecipe(user.uid, recipe);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('${recipe.title} salva no caderno!'),
                                          backgroundColor: warmOrange,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}