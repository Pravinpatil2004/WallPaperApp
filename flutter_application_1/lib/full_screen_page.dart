import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:android_intent_plus/android_intent.dart';

class FullScreenPage extends StatelessWidget {
  final String imageUrl;

  const FullScreenPage({super.key, required this.imageUrl});

  // 🔹 Download image & return file path
  Future<String> downloadImage() async {
    final response = await http.get(Uri.parse(imageUrl));
    final dir = await getTemporaryDirectory();
    final filePath = "${dir.path}/wallpaper.jpg";

    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  // 🔹 Open Android wallpaper picker
  Future<void> setWallpaper(BuildContext context) async {
    try {
      final path = await downloadImage();

      final intent = AndroidIntent(
        action: 'android.intent.action.SET_WALLPAPER',
        data: Uri.file(path).toString(),
        type: 'image/*',
      );

      await intent.launch();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Choose wallpaper screen opened ✅")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to open wallpaper chooser ❌")),
      );
      debugPrint("Wallpaper error: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Preview",
            style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () => setWallpaper(context),
                child: const Text("Set as Wallpaper"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
