import '../../domain/entities/recipe.dart';
import '../../domain/interfaces/recipe_repository.dart';

// Список рецептів за абеткою, за потреби тільки обрані
class ListRecipesUseCase {
  final RecipeRepository _repository;

  ListRecipesUseCase(this._repository);

  List<Recipe> call({bool onlyFavorites = false}) {
    final recipes = _repository
        .getAll()
        .where((r) => !onlyFavorites || r.isFavorite)
        .toList();
    recipes.sort((a, b) => a.title.compareTo(b.title));
    return recipes;
  }
}
