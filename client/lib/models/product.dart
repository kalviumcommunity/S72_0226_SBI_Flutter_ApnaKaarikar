/// Product model
class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final bool inStock;
  final String description;
  final String? artistId;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.inStock,
    required this.description,
    this.artistId,
  });

  /// Create Product from Firestore map
  factory Product.fromMap(String id, Map<String, dynamic> data) {
    return Product(
      id: id,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      inStock: data['inStock'] ?? true,
      description: data['description'] ?? '',
      artistId: data['artistId'],
    );
  }

  /// Convert Product to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'inStock': inStock,
      'description': description,
      if (artistId != null) 'artistId': artistId,
    };
  }

  /// Create a copy with updated fields
  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    bool? inStock,
    String? description,
    String? artistId,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      inStock: inStock ?? this.inStock,
      description: description ?? this.description,
      artistId: artistId ?? this.artistId,
    );
  }
}
