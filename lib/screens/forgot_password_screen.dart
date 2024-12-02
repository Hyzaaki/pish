import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  // Função para tentar verificar o e-mail através do login
  Future<void> _verifyEmail(String email) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final url = Uri.parse('http://3.145.119.55:443/user/login');  // Endpoint de login
      final response = await http.post(
        url,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'password',
          'username': email,
          'password': 'wrongpassword',  // Tentando um login com senha incorreta
          'scope': '',
          'client_id': 'string',
          'client_secret': 'string',
        },
      );

      if (response.statusCode == 200) {
        // O e-mail existe, mas a senha está incorreta, não será o caso aqui, já que estamos testando com 'wrongpassword'
        setState(() {
          errorMessage = 'A senha está incorreta, mas o e-mail está cadastrado.';
        });
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        // Se o e-mail não for encontrado
        setState(() {
          errorMessage = 'E-mail não cadastrado. Verifique o e-mail e tente novamente.';
        });
      } else {
        // Outro tipo de erro
        setState(() {
          errorMessage = 'Erro ao tentar verificar o e-mail. Tente novamente mais tarde.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erro de conexão. Verifique sua internet.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset('lib/image/logo.png', height: 100),
                SizedBox(height: 20),

                // Título
                Text(
                  'CleanAir',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),

                // Texto de instrução
                Text(
                  'Forgot your password?',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),

                // Campo de e-mail
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Confirm your email',
                    hintText: 'Your email address',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                // Exibir mensagem de erro se necessário
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),

                // Botão de envio
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                      final email = emailController.text;
                      if (email.isNotEmpty) {
                        _verifyEmail(email);
                      } else {
                        setState(() {
                          errorMessage = 'Por favor, insira seu e-mail.';
                        });
                      }
                    },
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Send'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Cor do botão
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                // Rodapé
                SizedBox(height: 30),
                Text(
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
