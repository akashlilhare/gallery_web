import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixabay Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GalleryPage(),
    );
  }
}

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  GalleryPageState createState() => GalleryPageState();
}

class GalleryPageState extends State{

  late List<dynamic> _images = [];
  late TextEditingController _searchController = TextEditingController();
  bool _loading = false;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _loadImages();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadImages() async {
    setState(() {
      _loading = true;
    });

    final String apiKey = '43594279-d7d1bc7b843c78f24a539062b';
    final String query = _searchController.text;
    final String url = 'https://pixabay.com/api/'
        '?key=$apiKey'
        '&q=$query'
        '&per_page=20'
        '&page=$_page';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        _images += json.decode(response.body)['hits'];
        _loading = false;
        _page++;
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  void _onSearchChanged() {
    setState(() {
      _images.clear();
      _page = 1;
    });
    _loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search Images...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: _images.length,
        itemBuilder: (context, index) {
          final image = _images[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenImagePage(imageUrl: image['largeImageURL']),
                ),
              );
            },
            child: Image.network(image['webformatURL']),
          );
        },
      //  controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
      ),
    );
  }
}

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImagePage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
