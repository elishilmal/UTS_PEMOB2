import 'package:flutter/material.dart';
import 'study_list_screen.dart';
import 'gemini_chat_screen.dart';
import 'about_screen.dart';
import 'profile_screen.dart'; // ⬅ Tambah ini

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  // ⬅ Tambahkan ProfileScreen sebagai page ke-4
  final pages = const [
    StudyListScreen(),
    GeminiChatScreen(),
    ProfileScreen(),
    AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],

      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),

        destinations: const [
          NavigationDestination(icon: Icon(Icons.menu_book), label: "Belajar"),
          NavigationDestination(icon: Icon(Icons.chat), label: "AI Chat"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
          NavigationDestination(icon: Icon(Icons.info), label: "About"),
        ],
      ),
    );
  }
}
