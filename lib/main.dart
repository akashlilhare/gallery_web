import 'package:flutter/material.dart';
import 'package:gallery_web/pages/gallery_page.dart';
import 'package:gallery_web/provider/gallery_provider.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<GalleryProvider>(create: (_) => GalleryProvider()),
        ],
        builder: (context, _) {
          return MaterialApp(
              title: 'Gallery App',
              theme: ThemeData.dark(),
              home: GalleryPage());
        });
  }
}
