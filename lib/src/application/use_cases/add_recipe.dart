import '../../domain/entities/ingredient.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/errors/domain_exception.dart';
import '../../domain/interfaces/recipe_repository.dart';

// Додавання нового рецепта. Працює тільки з інтерфейсом RecipeRepository
class AddRecipeUseCase {
  final RecipeRepository _repository;

  AddRecipeUseCase(this._repository);

  Recipe call({
    required String title,
    required int servings,
    required List<Ingredient> ingredients,
  }) {
    final duplicate = _repository
        .getAll()
        .any((r) => r.title.toLowerCase() == title.trim().toLowerCase());
    if (duplicate) {
      throw DomainException('Рецепт «${title.trim()}» вже є в книзі');
    }

    final recipe = Recipe(
      id: _makeId(title),
      title: title.trim(),
      servings: servings,
      ingredients: ingredients,
    );
    _repository.save(recipe);
    return recipe;
  }

  // Простий id з часу створення, щоб не залежати від сховища
  String _makeId(String title) => '${DateTime.now().microsecondsSinceEpoch}';
}
