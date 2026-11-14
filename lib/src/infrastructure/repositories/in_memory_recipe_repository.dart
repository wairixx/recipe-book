import '../../domain/entities/recipe.dart';
import '../../domain/interfaces/recipe_repository.dart';

// Сховище в памʼяті: дані живуть, поки працює програма
class InMemoryRecipeRepository implements RecipeRepository {
  final Map<String, Recipe> _items = {};

  @override
  List<Recipe> getAll() => _items.values.toList();

  @override
  Recipe? getById(String id) => _items[id];

  @override
  void save(Recipe recipe) => _items[recipe.id] = recipe;
}
