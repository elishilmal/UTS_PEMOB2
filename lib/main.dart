import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'services/gemini_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<GeminiService>(
          create: (_) =>
              GeminiService('AIzaSyAKu9F7xE-6BWIt8gp5pG_rDellQiwYjMM'),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Asisten Belajar AI',
      home: SplashScreen(),
    );
  }
}
