import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/artist.dart';
import 'app_routes.dart';

/// Navigation Helper
/// Provides convenient methods for navigation throughout the app
class NavigationHelper {
  /// Navigate to Artist Catalog Screen
  static Future<void> toArtistCatalog(BuildContext context) {
    return Navigator.pushNamed(context, AppRoutes.artistCatalog);
  }

  /// Navigate to Product Detail Screen
  static Future<void> toProductDetail(
    BuildContext context, {
    required Product product,
    required Artist artist,
  }) {
    return Navigator.pushNamed(
      context,
      AppRoutes.productDetail,
      arguments: ProductDetailArguments(
        product: product,
        artist: artist,
      ),
    );
  }

  /// Navigate to Demo Screen
  static Future<void> toDemo(BuildContext context) {
    return Navigator.pushNamed(context, AppRoutes.demo);
  }

  /// Navigate to Login Screen
  static Future<void> toLogin(BuildContext context) {
    return Navigator.pushNamed(context, AppRoutes.login);
  }

  /// Navigate to Sign Up Screen
  static Future<void> toSignUp(BuildContext context) {
    return Navigator.pushNamed(context, AppRoutes.signUp);
  }

  /// Navigate to Add Product Screen
  static Future<dynamic> toAddProduct(BuildContext context) {
    return Navigator.pushNamed(context, AppRoutes.addProduct);
  }

  /// Navigate to Edit Product Screen
  static Future<dynamic> toEditProduct(BuildContext context, Product product) {
    return Navigator.pushNamed(
      context,
      AppRoutes.editProduct,
      arguments: product,
    );
  }

  /// Navigate to Home Screen
  static Future<void> toHome(BuildContext context) {
    return Navigator.pushNamed(context, AppRoutes.home);
  }

  /// Go back to previous screen
  static void goBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  /// Replace current route with Artist Catalog
  static Future<void> replaceWithArtistCatalog(BuildContext context) {
    return Navigator.pushReplacementNamed(context, AppRoutes.artistCatalog);
  }

  /// Replace current route with Home
  static Future<void> replaceWithHome(BuildContext context) {
    return Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  /// Clear all routes and go to Home
  static Future<void> clearAndGoHome(BuildContext context) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  /// Clear all routes and go to Artist Catalog
  static Future<void> clearAndGoToArtistCatalog(BuildContext context) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.artistCatalog,
      (route) => false,
    );
  }
}
