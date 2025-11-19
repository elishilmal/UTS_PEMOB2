// lib/services/gemini_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey;
  GenerativeModel? _model;
  bool _initializing = false;

  GeminiService(this.apiKey);

  // Ambil daftar model lewat REST dan pilih salah satu
  Future<void> _ensureModelSelected() async {
    if (_model != null) return;
    if (_initializing) {
      // jika sedang inisialisasi, tunggu sampai selesai
      while (_initializing && _model == null) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      if (_model != null) return;
    }

    _initializing = true;
    try {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey',
      );
      final resp = await http.get(url).timeout(const Duration(seconds: 8));
      if (resp.statusCode != 200) {
        throw Exception('Gagal ambil model: ${resp.statusCode} ${resp.body}');
      }

      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      final List models = (body['models'] as List<dynamic>?) ?? [];

      // Ambil nama model, contoh: "models/gemini-1.5-flash-latest"
      final List<String> modelNames = models
          .map<String>((m) => (m as Map<String, dynamic>)['name'] as String)
          .toList();

      // Prioritas pencarian (kata kunci)
      final priority = [
        'flash-latest',
        'flash',
        'pro-latest',
        'pro',
        '2.5',
        '1.5',
      ];

      String? chosen;
      for (final p in priority) {
        try {
          chosen = modelNames.firstWhere((n) => n.toLowerCase().contains(p));
          if (chosen != null) break;
        } catch (_) {}
      }

      // fallback: ambil first model yang support generateContent (jika ada info)
      if (chosen == null && modelNames.isNotEmpty) chosen = modelNames.first;

      if (chosen == null) {
        throw Exception('Tidak menemukan model yang dapat digunakan.');
      }

      // API mengembalikan "models/gemini-1.5-flash-latest" -> kita pakai bagian setelah "models/"
      final normalized = chosen.startsWith('models/')
          ? chosen.split('/').last
          : chosen;

      _model = GenerativeModel(model: normalized, apiKey: apiKey);

      print('GeminiService: model terpilih = $normalized');
    } on TimeoutException {
      rethrow;
    } catch (e) {
      rethrow;
    } finally {
      _initializing = false;
    }
  }

  /// Meminta jawaban singkat dari model (dengan timeout dan error handling)
  /// Chat bebas (tanpa batas paragraf)
  Future<String> askChat(String prompt, {int timeoutSeconds = 12}) async {
    try {
      await _ensureModelSelected();

      final res = await _model!
          .generateContent([Content.text(prompt)])
          .timeout(Duration(seconds: timeoutSeconds));

      return res.text ?? 'Tidak ada respons dari AI.';
    } on TimeoutException {
      return 'Timeout! AI terlalu lama merespon.';
    } catch (e) {
      return 'Error: $e';
    }
  }

  /// Lesson Mode: jawaban dibatasi
  Future<String> askLesson(
    String prompt, {
    int paragraf = 5,
    int kalimatPerParagraf = 3,
    int timeoutSeconds = 12,
  }) async {
    try {
      await _ensureModelSelected();

      final res = await _model!
          .generateContent([
            Content.text(
              "$prompt\n\n"
              "💡 Tolong jawab dengan jelas dan ringkas.\n"
              "Batasi jawaban: maksimal $paragraf paragraf.\n"
              "Setiap paragraf harus $kalimatPerParagraf–${kalimatPerParagraf + 1} kalimat.",
            ),
          ])
          .timeout(Duration(seconds: timeoutSeconds));

      return res.text ?? 'Tidak ada respons dari AI.';
    } on TimeoutException {
      return 'Timeout! AI terlalu lama merespon.';
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String> askSummary(String prompt, {int timeoutSeconds = 12}) async {
    try {
      await _ensureModelSelected();

      final response = await _model!
          .generateContent([
            Content.text(
              "$prompt\n\nRingkas teks ini menjadi sangat pendek, jelas, "
              "maksimal 5–7 kalimat saja.",
            ),
          ])
          .timeout(Duration(seconds: timeoutSeconds));

      return response.text ?? 'Tidak ada respons dari AI.';
    } on TimeoutException {
      return 'Timeout! Respon AI terlalu lama.';
    } catch (e) {
      return 'Error saat memanggil AI: $e';
    }
  }

  /// Opsional: paksa refresh model (mis. kalau mau update pilihan model)
  Future<void> refreshModel() async {
    _model = null;
    await _ensureModelSelected();
  }
}
