import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static Future<void> load() async {
    await dotenv.load(); // 加载 .env 文件
  }

  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
}
