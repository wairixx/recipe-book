// Порушення бізнес-правила (наприклад, 20 порцій або порожня назва)
class DomainException implements Exception {
  final String message;

  const DomainException(this.message);

  @override
  String toString() => message;
}
