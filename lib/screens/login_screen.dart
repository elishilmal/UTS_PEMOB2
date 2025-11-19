import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import '../widgets/primary_button.dart';
import '../db_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  String? message;

  Future<void> loginUser() async {
    if (email.text.isEmpty || pass.text.isEmpty) {
      setState(() => message = "Email dan Password harus diisi");
      return;
    }

    final user = await DBHelper.instance.login(email.text, pass.text);

    if (user != null) {
      await DBHelper.instance.setUserLoggedIn(user['id']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      setState(() => message = "Email atau Password salah");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pass,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 24),

            PrimaryButton(text: "Login", onTap: loginUser),

            if (message != null) ...[
              const SizedBox(height: 10),
              Text(message!, style: const TextStyle(color: Colors.red)),
            ],

            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterScreen()),
              ),
              child: const Text("Belum punya akun? Daftar"),
            ),
          ],
        ),
      ),
    );
  }
}
