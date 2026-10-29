class RecipeModel {
  final String idApi;
  final String title;
  final String image;
  final List<String> ingredients;
  final List<String> instructions;

  RecipeModel({
    required this.idApi,
    required this.title,
    required this.image,
    required this.ingredients,
    required this.instructions,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {

    List<String> extractedIngredients = [];
    for (int i = 1; i <= 20; i++) {
      String? ingredient = json['strIngredient$i'];
      String? measure = json['strMeasure$i'];
      
      if (ingredient != null && ingredient.trim().isNotEmpty) {
        extractedIngredients.add('$measure - $ingredient');
      }
    }

    String rawInstructions = json['strInstructions'] ?? '';
    List<String> extractedInstructions = rawInstructions
        .split(RegExp(r'\r?\n'))
        .where((step) => step.trim().isNotEmpty)
        .toList();

    return RecipeModel(
      idApi: json['idMeal'] ?? '',
      title: json['strMeal'] ?? 'Sem Título',
      image: json['strMealThumb'] ?? '',
      ingredients: extractedIngredients,
      instructions: extractedInstructions,
    );
  }

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      idApi: map['idApi'] ?? '',
      title: map['title'] ?? '',
      image: map['image'] ?? '',
      ingredients: List<String>.from(map['ingredients'] ?? []),
      instructions: List<String>.from(map['instructions'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idApi': idApi,
      'title': title,
      'image': image,
      'ingredients': ingredients,   // Salvo como Array no Firestore
      'instructions': instructions, // Salvo como Array no Firestore
    };
  }
}