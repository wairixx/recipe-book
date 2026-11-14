import 'dart:convert';
import 'dart:io';

import '../../domain/entities/recipe.dart';
import '../../domain/interfaces/recipe_repository.dart';
import '../mappers/recipe_json_mapper.dart';

// Сховище у JSON-файлі: рецепти зберігаються між запусками програми
class JsonRecipeRepository implements RecipeRepository {
  final File _file;

  JsonRecipeRepository(String path) : _file = File(path);

  @override
  List<Recipe> getAll() {
    if (!_file.existsSync()) return [];
    final data = jsonDecode(_file.readAsStringSync()) as List<dynamic>;
    return data
        .map((item) => RecipeJsonMapper.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Recipe? getById(String id) {
    for (final recipe in getAll()) {
      if (recipe.id == id) return recipe;
    }
    return null;
  }

  @override
  void save(Recipe recipe) {
    final recipes = getAll()..removeWhere((r) => r.id == recipe.id);
    recipes.add(recipe);
    _file.parent.createSync(recursive: true);
    _file.writeAsStringSync(
      const JsonEncoder.withIndent('  ')
          .convert(recipes.map(RecipeJsonMapper.toJson).toList()),
    );
  }
}
