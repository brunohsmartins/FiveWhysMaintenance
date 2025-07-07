import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Passa a ser só o caminho, sem host nem porta
  static const String apiEndpoint = '/analisar';

  // Alias para usar o Claude 3 Sonnet via OpenRouter
  static const String modelAlias = "claude";

  /// Envia a falha e o alias de modelo ao backend,
  /// que vai mapear "claude" para anthropic/claude-3-sonnet.
  static Future<Map<String, dynamic>> analyze(String failure) async {
    try {
      // Agora criamos uma URI relativa
      final uri = Uri(path: apiEndpoint);

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
        throw Exception(
          "Erro na análise: ${response.statusCode} - ${response.body}"
        );
      }
    } catch (e) {
      throw Exception("Erro ao conectar com o backend.");
    }
  }
}
