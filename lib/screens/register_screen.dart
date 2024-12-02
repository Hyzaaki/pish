import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  // Função para registrar o usuário
  Future<String?> _register(String email, String password, String username) async {
    try {
      final url = Uri.parse('http://3.145.119.55:443/user/create');
      final response = await http.post(
        url,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'username': username,
        }),
      );

      if (response.statusCode == 200) {
        // Registro bem-sucedido
        return null;
      } else {
        // Falha no registro, retorna a mensagem de erro
        final data = json.decode(response.body);
        return data['message']; // Exemplo: "Email already registered" ou "Username already exists"
      }
    } catch (e) {
      return 'Error connecting to the server.';
    }
  }

  // Função para validar os campos
  String? _validateFields() {
    if (usernameController.text.isEmpty) {
      return 'Username is required';
    }
    if (emailController.text.isEmpty) {
      return 'Email is required';
    }
    if (passwordController.text.isEmpty) {
      return 'Password is required';
    }
    // Validação de formato de e-mail simples
    final emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    final emailRegex = RegExp(emailPattern);
    if (!emailRegex.hasMatch(emailController.text)) {
      return 'Please enter a valid email address';
    }
    return null; // Todos os campos estão válidos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Logo na parte superior
                Image.asset('lib/image/logo.png', height: 100),
                const SizedBox(height: 20),
                const Text(
                  'Welcome to CleanAir!',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Create an account to get started',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Choose a username',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final username = usernameController.text;
                    final email = emailController.text;
                    final password = passwordController.text;

                    // Valida os campos antes de registrar
                    final validationError = _validateFields();

                    if (validationError != null) {
                      // Exibe a mensagem de erro de validação
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(validationError),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      // Tenta registrar o usuário e verifica se houve erro
                      String? errorMessage = await _register(email, password, username);

                      if (errorMessage == null) {
                        // Registro bem-sucedido, exibe mensagem e retorna ao login
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('User created successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        await Future.delayed(const Duration(seconds: 2));
                        Navigator.pop(context);
                      } else {
                        // Falha no registro, exibe mensagem de erro
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errorMessage),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('SIGN UP'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // Link para login
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Volta para a tela de login
                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                // Rodapé
                const SizedBox(height: 30),
                const Text(
                  '© 2024, Made in Brazil, for Homework PISH\nMarketplace    Page Official    License',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
