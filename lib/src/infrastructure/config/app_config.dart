import 'dart:convert';
import 'dart:io';

// Налаштування з файлу config/appsettings.json
class AppConfig {
  final String storage; // "memory" або "json"
  final String dataFile;
  final int defaultServings;

  const AppConfig({
    required this.storage,
    required this.dataFile,
    required this.defaultServings,
  });

  factory AppConfig.load(String path) {
    final json =
        jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
    return AppConfig(
      storage: json['storage'] as String? ?? 'memory',
      dataFile: json['dataFile'] as String? ?? 'data/recipes.json',
      defaultServings: json['defaultServings'] as int? ?? 4,
    );
  }
}
