import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/artist.dart';

/// Firestore Service
/// Handles all Firestore database operations
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection names
  static const String artistsCollection = 'artists';
  static const String productsCollection = 'products';

  /// Get artist by ID
  Future<Artist?> getArtist(String artistId) async {
    try {
      final doc = await _firestore
          .collection(artistsCollection)
          .doc(artistId)
          .get();

      if (!doc.exists) return null;

      final data = doc.data()!;
      return Artist(
        id: doc.id,
        name: data['name'] ?? '',
        craftType: data['craftType'] ?? '',
        location: data['location'] ?? '',
        profilePhoto: data['profilePhoto'] ?? '',
        rating: (data['rating'] ?? 0.0).toDouble(),
        reviewCount: data['reviewCount'] ?? 0,
      );
    } catch (e) {
      throw Exception('Failed to get artist: $e');
    }
  }

  /// Get all products for an artist
  Future<List<Product>> getProductsByArtist(String artistId) async {
    try {
      final querySnapshot = await _firestore
          .collection(productsCollection)
          .where('artistId', isEqualTo: artistId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Product(
          id: doc.id,
          name: data['name'] ?? '',
          price: (data['price'] ?? 0.0).toDouble(),
          imageUrl: data['imageUrl'] ?? '',
          inStock: data['inStock'] ?? true,
          description: data['description'] ?? '',
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  /// Get all products (for testing)
  Future<List<Product>> getAllProducts() async {
    try {
      final querySnapshot = await _firestore
          .collection(productsCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Product(
          id: doc.id,
          name: data['name'] ?? '',
          price: (data['price'] ?? 0.0).toDouble(),
          imageUrl: data['imageUrl'] ?? '',
          inStock: data['inStock'] ?? true,
          description: data['description'] ?? '',
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get all products: $e');
    }
  }

  /// Stream products for real-time updates
  Stream<List<Product>> streamProductsByArtist(String artistId) {
    return _firestore
        .collection(productsCollection)
        .where('artistId', isEqualTo: artistId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Product(
          id: doc.id,
          name: data['name'] ?? '',
          price: (data['price'] ?? 0.0).toDouble(),
          imageUrl: data['imageUrl'] ?? '',
          inStock: data['inStock'] ?? true,
          description: data['description'] ?? '',
        );
      }).toList();
    });
  }

  /// Add a new product
  Future<String> addProduct(Product product, String artistId) async {
    try {
      final data = product.toMap();
      data['artistId'] = artistId;
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();

      final docRef = await _firestore.collection(productsCollection).add(data);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  /// Update an existing product
  Future<void> updateProduct(String productId, Product product) async {
    try {
      final data = product.toMap();
      data['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore
          .collection(productsCollection)
          .doc(productId)
          .update(data);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  /// Delete a product
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore
          .collection(productsCollection)
          .doc(productId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  /// Get a single product by ID
  Future<Product?> getProduct(String productId) async {
    try {
      final doc = await _firestore
          .collection(productsCollection)
          .doc(productId)
          .get();

      if (!doc.exists) return null;

      return Product.fromMap(doc.id, doc.data()!);
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  /// Add sample data to Firestore (for testing)
  Future<void> addSampleData() async {
    try {
      // Add sample artist
      final artistRef = await _firestore.collection(artistsCollection).add({
        'name': 'Rajesh Kumar',
        'craftType': 'Traditional Pottery',
        'location': 'Jaipur, Rajasthan',
        'profilePhoto': 'placeholder',
        'rating': 4.5,
        'reviewCount': 23,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final artistId = artistRef.id;

      // Add sample products
      final products = [
        {
          'artistId': artistId,
          'name': 'Handcrafted Clay Pot',
          'price': 450.0,
          'imageUrl': 'placeholder',
          'inStock': true,
          'description': 'Beautiful handcrafted clay pot with traditional designs',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'artistId': artistId,
          'name': 'Decorative Vase',
          'price': 850.0,
          'imageUrl': 'placeholder',
          'inStock': true,
          'description': 'Elegant decorative vase perfect for home decor',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'artistId': artistId,
          'name': 'Terracotta Bowl Set',
          'price': 1200.0,
          'imageUrl': 'placeholder',
          'inStock': false,
          'description': 'Set of 4 terracotta bowls with intricate patterns',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'artistId': artistId,
          'name': 'Clay Water Jug',
          'price': 350.0,
          'imageUrl': 'placeholder',
          'inStock': true,
          'description': 'Traditional clay water jug keeps water cool naturally',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'artistId': artistId,
          'name': 'Painted Flower Pot',
          'price': 550.0,
          'imageUrl': 'placeholder',
          'inStock': true,
          'description': 'Hand-painted flower pot with vibrant colors',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'artistId': artistId,
          'name': 'Ceramic Dinner Set',
          'price': 2500.0,
          'imageUrl': 'placeholder',
          'inStock': true,
          'description': 'Complete dinner set for 4 people',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'artistId': artistId,
          'name': 'Decorative Plate',
          'price': 650.0,
          'imageUrl': 'placeholder',
          'inStock': false,
          'description': 'Wall hanging decorative plate with traditional art',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'artistId': artistId,
          'name': 'Clay Lamp',
          'price': 250.0,
          'imageUrl': 'placeholder',
          'inStock': true,
          'description': 'Traditional clay lamp for festivals',
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      for (final product in products) {
        await _firestore.collection(productsCollection).add(product);
      }
    } catch (e) {
      throw Exception('Failed to add sample data: $e');
    }
  }
}
