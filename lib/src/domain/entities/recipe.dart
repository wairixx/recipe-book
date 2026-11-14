import '../errors/domain_exception.dart';
import 'ingredient.dart';

// Рецепт. Бізнес-правила (межі порцій, непорожня назва) перевіряються тут, у домені
class Recipe {
  static const int minServings = 1;
  static const int maxServings = 12;

  final String id;
  final String title;
  final int servings; // на скільки порцій розписані кількості
  final List<Ingredient> ingredients;
  final bool isFavorite;

  Recipe({
    required this.id,
    required this.title,
    required this.servings,
    required List<Ingredient> ingredients,
    this.isFavorite = false,
  }) : ingredients = List.unmodifiable(ingredients) {
    if (title.trim().isEmpty) {
      throw const DomainException('Назва рецепта не може бути порожньою');
    }
    checkServings(servings);
  }

  static void checkServings(int value) {
    if (value < minServings || value > maxServings) {
      throw DomainException(
        'Кількість порцій має бути від $minServings до $maxServings',
      );
    }
  }

  // Кількості інгредієнтів, перераховані на іншу кількість порцій
  List<Ingredient> ingredientsFor(int targetServings) {
    checkServings(targetServings);
    final factor = targetServings / servings;
    return ingredients.map((i) => i.scaled(factor)).toList();
  }

  Recipe copyWith({bool? isFavorite}) => Recipe(
        id: id,
        title: title,
        servings: servings,
        ingredients: ingredients,
        isFavorite: isFavorite ?? this.isFavorite,
      );
}
