import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 12),
            Text('Asisten Belajar AI', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Deskripsi: Aplikasi Asisten Belajar yang memanfaatkan AI Gemini untuk ringkasan materi, latihan soal, dan tanya jawab.'),
            SizedBox(height: 12),
            Text('Versi: 1.0.0'),
            SizedBox(height: 12),
            Text('Copyright © Elis Hilmal Muhibah Syawalah_23552011313'),
          ],
        ),
      ),
    );
  }
}