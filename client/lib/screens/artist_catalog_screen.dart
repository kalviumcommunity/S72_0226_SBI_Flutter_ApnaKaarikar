import 'package:flutter/material.dart';
import '../models/artist.dart';
import '../models/product.dart';
import '../widgets/custom_header.dart';
import '../widgets/artist_header.dart';
import '../widgets/product_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_state.dart';
import '../utils/navigation_helper.dart';
import '../services/firestore_service.dart';

/// Artist Catalog Screen (With Firestore Integration)
/// Displays artist profile and product catalog from Firestore
class ArtistCatalogScreen extends StatefulWidget {
  final String? artistId;

  const ArtistCatalogScreen({
    Key? key,
    this.artistId,
  }) : super(key: key);

  @override
  State<ArtistCatalogScreen> createState() => _ArtistCatalogScreenState();
}

class _ArtistCatalogScreenState extends State<ArtistCatalogScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  
  Artist? _artist;
  List<Product> _products = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _useMockData = true; // Toggle for testing

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_useMockData) {
        // Use mock data for now
        await Future.delayed(const Duration(milliseconds: 500));
        _artist = _getMockArtist();
        _products = _getMockProducts();
      } else {
        // Load from Firestore
        final artistId = widget.artistId ?? 'default';
        _artist = await _firestoreService.getArtist(artistId);
        _products = await _firestoreService.getProductsByArtist(artistId);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    await _loadData();
  }

  Future<void> _handleAddProduct() async {
    final result = await NavigationHelper.toAddProduct(context);
    if (result == true) {
      // Reload data after adding product
      _loadData();
    }
  }

  Future<void> _handleEditProduct(Product product) async {
    final result = await NavigationHelper.toEditProduct(context, product);
    if (result == true) {
      // Reload data after editing product
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHeader(
        title: _artist?.name ?? 'Artist Catalog',
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
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleAddProduct,
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingIndicator(
        message: 'Loading products...',
      );
    }

    if (_errorMessage != null) {
      return ErrorState(
        message: _errorMessage!,
        onRetry: _loadData,
      );
    }

    if (_artist == null) {
      return ErrorState(
        message: 'Artist not found',
        onRetry: _loadData,
      );
    }

    if (_products.isEmpty) {
      return const EmptyState(
        message: 'No products available yet',
        icon: Icons.shopping_bag_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: CustomScrollView(
        slivers: [
          // Artist Header
          SliverToBoxAdapter(
            child: ArtistHeader(artist: _artist!),
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
                    product: _products[index],
                    onTap: () {
                      NavigationHelper.toProductDetail(
                        context,
                        product: _products[index],
                        artist: _artist!,
                      );
                    },
                    onLongPress: () {
                      _handleEditProduct(_products[index]);
                    },
                  );
                },
                childCount: _products.length,
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
