/// Product model
class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final bool inStock;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.inStock,
    required this.description,
  });
}
