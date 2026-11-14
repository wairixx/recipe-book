import '../domain/entities/ingredient.dart';
import '../domain/entities/recipe.dart';

// Стартові рецепти, щоб книга не була порожньою при першому запуску
List<Recipe> sampleRecipes() => [
      Recipe(
        id: 'borshch',
        title: 'Борщ український',
        servings: 6,
        ingredients: const [
          Ingredient(name: 'Яловичина', amount: 600, unit: 'г'),
          Ingredient(name: 'Буряк', amount: 2, unit: 'шт'),
          Ingredient(name: 'Капуста', amount: 300, unit: 'г'),
          Ingredient(name: 'Картопля', amount: 4, unit: 'шт'),
        ],
      ),
      Recipe(
        id: 'varenyky',
        title: 'Вареники з картоплею',
        servings: 4,
        ingredients: const [
          Ingredient(name: 'Борошно', amount: 400, unit: 'г'),
          Ingredient(name: 'Картопля', amount: 600, unit: 'г'),
          Ingredient(name: 'Цибуля', amount: 2, unit: 'шт'),
        ],
      ),
      Recipe(
        id: 'syrnyky',
        title: 'Сирники',
        servings: 2,
        ingredients: const [
          Ingredient(name: 'Кисломолочний сир', amount: 400, unit: 'г'),
          Ingredient(name: 'Яйце', amount: 1, unit: 'шт'),
          Ingredient(name: 'Борошно', amount: 60, unit: 'г'),
        ],
      ),
    ];
