import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/artist.dart';
import '../widgets/custom_button.dart';

/// Product Detail Screen (Stateful)
/// Conversion-focused screen with product details and CTAs
class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final Artist artist;

  const ProductDetailScreen({
    Key? key,
    required this.product,
    required this.artist,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _onBuyNow() {
    if (!widget.product.inStock) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Buying ${widget.product.name} (Qty: $_quantity)',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _onReserve() {
    if (!widget.product.inStock) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Reserved ${widget.product.name} (Qty: $_quantity)',
        ),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _onShare() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share product via WhatsApp'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _onShare,
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  _buildProductImage(),
                  
                  // Product Details
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        Text(
                          widget.product.name,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        
                        // Price
                        Text(
                          '₹${widget.product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        
                        // Stock Status
                        _buildStockStatus(),
                        const SizedBox(height: 16.0),
                        
                        // Divider
                        const Divider(),
                        const SizedBox(height: 16.0),
                        
                        // Description
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          widget.product.description,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        
                        // Quantity Selector (only if in stock)
                        if (widget.product.inStock) ...[
                          _buildQuantitySelector(),
                          const SizedBox(height: 24.0),
                        ],
                        
                        // Artist Info Card
                        _buildArtistCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom CTA Bar
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: double.infinity,
      height: 300.0,
      color: Colors.grey[200],
      child: widget.product.imageUrl.startsWith('http')
          ? Image.network(
              widget.product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildImagePlaceholder();
              },
            )
          : _buildImagePlaceholder(),
    );
  }

  Widget _buildImagePlaceholder() {
    return Center(
      child: Icon(
        Icons.image,
        size: 80.0,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildStockStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 6.0,
      ),
      decoration: BoxDecoration(
        color: widget.product.inStock ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: widget.product.inStock ? Colors.green : Colors.red,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.product.inStock ? Icons.check_circle : Icons.cancel,
            size: 16.0,
            color: widget.product.inStock ? Colors.green[700] : Colors.red[700],
          ),
          const SizedBox(width: 6.0),
          Text(
            widget.product.inStock ? 'In Stock' : 'Sold Out',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: widget.product.inStock ? Colors.green[700] : Colors.red[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quantity',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12.0),
        Row(
          children: [
            // Decrement Button
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _quantity > 1 ? _decrementQuantity : null,
                color: _quantity > 1 ? Colors.black : Colors.grey,
              ),
            ),
            
            // Quantity Display
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                '$_quantity',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Increment Button
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: _incrementQuantity,
                color: Colors.black,
              ),
            ),
            
            const Spacer(),
            
            // Total Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '₹${(widget.product.price * _quantity).toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArtistCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Artist Photo
          CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.grey[300],
            child: Icon(
              Icons.person,
              size: 30.0,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 16.0),
          
          // Artist Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Artisan',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  widget.artist.name,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  widget.artist.craftType,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // View Profile Button
          Icon(
            Icons.arrow_forward_ios,
            size: 16.0,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Reserve Button
            Expanded(
              child: CustomButton(
                text: 'Reserve',
                onPressed: widget.product.inStock ? _onReserve : null,
                backgroundColor: Colors.orange,
                icon: Icons.bookmark_outline,
              ),
            ),
            const SizedBox(width: 12.0),
            
            // Buy Now Button
            Expanded(
              child: CustomButton(
                text: 'Buy Now',
                onPressed: widget.product.inStock ? _onBuyNow : null,
                backgroundColor: Colors.green,
                icon: Icons.shopping_cart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
