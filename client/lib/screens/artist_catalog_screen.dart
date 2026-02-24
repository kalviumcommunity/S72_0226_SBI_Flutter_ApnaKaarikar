import 'package:flutter/material.dart';
import '../models/artist.dart';
import '../models/product.dart';
import '../widgets/custom_header.dart';
import '../widgets/artist_header.dart';
import '../widgets/product_card.dart';
import '../utils/navigation_helper.dart';

/// Artist Catalog Screen (Static with Mock Data)
/// Displays artist profile and product catalog
class ArtistCatalogScreen extends StatelessWidget {
  const ArtistCatalogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final artist = _getMockArtist();
    final products = _getMockProducts();

    return Scaffold(
      appBar: CustomHeader(
        title: artist.name,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share catalog via WhatsApp'),
                ),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Artist Header
          SliverToBoxAdapter(
            child: ArtistHeader(artist: artist),
          ),
          // Product Grid
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ProductCard(
                    product: products[index],
                    onTap: () {
                      NavigationHelper.toProductDetail(
                        context,
                        product: products[index],
                        artist: artist,
                      );
                    },
                  );
                },
                childCount: products.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mock Data - Artist
  Artist _getMockArtist() {
    return const Artist(
      id: '1',
      name: 'Rajesh Kumar',
      craftType: 'Traditional Pottery',
      location: 'Jaipur, Rajasthan',
      profilePhoto: 'placeholder',
      rating: 4.5,
      reviewCount: 23,
    );
  }

  // Mock Data - Products
  List<Product> _getMockProducts() {
    return const [
      Product(
        id: '1',
        name: 'Handcrafted Clay Pot',
        price: 450,
        imageUrl: 'placeholder',
        inStock: true,
        description: 'Beautiful handcrafted clay pot with traditional designs',
      ),
      Product(
        id: '2',
        name: 'Decorative Vase',
        price: 850,
        imageUrl: 'placeholder',
        inStock: true,
        description: 'Elegant decorative vase perfect for home decor',
      ),
      Product(
        id: '3',
        name: 'Terracotta Bowl Set',
        price: 1200,
        imageUrl: 'placeholder',
        inStock: false,
        description: 'Set of 4 terracotta bowls with intricate patterns',
      ),
      Product(
        id: '4',
        name: 'Clay Water Jug',
        price: 350,
        imageUrl: 'placeholder',
        inStock: true,
        description: 'Traditional clay water jug keeps water cool naturally',
      ),
      Product(
        id: '5',
        name: 'Painted Flower Pot',
        price: 550,
        imageUrl: 'placeholder',
        inStock: true,
        description: 'Hand-painted flower pot with vibrant colors',
      ),
      Product(
        id: '6',
        name: 'Ceramic Dinner Set',
        price: 2500,
        imageUrl: 'placeholder',
        inStock: true,
        description: 'Complete dinner set for 4 people',
      ),
      Product(
        id: '7',
        name: 'Decorative Plate',
        price: 650,
        imageUrl: 'placeholder',
        inStock: false,
        description: 'Wall hanging decorative plate with traditional art',
      ),
      Product(
        id: '8',
        name: 'Clay Lamp',
        price: 250,
        imageUrl: 'placeholder',
        inStock: true,
        description: 'Traditional clay lamp for festivals',
      ),
    ];
  }
}
