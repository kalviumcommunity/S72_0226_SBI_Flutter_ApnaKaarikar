import 'package:flutter/material.dart';
import '../screens/artist_catalog_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/add_product_screen.dart';
import '../screens/edit_product_screen.dart';
import '../models/product.dart';
import '../models/artist.dart';
import 'page_transitions.dart';

/// App Routes Configuration
/// Centralized route management for the application
class AppRoutes {
  // Route names
  static const String home = '/';
  static const String artistCatalog = '/artist-catalog';
  static const String productDetail = '/product-detail';
  static const String demo = '/demo';
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String addProduct = '/add-product';
  static const String editProduct = '/edit-product';

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const ArtistCatalogScreen(),
          settings: settings,
        );

      case artistCatalog:
        return FadeRoute(
          page: const ArtistCatalogScreen(),
        );

      case productDetail:
        final args = settings.arguments as ProductDetailArguments?;
        if (args == null) {
          return _errorRoute('Product details not provided');
        }
        return SlideRightRoute(
          page: ProductDetailScreen(
            product: args.product,
            artist: args.artist,
          ),
        );

      case demo:
        return FadeRoute(
          page: const HomeScreen(),
        );

      case login:
        return FadeRoute(
          page: const LoginScreen(),
        );

      case signUp:
        return SlideRightRoute(
          page: const SignUpScreen(),
        );

      case addProduct:
        return SlideRightRoute(
          page: const AddProductScreen(),
        );

      case editProduct:
        final product = settings.arguments as Product?;
        if (product == null) {
          return _errorRoute('Product not provided');
        }
        return SlideRightRoute(
          page: EditProductScreen(product: product),
        );

      default:
        return _errorRoute('Route not found: ${settings.name}');
    }
  }

  // Error route
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 80.0,
                  color: Colors.red,
                ),
                const SizedBox(height: 16.0),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Arguments for Product Detail Screen
class ProductDetailArguments {
  final Product product;
  final Artist artist;

  ProductDetailArguments({
    required this.product,
    required this.artist,
  });
}
