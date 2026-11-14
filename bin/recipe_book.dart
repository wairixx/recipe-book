import 'dart:convert';
import 'dart:io';

import 'package:recipe_book/src/application/use_cases/add_recipe.dart';
import 'package:recipe_book/src/application/use_cases/list_recipes.dart';
import 'package:recipe_book/src/application/use_cases/scale_recipe.dart';
import 'package:recipe_book/src/application/use_cases/toggle_favorite.dart';
import 'package:recipe_book/src/domain/interfaces/recipe_repository.dart';
import 'package:recipe_book/src/infrastructure/config/app_config.dart';
import 'package:recipe_book/src/infrastructure/repositories/in_memory_recipe_repository.dart';
import 'package:recipe_book/src/infrastructure/repositories/json_recipe_repository.dart';
import 'package:recipe_book/src/infrastructure/sample_data.dart';
import 'package:recipe_book/src/presentation/cli/recipe_cli.dart';

// Точка входу (composition root): тут збираються всі шари через Dependency Injection
void main() {
  final config = AppConfig.load('config/appsettings.json');

  // Єдине місце, де обирається конкретне сховище. Use cases бачать тільки інтерфейс
  final RecipeRepository repository = config.storage == 'json'
      ? JsonRecipeRepository(config.dataFile)
      : InMemoryRecipeRepository();

  if (repository.getAll().isEmpty) {
    sampleRecipes().forEach(repository.save);
  }

  final cli = RecipeCli(
    listRecipes: ListRecipesUseCase(repository),
    addRecipe: AddRecipeUseCase(repository),
    scaleRecipe: ScaleRecipeUseCase(repository),
    toggleFavorite: ToggleFavoriteUseCase(repository),
    defaultServings: config.defaultServings,
    readLine: () => stdin.readLineSync(encoding: utf8),
    print: stdout.writeln,
  );
  cli.run();
}
