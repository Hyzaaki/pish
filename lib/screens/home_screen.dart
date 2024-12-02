import 'dart:convert';
import 'dart:async'; // Para usar Timer
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pish/screens/historico.dart';
import 'package:pish/screens/login_screen.dart'; // Para redirecionar ao fazer logout

class HomeScreen extends StatefulWidget {
  final String token;
  final String username;

  const HomeScreen({Key? key, required this.token, required this.username})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double temperatura = 0.0;
  double umidade = 0.0;
  double monoxido = 0.0;
  double dioxido = 0.0;

  Future<void> fetchSensorData(String sensor) async {
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

        if (data.isNotEmpty) {
          final sensorData = data[0];

          setState(() {
            switch (sensor) {
              case 'temperatura':
                temperatura =
                    double.tryParse(sensorData['value'].toString()) ?? 0.0;
                break;
              case 'umidade':
                umidade = double.tryParse(sensorData['value'].toString()) ?? 0.0;
                break;
              case 'monoxido':
                monoxido =
                    double.tryParse(sensorData['value'].toString()) ?? 0.0;
                break;
              case 'dioxido':
                dioxido = double.tryParse(sensorData['value'].toString()) ?? 0.0;
                break;
            }
          });
        }
      } else {
        throw Exception('Erro ao carregar dados do sensor $sensor');
      }
    } catch (e) {
      print('Erro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados do sensor $sensor: $e')),
      );
    }
  }

  void fetchAllSensorData() {
    fetchSensorData('temperatura');
    fetchSensorData('umidade');
    fetchSensorData('monoxido');
    fetchSensorData('dioxido');
  }

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    fetchAllSensorData();

    _timer = Timer.periodic(Duration(seconds: 7), (timer) {
      fetchAllSensorData();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      body: Column(
        children: [
          // Barra superior com os botões e logo
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
                Image.asset(
                  'lib/image/logo.png',
                  height: 40,
                ),
                IconButton(
                  icon: Icon(Icons.history, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HistoryScreen(token: widget.token)),
                    );
                  },
                ),
              ],
            ),
          ),
          // Saudação
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Welcome, ${widget.username}!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Cartões de exibição dos parâmetros
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, // Exibe 2 itens por linha
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              padding: EdgeInsets.all(16),
              children: [
                _buildParameterCard(
                    'Temperatura', '$temperatura°C', Icons.thermostat, Colors.blue),
                _buildParameterCard(
                    'Umidade', '$umidade%', Icons.cloud, Colors.green),
                _buildParameterCard('Monóxido de Carbono (CO)',
                    '$monoxido ppm', Icons.warning, Colors.red),
                _buildParameterCard('Dióxido de Carbono (CO2)',
                    '$dioxido ppm', Icons.bubble_chart, Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Função auxiliar para criar os cartões
  Widget _buildParameterCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
