import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'game_screen.dart'; // Import the GameScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _loginOrRegister() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _error = 'Preencha todos os campos.';
        _isLoading = false;
      });
      return;
    }

    final users = FirebaseFirestore.instance.collection('Users');
    final userDoc = await users.doc(email).get();

    if (userDoc.exists) {
      // Login: check password
      if (userDoc['password'] == password) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GameScreen()),
        ); // Success
      } else {
        setState(() {
          _error = 'Senha incorreta.';
          _isLoading = false;
        });
      }
    } else {
      // Register: create user
      await users.doc(email).set({'email': email, 'password': password});
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GameScreen()),
      ); // Success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login ou Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : _loginOrRegister,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Entrar / Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
