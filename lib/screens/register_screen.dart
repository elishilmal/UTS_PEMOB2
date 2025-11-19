import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../db_helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  String? message;

  Future<void> registerUser() async {
    if (name.text.isEmpty || email.text.isEmpty || pass.text.isEmpty) {
      setState(() => message = "Semua harus diisi");
      return;
    }

    try {
      await DBHelper.instance.register(
        name.text,
        email.text,
        pass.text,
      );

      setState(() => message = "Akun berhasil dibuat!");

      // Setelah sukses kembali ke login
      await Future.delayed(const Duration(seconds: 1));

      Navigator.pop(context);
    } catch (e) {
      setState(() => message = "Gagal mendaftar: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Akun")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(
                labelText: "Nama Lengkap",
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
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
            PrimaryButton(text: "Buat Akun", onTap: registerUser),

            if (message != null) ...[
              const SizedBox(height: 10),
              Text(message!, style: const TextStyle(color: Colors.black87)),
            ],
          ],
        ),
      ),
    );
  }
}
