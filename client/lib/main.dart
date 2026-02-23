import 'package:flutter/material.dart';
import 'utils/app_theme.dart';
import 'screens/artist_catalog_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ApnaKaarikar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const ArtistCatalogScreen(),
    );
  }
}


