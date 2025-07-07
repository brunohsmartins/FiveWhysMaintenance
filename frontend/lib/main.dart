import 'package:flutter/material.dart';
import 'services.dart';

void main() {
  runApp(const FiveWhysApp());
}

class FiveWhysApp extends StatelessWidget {
  const FiveWhysApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '5 Porquês – Análise de Falhas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FiveWhysHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FiveWhysHome extends StatefulWidget {
  const FiveWhysHome({super.key});

  @override
  State<FiveWhysHome> createState() => _FiveWhysHomeState();
}

class _FiveWhysHomeState extends State<FiveWhysHome> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _analise = [];
  String _causaRaiz = '';
  String _mensagem = '';
  bool _loading = false;

  Future<void> _analisarFalha() async {
    setState(() {
      _analise = [];
      _causaRaiz = '';
      _mensagem = '';
      _loading = true;
    });

    try {
      final Map<String, dynamic> result = await ApiService.analyze(_controller.text);

      final List<dynamic> lista = result["analise"] ?? [];
      final String mensagem = result["mensagem"] ?? "";

      final List<Map<String, String>> porques = [];
      String causa = '';
      for (var item in lista) {
        final linha = item.toString();
        if (linha.startsWith('- Porquê')) {
          porques.add({"por": linha, "resp": ""});
        } else if (linha.startsWith('- Resposta')) {
          if (porques.isNotEmpty) {
            porques.last["resp"] = linha;
          }
        } else if (linha.startsWith('- Causa raiz provável')) {
          causa = linha;
        }
      }

      setState(() {
        _analise = porques;
        _causaRaiz = causa;
        _mensagem = mensagem;
      });
    } catch (e) {
      setState(() {
        _mensagem = "Erro na análise: $e";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _buildPorqueCard(String titulo, String resposta, int index) {
    return Card(
      color: Colors.lightBlue[50],
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: SizedBox(
        width: 250,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                color: const Color(0xFF2196F3),
                width: double.infinity,
                child: Center(
                  child: Text(
                    '${index + 1}º Porquê',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(titulo),
              const SizedBox(height: 5),
              Text(resposta),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCausaRaizCard(String texto) {
    return Card(
      color: Colors.orange[100],
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          texto,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
     appBar: PreferredSize(
  preferredSize: const Size.fromHeight(120), // ajuste a altura conforme seu banner
  child: AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    elevation: 0,
    flexibleSpace: Image.asset(
      'assets/cabecalho_perbras.png',
      fit: BoxFit.cover,
      width: double.infinity,
    ),
  ),
),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("Descreva a falha", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Exemplo: motor MWM superaqueceu",
              ),
            ),
            const SizedBox(height: 12),
Center(
  child: ElevatedButton(
    onPressed: _loading ? null : _analisarFalha,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.lightBlue.shade400,   // mesmo azul dos títulos
      foregroundColor: Colors.white,                // texto branco igual
      minimumSize: const Size(120, 40),             // ajuste de tamanho
      shape: const StadiumBorder(),                 // cantos arredondados
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,                // negrito igual aos títulos
        fontSize: 18,                               // mesmo tamanho de fonte
      ),
    ),
    child: _loading
        ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
        : const Text("Analisar"),
  ),
),
            const SizedBox(height: 20),
            if (_analise.isNotEmpty) const Text("Análise:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (_analise.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _analise.asMap().entries.map((entry) {
                    return _buildPorqueCard(entry.value["por"]!, entry.value["resp"]!, entry.key);
                  }).toList(),
                ),
              ),
            if (_causaRaiz.isNotEmpty) _buildCausaRaizCard(_causaRaiz),
            const SizedBox(height: 20),
            Text(_mensagem, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

