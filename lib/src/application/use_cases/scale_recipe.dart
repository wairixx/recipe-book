import '../../domain/entities/ingredient.dart';
import '../../domain/errors/domain_exception.dart';
import '../../domain/interfaces/recipe_repository.dart';

// Перерахунок інгредієнтів рецепта на потрібну кількість порцій
class ScaleRecipeUseCase {
  final RecipeRepository _repository;

  ScaleRecipeUseCase(this._repository);

  List<Ingredient> call(String recipeId, int servings) {
    final recipe = _repository.getById(recipeId);
    if (recipe == null) {
      throw const DomainException('Рецепт не знайдено');
    }
    return recipe.ingredientsFor(servings);
  }
}
