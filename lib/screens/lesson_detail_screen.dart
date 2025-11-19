import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import 'package:provider/provider.dart';
import '../services/gemini_service.dart';
import 'dart:async';

class LessonDetailScreen extends StatefulWidget {
  final String title;
  final String subtitle;

  const LessonDetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  bool loading = false;
  bool loadingSummary = false;

  String? materiAI;
  String? summary;

  /// 🔹 Meminta AI membuat materi lengkap
  Future<void> loadMateri() async {
    setState(() => loading = true);

    final ai = Provider.of<GeminiService>(context, listen: false);

    try {
      materiAI = await ai
          .askLesson(
            "Buatkan materi pembelajaran lengkap dengan judul: ${widget.title}. "
            "Berikan penjelasan terstruktur, ringkas namun mendalam, dan mudah dipahami.",
          )
          .timeout(const Duration(seconds: 25));
    } on TimeoutException {
      materiAI = "⚠ Permintaan terlalu lama. Coba ulangi.";
    } catch (e) {
      materiAI = "⚠ Terjadi error: $e";
    }

    setState(() => loading = false);
  }

  Future<void> summarize() async {
    if (materiAI == null) return;

    setState(() => loadingSummary = true);

    final ai = Provider.of<GeminiService>(context, listen: false);

    try {
      summary = await ai
          .askSummary(
            "Ringkas materi berikut dengan jelas dan singkat:\n$materiAI",
          )
          .timeout(const Duration(seconds: 20));
    } on TimeoutException {
      summary = "⚠ Terlalu lama merespons. Coba ulangi.";
    } catch (e) {
      summary = "⚠ Terjadi error: $e";
    }

    setState(() => loadingSummary = false);
  }

  @override
  void initState() {
    super.initState();
    loadMateri(); // 🔥 Load materi saat halaman dibuka
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.subtitle, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),

            /// 🔹 Konten Materi dari AI
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Text(
                        materiAI ?? "Gagal memuat materi.",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
            ),

            const SizedBox(height: 8),

            /// 🔹 Tombol Ringkas AI
            PrimaryButton(
              text: loadingSummary ? "Merangkum..." : "Ringkas Dengan AI",
              onTap: materiAI == null
                  ? () {} // fungsi kosong sementara => tombol tidak melakukan apa-apa
                  : () {
                      summarize();
                    },
            ),

            if (summary != null) ...[
              const SizedBox(height: 16),
              const Text(
                "Ringkasan:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(summary!),
            ],
          ],
        ),
      ),
    );
  }
}
