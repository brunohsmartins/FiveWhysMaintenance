import 'dart:convert';
import 'package:http/http.dart' as http;

class WhyService {
  static const String _baseUrl = 'http://127.0.0.1:8001';

  static Future<List<String>> analisarFalha(String failure) async {
    final url = Uri.parse('$_baseUrl/analisar');
    final body = jsonEncode({'failure': failure, 'checks': []});

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> perguntas = data['perguntas'];
      return perguntas.map((e) => e.toString()).toList();
    } else {
      throw Exception('Erro na análise: ${response.statusCode}');
    }
  }
}
