import 'package:flutter/material.dart';
import '../widgets/frosted_card.dart';
import 'lesson_detail_screen.dart';

class StudyListScreen extends StatelessWidget {
  const StudyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = const [
      {"title": "Sistem Mikroprosessor", "sub": "Dasar-dasar mikroprosessor"},
      {"title": "Pemograman Mobile 2", "sub": "Flutter, Dart"},
      {"title": "Pemograman Web 1", "sub": "HTML, CSS, Bootstrap"},
      {"title": "Bahasa Indonesia", "sub": "Ragam Bahasa, Kalimat Efektif, Penggabungan Kata"},
      {"title": "Augmented & Virtual Reality", "sub": "Unity"},
      {"title": "Desain Kreatif Aplikasi dan Game", "sub": "Figma"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Materi Belajar")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: lessons
              .map(
                (e) => FrostedCard(
                  title: e["title"]!,
                  subtitle: e["sub"]!,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LessonDetailScreen(
                        title: e["title"]!,
                        subtitle: e["sub"]!,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
