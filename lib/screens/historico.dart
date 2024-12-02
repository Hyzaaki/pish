import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_screen.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  final String token; // Token para autenticação
  const HistoryScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> sensorDataList = []; // Lista para armazenar os dados
  String selectedSensor = ''; // Filtro atual

  Future<void> fetchSensorHistory(String sensor) async {
    final String apiUrl = 'http://3.145.119.55:443/sensores/sensordata/$sensor';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          sensorDataList = data
              .map((e) => {
            'value': e['value'],
            'sensor': sensor.toUpperCase(),
            'timestamp': _formatTimestamp(e['timestamp']),
          })
              .toList();
        });
      } else {
        throw Exception('Erro ao carregar dados do sensor $sensor');
      }
    } catch (e) {
      print('Erro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar histórico: $e')),
      );
    }
  }

  void showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecione o Sensor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Temperatura'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  selectedSensor = 'temperatura';
                  fetchSensorHistory(selectedSensor);
                });
              },
            ),
            ListTile(
              title: const Text('Umidade'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  selectedSensor = 'umidade';
                  fetchSensorHistory(selectedSensor);
                });
              },
            ),
            ListTile(
              title: const Text('Monóxido'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  selectedSensor = 'monoxido';
                  fetchSensorHistory(selectedSensor);
                });
              },
            ),
            ListTile(
              title: const Text('Dióxido'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  selectedSensor = 'dioxido';
                  fetchSensorHistory(selectedSensor);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Carregar histórico inicial (por exemplo, para "temperatura")
    selectedSensor = 'temperatura';
    fetchSensorHistory(selectedSensor);
  }

  // Função para formatar o timestamp e ajustar para o fuso horário correto
  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp); // Converte para DateTime
      final adjustedDateTime = dateTime.subtract(Duration(hours: 3)); // Subtrai 3 horas
      return DateFormat('dd/MM/yyyy - HH:mm:ss').format(adjustedDateTime); // Formata o horário ajustado
    } catch (e) {
      print('Erro ao formatar timestamp: $e');
      return timestamp; // Retorna o original em caso de erro
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1537), // Fundo azul-escuro
      body: Column(
        children: [
          // Faixa azul no topo com a logo e botões
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.blue, // Cor azul
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  onPressed: showFilterDialog,
                ),
                Image.asset(
                  'lib/image/logo.png', // Logo da sua aplicação
                  height: 40,
                ),
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HomeScreen(token: widget.token, username: 'Usuário'),
                      ),
                    );
                  },
                ),
                // titulo
              ],
            ),
          ),
          // Texto "Histórico" abaixo da faixa azul
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Histórico',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sensorDataList.length,
              itemBuilder: (context, index) {
                final item = sensorDataList[index];
                return Card(
                  color: const Color(0xFF1A2139),
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      'Medição: ${item['value']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Sensor: ${item['sensor']}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Text(
                      item['timestamp'],
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
