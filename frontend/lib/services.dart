import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 1) URL completa do seu túnel ngrok + caminho
  static const String apiUrl = 'https://6d6b4c1a7f03.ngrok-free.app/analisar';

  // Alias para usar o Claude 3 Sonnet via OpenRouter
  static const String modelAlias = 'claude';

  static Future<Map<String, dynamic>> analyze(String failure) async {
    try {
      // 2) Agora já temos a URI completa
      final uri = Uri.parse(apiUrl);

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "failure": failure,
          "modelo": modelAlias,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception("Erro na análise: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Erro ao conectar com o backend: $e");
    }
  }
}
