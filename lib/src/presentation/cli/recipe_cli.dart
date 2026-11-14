import '../../application/use_cases/add_recipe.dart';
import '../../application/use_cases/list_recipes.dart';
import '../../application/use_cases/scale_recipe.dart';
import '../../application/use_cases/toggle_favorite.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/errors/domain_exception.dart';

// Консольний інтерфейс. Тут немає бізнес-логіки: тільки введення, виведення і виклик use cases
class RecipeCli {
  final ListRecipesUseCase _listRecipes;
  final AddRecipeUseCase _addRecipe;
  final ScaleRecipeUseCase _scaleRecipe;
  final ToggleFavoriteUseCase _toggleFavorite;
  final int _defaultServings;

  // Введення і виведення передаються ззовні, щоб CLI можна було тестувати
  final String? Function() _readLine;
  final void Function(String) _print;

  RecipeCli({
    required ListRecipesUseCase listRecipes,
    required AddRecipeUseCase addRecipe,
    required ScaleRecipeUseCase scaleRecipe,
    required ToggleFavoriteUseCase toggleFavorite,
    required int defaultServings,
    required String? Function() readLine,
    required void Function(String) print,
  })  : _listRecipes = listRecipes,
        _addRecipe = addRecipe,
        _scaleRecipe = scaleRecipe,
        _toggleFavorite = toggleFavorite,
        _defaultServings = defaultServings,
        _readLine = readLine,
        _print = print;

  void run() {
    _print('=== Книга рецептів ===');
    while (true) {
      _print('');
      _print('1 - Усі рецепти   2 - Обране   3 - Перерахувати порції');
      _print('4 - В обране / з обраного   5 - Додати рецепт   0 - Вихід');
      final choice = _ask('Ваш вибір');
      if (choice == null || choice == '0') {
        _print('До побачення!');
        return;
      }
      try {
        switch (choice) {
          case '1':
            _showList(_listRecipes());
          case '2':
            _showList(_listRecipes(onlyFavorites: true));
          case '3':
            _scale();
          case '4':
            _toggle();
          case '5':
            _add();
          default:
            _print('Немає такого пункту');
        }
      } on DomainException catch (e) {
        _print('Помилка: ${e.message}');
      }
    }
  }

  void _showList(List<Recipe> recipes) {
    if (recipes.isEmpty) {
      _print('Список порожній');
      return;
    }
    for (var i = 0; i < recipes.length; i++) {
      final r = recipes[i];
      final star = r.isFavorite ? ' ★' : '';
      _print('${i + 1}. ${r.title} (${r.servings} порц.)$star');
    }
  }

  // Вибір рецепта за номером зі списку
  Recipe? _pickRecipe() {
    final recipes = _listRecipes();
    _showList(recipes);
    final index = int.tryParse(_ask('Номер рецепта') ?? '');
    if (index == null || index < 1 || index > recipes.length) {
      _print('Невірний номер');
      return null;
    }
    return recipes[index - 1];
  }

  void _scale() {
    final recipe = _pickRecipe();
    if (recipe == null) return;
    final servings =
        int.tryParse(_ask('Скільки порцій [$_defaultServings]') ?? '') ??
            _defaultServings;
    _print('${recipe.title} на $servings порц.:');
    for (final ingredient in _scaleRecipe(recipe.id, servings)) {
      _print('  - $ingredient');
    }
  }

  void _toggle() {
    final recipe = _pickRecipe();
    if (recipe == null) return;
    final updated = _toggleFavorite(recipe.id);
    _print(updated.isFavorite
        ? '«${updated.title}» додано в обране'
        : '«${updated.title}» прибрано з обраного');
  }

  void _add() {
    final title = _ask('Назва') ?? '';
    final servings = int.tryParse(_ask('На скільки порцій') ?? '') ?? 0;
    final ingredients = <Ingredient>[];
    _print(
        'Інгредієнти у форматі "назва;кількість;одиниця", порожній рядок - кінець');
    while (true) {
      final line = _ask('Інгредієнт');
      if (line == null || line.trim().isEmpty) break;
      final parts = line.split(';');
      final amount = parts.length == 3 ? double.tryParse(parts[1]) : null;
      if (amount == null) {
        _print('Формат: назва;кількість;одиниця');
        continue;
      }
      ingredients.add(Ingredient(
        name: parts[0].trim(),
        amount: amount,
        unit: parts[2].trim(),
      ));
    }
    final recipe = _addRecipe(
      title: title,
      servings: servings,
      ingredients: ingredients,
    );
    _print('Рецепт «${recipe.title}» додано');
  }

  String? _ask(String prompt) {
    _print('$prompt: ');
    return _readLine()?.trim();
  }
}
