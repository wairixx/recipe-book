import '../../domain/entities/recipe.dart';
import '../../domain/errors/domain_exception.dart';
import '../../domain/interfaces/recipe_repository.dart';

// Додати рецепт в обране або прибрати з нього
class ToggleFavoriteUseCase {
  final RecipeRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  Recipe call(String recipeId) {
    final recipe = _repository.getById(recipeId);
    if (recipe == null) {
      throw const DomainException('Рецепт не знайдено');
    }
    final updated = recipe.copyWith(isFavorite: !recipe.isFavorite);
    _repository.save(updated);
    return updated;
  }
}
