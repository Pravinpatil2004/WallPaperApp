import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'full_screen_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List photos = [];
  int page = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPhotos();
  }

  Future<void> fetchPhotos() async {
    setState(() => isLoading = true);

    final response = await http.get(
      Uri.parse("https://api.pexels.com/v1/curated?per_page=30&page=$page"),
      headers: {"Authorization": "YOUR_PEXELS_API_KEY_HERE"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        photos.addAll(data["photos"]);
        isLoading = false;
      });
    } else {
      isLoading = false;
    }
  }

  void loadMore() {
    page++;
    fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pravins Wallpaper App")),

      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: photos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 2 / 3,
              ),
              itemBuilder: (context, index) {
                final imageUrl = photos[index]["src"]["large2x"];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenPage(imageUrl: imageUrl),
                      ),
                    );
                  },
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                );
              },
            ),
          ),

          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: isLoading ? null : loadMore,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Load More"),
            ),
          ),
        ],
      ),
    );
  }
}
