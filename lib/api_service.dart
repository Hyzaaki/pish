import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://3.145.119.55:443';

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login'); // Endpoint de login
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Sucesso no login
      final data = jsonDecode(response.body);
      print('Login bem-sucedido: ${data['token']}');
      // Aqui, você pode armazenar o token para futuras requisições
      return true;
    } else {
      // Falha no login
      print('Erro no login: ${response.body}');
      return false;
    }
  }

  Future<bool> register(String email, String password, String username) async {
    final url = Uri.parse('$baseUrl/register'); // Endpoint de registro
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password, 'username': username}),
    );

    if (response.statusCode == 201) {
      print('Usuário registrado com sucesso!');
      return true;
    } else {
      print('Erro no registro: ${response.body}');
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    final url = Uri.parse('$baseUrl/forgot-password'); // Endpoint de recuperação
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      print('Email de recuperação enviado!');
      return true;
    } else {
      print('Erro ao enviar email: ${response.body}');
      return false;
    }
  }
  Future<Map<String, dynamic>> fetchParameters() async {
    final url = Uri.parse('$baseUrl/parameters'); // Endpoint da API para os parâmetros
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse dos dados retornados pela API.
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      // Lança uma exceção em caso de erro.
      throw Exception('Erro ao buscar parâmetros: ${response.statusCode}');
    }
  }
}
