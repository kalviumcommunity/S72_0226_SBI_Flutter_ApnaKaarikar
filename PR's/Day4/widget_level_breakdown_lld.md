# Low-Level Design (LLD) - Widget-Level Breakdown
## ApnaKaarikar - Detailed Implementation Specifications

---

## 1. ARTIST CATALOG SCREEN

### ArtistCatalogScreen (StatefulWidget)

#### File: `lib/screens/artist_catalog_screen.dart`

```dart
class ArtistCatalogScreen extends StatefulWidget {
  final String artistId;
  
  const ArtistCatalogScreen({
    Key? key,
    required this.artistId,
  }) : super(key: key);

  @override
  State<ArtistCatalogScreen> createState() => _ArtistCatalogScreenState();
}

class _ArtistCatalogScreenState extends State<ArtistCatalogScreen> {
  // State Variables
  List<Product> _products = [];
  Artist? _artist;
  bool _isLoading = true;
  String? _errorMessage;
  
  // Services
  final FirestoreService _firestoreService = FirestoreService();
  final ShareService _shareService = ShareService();
  
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
      final artist = await _firestoreService.getArtist(widget.artistId);
      final products = await _firestoreService.getProductsByArtist(widget.artistId);
      
      setState(() {
        _artist = artist;
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }
  
  void _onProductTap(Product product) {
    Navigator.pushNamed(
      context,
      '/product-detail',
      arguments: product,
    );
  }
  
  void _onShareTap() {
    if (_artist != null) {
      _shareService.shareCatalog(_artist!);
    }
  }
  
  Future<void> _onRefresh() async {
    await _loadData();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(_artist?.name ?? 'Artist Catalog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _onShareTap,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  
  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingIndicator();
    }
    
    if (_errorMessage != null) {
      return ErrorState(
        message: _errorMessage!,
        onRetry: _loadData,
      );
    }
    
    if (_products.isEmpty) {
      return const EmptyState(
        message: 'No products available yet',
      );
    }
    
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ArtistHeader(artist: _artist!),
          ),
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
                    onTap: () => _onProductTap(_products[index]),
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
}
```

#### Widget Properties:
- **Type**: StatefulWidget
- **State Variables**: `_products`, `_artist`, `_isLoading`, `_errorMessage`
- **Lifecycle**: initState → _loadData → setState → build
- **Rebuild Triggers**: Data loading, refresh, navigation back

---

## 2. PRODUCT CARD (Reusable Widget)

### ProductCard (StatelessWidget)

#### File: `lib/widgets/product_card.dart`

```dart
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  
  const ProductCard({
    Key? key,
    required this.product,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8.0),
                ),
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            // Product Details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '₹${product.price}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  _buildStockBadge(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStockBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: product.inStock ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        product.inStock ? 'In Stock' : 'Sold Out',
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          color: product.inStock ? Colors.green[700] : Colors.red[700],
        ),
      ),
    );
  }
}
```

#### Widget Properties:
- **Type**: StatelessWidget (pure UI, no internal state)
- **Required Props**: `product`, `onTap`
- **Rebuild**: Only when parent passes new product data
- **Performance**: const constructor, efficient rendering

---

## 3. ARTIST HEADER (Reusable Widget)

### ArtistHeader (StatelessWidget)

#### File: `lib/widgets/artist_header.dart`

```dart
class ArtistHeader extends StatelessWidget {
  final Artist artist;
  
  const ArtistHeader({
    Key? key,
    required this.artist,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Photo
          CircleAvatar(
            radius: 40.0,
            backgroundImage: CachedNetworkImageProvider(
              artist.profilePhoto,
            ),
            backgroundColor: Colors.grey[200],
          ),
          const SizedBox(height: 12.0),
          // Artist Name
          Text(
            artist.name,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          // Craft Type
          Text(
            artist.craftType,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8.0),
          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: 16.0,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4.0),
              Text(
                artist.location,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          // Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < artist.rating.floor()
                      ? Icons.star
                      : Icons.star_border,
                  size: 16.0,
                  color: Colors.amber,
                );
              }),
              const SizedBox(width: 8.0),
              Text(
                '${artist.rating} (${artist.reviewCount} reviews)',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

#### Widget Properties:
- **Type**: StatelessWidget
- **Required Props**: `artist`
- **No State**: Pure display component
- **Reusable**: Can be used in multiple screens

---

## 4. PRODUCT DETAIL SCREEN

### ProductDetailScreen (StatefulWidget)

#### File: `lib/screens/product_detail_screen.dart`

```dart
class ProductDetailScreen extends StatefulWidget {
  final Product product;
  
  const ProductDetailScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // State Variables
  int _quantity = 1;
  bool _isProcessing = false;
  
  // Services
  final FirestoreService _firestoreService = FirestoreService();
  final ShareService _shareService = ShareService();
  
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
  
  Future<void> _onBuyNow() async {
    if (!widget.product.inStock) return;
    
    setState(() {
      _isProcessing = true;
    });
    
    try {
      await _firestoreService.createOrder(
        productId: widget.product.id,
        quantity: _quantity,
      );
      
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/order-confirmation',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
  
  void _onShare() {
    _shareService.shareProduct(widget.product);
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Hero(
              tag: 'product-${widget.product.id}',
              child: CachedNetworkImage(
                imageUrl: widget.product.imageUrl,
                width: double.infinity,
                height: 300.0,
                fit: BoxFit.cover,
              ),
            ),
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
                    '₹${widget.product.price}',
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
                  // Quantity Selector
                  if (widget.product.inStock) _buildQuantitySelector(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
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
      ),
      child: Text(
        widget.product.inStock ? 'In Stock' : 'Sold Out',
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: widget.product.inStock ? Colors.green[700] : Colors.red[700],
        ),
      ),
    );
  }
  
  Widget _buildQuantitySelector() {
    return Row(
      children: [
        const Text(
          'Quantity:',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 16.0),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: _decrementQuantity,
        ),
        Text(
          '$_quantity',
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: _incrementQuantity,
        ),
      ],
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
            blurRadius: 4.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: 'Reserve',
              onPressed: widget.product.inStock && !_isProcessing
                  ? _onBuyNow
                  : null,
              backgroundColor: Colors.orange,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: CustomButton(
              text: _isProcessing ? 'Processing...' : 'Buy Now',
              onPressed: widget.product.inStock && !_isProcessing
                  ? _onBuyNow
                  : null,
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
```

#### Widget Properties:
- **Type**: StatefulWidget
- **State Variables**: `_quantity`, `_isProcessing`
- **Stateful Reason**: Manages quantity selection and order processing
- **Rebuild Triggers**: Quantity change, order processing state

---

## 5. CUSTOM BUTTON (Reusable Widget)

### CustomButton (StatelessWidget)

#### File: `lib/widgets/custom_button.dart`

```dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final bool isLoading;
  
  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 48.0,
    this.isLoading = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 2.0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? Colors.white,
                ),
              ),
      ),
    );
  }
}
```

#### Widget Properties:
- **Type**: StatelessWidget
- **Required Props**: `text`
- **Optional Props**: `onPressed`, `backgroundColor`, `textColor`, `width`, `height`, `isLoading`
- **Reusable**: Used across all screens for consistent button styling

---

## 6. LOADING INDICATOR (Reusable Widget)

### LoadingIndicator (StatelessWidget)

#### File: `lib/widgets/loading_indicator.dart`

```dart
class LoadingIndicator extends StatelessWidget {
  final String? message;
  
  const LoadingIndicator({
    Key? key,
    this.message,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16.0),
            Text(
              message!,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
```

#### Widget Properties:
- **Type**: StatelessWidget
- **Optional Props**: `message`
- **Usage**: Display during async operations

---

## 7. EMPTY STATE (Reusable Widget)

### EmptyState (StatelessWidget)

#### File: `lib/widgets/empty_state.dart`

```dart
class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionText;
  
  const EmptyState({
    Key? key,
    required this.message,
    this.icon = Icons.inbox,
    this.onAction,
    this.actionText,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80.0,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16.0),
            Text(
              message,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionText != null) ...[
              const SizedBox(height: 24.0),
              CustomButton(
                text: actionText!,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

#### Widget Properties:
- **Type**: StatelessWidget
- **Required Props**: `message`
- **Optional Props**: `icon`, `onAction`, `actionText`
- **Usage**: Display when lists are empty

---

## 8. ERROR STATE (Reusable Widget)

### ErrorState (StatelessWidget)

#### File: `lib/widgets/error_state.dart`

```dart
class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  
  const ErrorState({
    Key? key,
    required this.message,
    required this.onRetry,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80.0,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Oops! Something went wrong',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),
            CustomButton(
              text: 'Retry',
              onPressed: onRetry,
              backgroundColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
```

#### Widget Properties:
- **Type**: StatelessWidget
- **Required Props**: `message`, `onRetry`
- **Usage**: Display when errors occur

---

## 9. ARTIST LOGIN SCREEN

### ArtistLoginScreen (StatefulWidget)

#### File: `lib/screens/artist_login_screen.dart`

```dart
class ArtistLoginScreen extends StatefulWidget {
  const ArtistLoginScreen({Key? key}) : super(key: key);

  @override
  State<ArtistLoginScreen> createState() => _ArtistLoginScreenState();
}

class _ArtistLoginScreenState extends State<ArtistLoginScreen> {
  // Form Key
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // State Variables
  bool _isLoading = false;
  bool _obscurePassword = true;
  
  // Services
  final AuthService _authService = AuthService();
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artist Login'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo or Title
                const Icon(
                  Icons.palette,
                  size: 80.0,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 32.0),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32.0),
                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                // Login Button
                CustomButton(
                  text: 'Login',
                  onPressed: _onLogin,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 16.0),
                // Forgot Password
                TextButton(
                  onPressed: () {
                    // TODO: Implement forgot password
                  },
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

#### Widget Properties:
- **Type**: StatefulWidget
- **State Variables**: `_isLoading`, `_obscurePassword`
- **Controllers**: `_emailController`, `_passwordController`
- **Form Key**: `_formKey` for validation
- **Stateful Reason**: Form state, validation, loading state

---

## 10. ADD/EDIT PRODUCT SCREEN

### AddEditProductScreen (StatefulWidget)

#### File: `lib/screens/add_edit_product_screen.dart`

```dart
class AddEditProductScreen extends StatefulWidget {
  final Product? product; // null for add, non-null for edit
  
  const AddEditProductScreen({
    Key? key,
    this.product,
  }) : super(key: key);

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  // Form Key
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  
  // State Variables
  File? _selectedImage;
  bool _inStock = true;
  bool _isLoading = false;
  String? _imageUrl;
  
  // Services
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();
  final ImagePicker _imagePicker = ImagePicker();
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    _inStock = widget.product?.inStock ?? true;
    _imageUrl = widget.product?.imageUrl;
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  
  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedImage == null && _imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      String imageUrl = _imageUrl ?? '';
      
      // Upload new image if selected
      if (_selectedImage != null) {
        imageUrl = await _storageService.uploadProductImage(_selectedImage!);
      }
      
      final productData = {
        'name': _nameController.text.trim(),
        'price': double.parse(_priceController.text),
        'description': _descriptionController.text.trim(),
        'imageUrl': imageUrl,
        'inStock': _inStock,
      };
      
      if (widget.product == null) {
        // Add new product
        await _firestoreService.addProduct(productData);
      } else {
        // Update existing product
        await _firestoreService.updateProduct(
          widget.product!.id,
          productData,
        );
      }
      
      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Product' : 'Add Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: _buildImagePreview(),
                ),
              ),
              const SizedBox(height: 16.0),
              // Product Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Price
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price (₹)',
                  border: OutlineInputBorder(),
                  prefixText: '₹ ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // In Stock Switch
              SwitchListTile(
                title: const Text('In Stock'),
                value: _inStock,
                onChanged: (value) {
                  setState(() {
                    _inStock = value;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24.0),
              // Save Button
              CustomButton(
                text: isEdit ? 'Update Product' : 'Add Product',
                onPressed: _onSave,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildImagePreview() {
    if (_selectedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
        ),
      );
    }
    
    if (_imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: CachedNetworkImage(
          imageUrl: _imageUrl!,
          fit: BoxFit.cover,
        ),
      );
    }
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate,
          size: 64.0,
          color: Colors.grey[600],
        ),
        const SizedBox(height: 8.0),
        Text(
          'Tap to select image',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
```

#### Widget Properties:
- **Type**: StatefulWidget
- **State Variables**: `_selectedImage`, `_inStock`, `_isLoading`, `_imageUrl`
- **Controllers**: `_nameController`, `_priceController`, `_descriptionController`
- **Form Key**: `_formKey` for validation
- **Stateful Reason**: Form state, image selection, validation

---

## WIDGET TYPE DECISION MATRIX

| Widget | Type | Reason | State Variables |
|--------|------|--------|----------------|
| ArtistCatalogScreen | Stateful | Manages product list, loading | `_products`, `_artist`, `_isLoading`, `_errorMessage` |
| ProductCard | Stateless | Pure UI, no internal state | None |
| ArtistHeader | Stateless | Display only | None |
| ProductDetailScreen | Stateful | Quantity selection, order processing | `_quantity`, `_isProcessing` |
| CustomButton | Stateless | Callback-based | None |
| LoadingIndicator | Stateless | Display only | None |
| EmptyState | Stateless | Display only | None |
| ErrorState | Stateless | Display only | None |
| ArtistLoginScreen | Stateful | Form state, validation | `_isLoading`, `_obscurePassword` |
| AddEditProductScreen | Stateful | Form state, image selection | `_selectedImage`, `_inStock`, `_isLoading` |
| OrderConfirmationScreen | Stateless | Display only | None |

---

## STATE MANAGEMENT RULES

### When to use StatefulWidget:
1. Widget needs to track user input (forms, text fields)
2. Widget manages loading/processing states
3. Widget has interactive elements that change appearance
4. Widget needs to update based on async operations

### When to use StatelessWidget:
1. Widget only displays data passed from parent
2. Widget has no internal state to manage
3. Widget is purely presentational
4. Widget behavior is entirely callback-based

### setState Best Practices:
```dart
// ✅ GOOD: Scoped setState
class ProductCard extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isLiked = !isLiked; // Only rebuilds this card
        });
      },
    );
  }
}

// ❌ BAD: Full screen rebuild
class CatalogScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              products[index].isLiked = true; // Rebuilds entire list!
            });
          },
        );
      },
    );
  }
}
```

---

## LIFECYCLE METHODS USAGE

### initState()
- Initialize controllers
- Load initial data
- Set up listeners
```dart
@override
void initState() {
  super.initState();
  _controller = TextEditingController();
  _loadData();
}
```

### dispose()
- Clean up controllers
- Cancel subscriptions
- Remove listeners
```dart
@override
void dispose() {
  _controller.dispose();
  _subscription?.cancel();
  super.dispose();
}
```

### didChangeDependencies()
- Access inherited widgets
- React to route arguments
```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  final args = ModalRoute.of(context)!.settings.arguments;
}
```

---

## FORM VALIDATION PATTERNS

### Email Validator
```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Please enter a valid email';
  }
  return null;
}
```

### Price Validator
```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Please enter price';
  }
  final price = double.tryParse(value);
  if (price == null || price <= 0) {
    return 'Please enter a valid price';
  }
  return null;
}
```

### Required Field Validator
```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  }
  return null;
}
```

---

## ASYNC OPERATION PATTERNS

### Safe setState Pattern
```dart
Future<void> _loadData() async {
  setState(() {
    _isLoading = true;
  });
  
  try {
    final data = await _service.fetchData();
    
    if (mounted) {  // Check if widget is still in tree
      setState(() {
        _data = data;
        _isLoading = false;
      });
    }
  } catch (e) {
    if (mounted) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
}
```

### FutureBuilder Pattern
```dart
FutureBuilder<List<Product>>(
  future: _firestoreService.getProducts(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const LoadingIndicator();
    }
    
    if (snapshot.hasError) {
      return ErrorState(
        message: snapshot.error.toString(),
        onRetry: () => setState(() {}),
      );
    }
    
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const EmptyState(message: 'No products found');
    }
    
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        return ProductCard(product: snapshot.data![index]);
      },
    );
  },
)
```

---

## PERFORMANCE OPTIMIZATION CHECKLIST

- [ ] Use `const` constructors wherever possible
- [ ] Use `.builder` constructors for lists (ListView.builder, GridView.builder)
- [ ] Implement `CachedNetworkImage` for all network images
- [ ] Scope `setState` to smallest widget possible
- [ ] Dispose controllers in `dispose()` method
- [ ] Use `RepaintBoundary` for complex widgets
- [ ] Implement `AutomaticKeepAliveClientMixin` for tabs
- [ ] Use `ValueKey` for list items that can be reordered
- [ ] Avoid rebuilding entire screens, rebuild only changed widgets
- [ ] Use `FutureBuilder` or `StreamBuilder` for async data

---

## IMPLEMENTATION CHECKLIST

### Day 5-6: Setup & Foundation
- [ ] Create folder structure
- [ ] Implement theme configuration
- [ ] Create all model classes
- [ ] Implement reusable widgets (CustomButton, LoadingIndicator, etc.)

### Day 7-8: Static Screens
- [ ] Implement ArtistCatalogScreen with mock data
- [ ] Implement ProductDetailScreen with mock data
- [ ] Test navigation between screens

### Day 9: Navigation
- [ ] Set up named routes
- [ ] Implement route arguments passing
- [ ] Test all navigation flows

### Day 10-11: Firebase Integration
- [ ] Connect ArtistCatalogScreen to Firestore
- [ ] Implement ArtistLoginScreen
- [ ] Test authentication flow

### Day 12-13: CRUD & Storage
- [ ] Implement AddEditProductScreen
- [ ] Connect image upload to Firebase Storage
- [ ] Test product creation and updates

---

## NEXT STEPS

This LLD provides complete implementation details. Developers can now:
1. Start coding without confusion
2. Know exactly which widgets are Stateful vs Stateless
3. Understand state management approach
4. Follow consistent patterns across the app
5. Implement proper error handling and validation
