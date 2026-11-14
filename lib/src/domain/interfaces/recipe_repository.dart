import '../entities/recipe.dart';

// Абстракція сховища. Домен описує, ЩО потрібно, а як саме зберігати — вирішує Infrastructure
abstract interface class RecipeRepository {
  List<Recipe> getAll();

  Recipe? getById(String id);

  // Додає новий рецепт або замінює існуючий з тим самим id
  void save(Recipe recipe);
}
