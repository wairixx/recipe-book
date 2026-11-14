import '../../domain/entities/ingredient.dart';
import '../../domain/entities/recipe.dart';

// Перетворення Recipe <-> JSON. Це деталь зберігання, тому вона не в домені
class RecipeJsonMapper {
  static Map<String, dynamic> toJson(Recipe recipe) => {
        'id': recipe.id,
        'title': recipe.title,
        'servings': recipe.servings,
        'isFavorite': recipe.isFavorite,
        'ingredients': [
          for (final i in recipe.ingredients)
            {'name': i.name, 'amount': i.amount, 'unit': i.unit},
        ],
      };

  static Recipe fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'] as String,
        title: json['title'] as String,
        servings: json['servings'] as int,
        isFavorite: json['isFavorite'] as bool? ?? false,
        ingredients: [
          for (final i in json['ingredients'] as List<dynamic>)
            Ingredient(
              name: i['name'] as String,
              amount: (i['amount'] as num).toDouble(),
              unit: i['unit'] as String,
            ),
        ],
      );
}
