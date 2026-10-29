import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pocket_chef/controllers/auth_controller.dart';
import 'home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoginMode = true; // Alterna entre Entrar e Cadastrar

  @override
  Widget build(BuildContext context) {
    // Definindo as cores da nossa paleta personalizada
    final Color primaryRed = Color(0xFFc32f27);
    final Color warmOrange = Color(0xFFd8572a);
    final Color backgroundYellow = Color(0xFFf7b538);

    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo ou Título do App com a cor da paleta
              Icon(
                Icons.restaurant_menu,
                size: 80,
                color: primaryRed,
              ),
              const SizedBox(height: 16),
              const Text(
                'Pocket Chef',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF780116), // Tom mais escuro da paleta
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Seu caderno de receitas digital',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 32),

              // Campo de E-mail
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email, color: warmOrange),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: warmOrange, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Campo de Senha
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock, color: warmOrange),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: warmOrange, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Botão de Ação (Entrar ou Cadastrar)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: authController.isLoading
                      ? null
                      : () async {
                          bool success;
                          if (_isLoginMode) {
                            success = await authController.login(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                          } else {
                            success = await authController.register(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                          }

                          if (success && mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeView(),
                              ),
                            );
                          }
                        },
                  child: authController.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          _isLoginMode ? 'Entrar' : 'Cadastrar',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Botão para alternar entre Login e Cadastro
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLoginMode = !_isLoginMode;
                  });
                },
                child: Text(
                  _isLoginMode
                      ? 'Não tem uma conta? Cadastre-se'
                      : 'Já tem uma conta? Entre aqui',
                  style: TextStyle(color: warmOrange, fontWeight: FontWeight.bold),
                ),
              ),

              // Mensagem de erro caso ocorra
              if (authController.errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    authController.errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}