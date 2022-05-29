import 'package:flutter_tts/flutter_tts.dart';

class TtsPresenter {
  FlutterTts flutterTts = FlutterTts();
  speak(List<String> messages) async {
    for (var item in messages) {
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.setLanguage("id_ID");
      await flutterTts.setPitch(1);
      await flutterTts.speak(item);
    }
  }

  greet() async {
    speak(
        ["Halo, Selamat Menggunakan WiSii!", "Tolong Aktifkan Mode TalkBack"]);
  }

  introduce() async {
    List<String> messages = [
      "Hello!!, Pertama kali menggunakan Aplikasi ini?",
      "Begini cara menggunakannya",
      "1. Lipat Uang hingga menjadi sama bagian",
      "2. Beri jarak maksimal satu jari telunjuk dan minimal seukuran jari jempol",
      "3. Dengan menggunakan mode talkback, silahkan untuk mengakses Tombol tangkap layar",
      "4. Kemudian tangkap gambar, terimakasih"
    ];
    speak(messages);
  }

  reporting(String result) async {
    List<String> messages = [result];
  }
}
