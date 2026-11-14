// Інгредієнт рецепта: назва, кількість і одиниця виміру
class Ingredient {
  final String name;
  final double amount;
  final String unit;

  const Ingredient({
    required this.name,
    required this.amount,
    required this.unit,
  });

  // Повертає новий інгредієнт з кількістю, помноженою на коефіцієнт
  Ingredient scaled(double factor) =>
      Ingredient(name: name, amount: amount * factor, unit: unit);

  @override
  String toString() => '$name — ${_format(amount)} $unit';

  // 600.0 -> "600", 1.333 -> "1.3"
  static String _format(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(1);
}
