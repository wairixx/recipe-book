import 'package:recipe_book/src/application/use_cases/add_recipe.dart';
import 'package:recipe_book/src/application/use_cases/list_recipes.dart';
import 'package:recipe_book/src/application/use_cases/scale_recipe.dart';
import 'package:recipe_book/src/application/use_cases/toggle_favorite.dart';
import 'package:recipe_book/src/domain/entities/ingredient.dart';
import 'package:recipe_book/src/domain/entities/recipe.dart';
import 'package:recipe_book/src/domain/errors/domain_exception.dart';
import 'package:recipe_book/src/domain/interfaces/recipe_repository.dart';
import 'package:test/test.dart';

// Фейкове сховище тільки для тестів: use cases не знають, що воно не справжнє
class FakeRepository implements RecipeRepository {
  final Map<String, Recipe> items = {};

  @override
  List<Recipe> getAll() => items.values.toList();

  @override
  Recipe? getById(String id) => items[id];

  @override
  void save(Recipe recipe) => items[recipe.id] = recipe;
}

void main() {
  late FakeRepository repo;

  setUp(() => repo = FakeRepository());

  test('Додавання рецепта і заборона дубліката', () {
    final add = AddRecipeUseCase(repo);
    add(title: 'Сирники', servings: 2, ingredients: const []);

    expect(repo.items.length, 1);
    expect(
      () => add(title: 'сирники', servings: 2, ingredients: const []),
      throwsA(isA<DomainException>()),
    );
  });

  test('Масштабування інгредієнтів', () {
    repo.save(Recipe(
      id: 'b',
      title: 'Борщ',
      servings: 6,
      ingredients: const [Ingredient(name: 'Мʼясо', amount: 600, unit: 'г')],
    ));

    final scaled = ScaleRecipeUseCase(repo)('b', 4);
    expect(scaled.first.amount, 400);
    expect(() => ScaleRecipeUseCase(repo)('b', 20),
        throwsA(isA<DomainException>()));
  });

  test('Обране і фільтр списку', () {
    repo.save(
        Recipe(id: '1', title: 'Борщ', servings: 6, ingredients: const []));
    repo.save(
        Recipe(id: '2', title: 'Вареники', servings: 4, ingredients: const []));

    ToggleFavoriteUseCase(repo)('2');
    final favorites = ListRecipesUseCase(repo)(onlyFavorites: true);

    expect(favorites.map((r) => r.title), ['Вареники']);
  });
}
