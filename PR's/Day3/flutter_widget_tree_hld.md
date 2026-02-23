# High-Level Design (HLD) - Flutter Widget Tree
## ApnaKaarikar - Digital Catalog for Local Artisans

---

## Application Architecture Overview

```
┌─────────────────────────────────────────────────┐
│              MyApp (MaterialApp)                │
│                                                 │
│  ┌───────────────────────────────────────────┐ │
│  │         Theme Configuration               │ │
│  │         Navigation Routes                 │ │
│  │         Global State Providers            │ │
│  └───────────────────────────────────────────┘ │
└─────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────┐
│              Screen Layer                       │
│  - Artist Catalog Screen                        │
│  - Product Detail Screen                        │
│  - Artist Login Screen                          │
│  - Add/Edit Product Screen                      │
│  - Order Confirmation Screen                    │
└─────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────┐
│           Reusable Widget Layer                 │
│  - ProductCard                                  │
│  - ArtistHeader                                 │
│  - CustomButton                                 │
│  - LoadingIndicator                             │
│  - EmptyState                                   │
└─────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────┐
│              Service Layer                      │
│  - Firebase Auth Service                        │
│  - Firestore Service                            │
│  - Storage Service                              │
│  - WhatsApp Share Service                       │
└─────────────────────────────────────────────────┘
```

---

## Widget Tree Hierarchy

### Root Level
```
MyApp (StatelessWidget)
└── MaterialApp
    ├── theme: ThemeData
    ├── routes: Map<String, WidgetBuilder>
    └── home: ArtistCatalogScreen
```

---

## Screen-Level Widget Trees

### 1. Artist Catalog Screen
```
ArtistCatalogScreen (StatefulWidget)
└── Scaffold
    ├── AppBar
    │   ├── leading: BackButton
    │   ├── title: Text("Artist Catalog")
    │   └── actions: [ShareButton]
    │
    └── body: FutureBuilder<List<Product>>
        ├── loading: LoadingIndicator
        ├── error: ErrorState
        ├── empty: EmptyState
        └── success: CustomScrollView
            ├── SliverToBoxAdapter
            │   └── ArtistHeader (Stateless)
            │       ├── CircleAvatar (profile photo)
            │       ├── Text (artist name)
            │       ├── Text (craft type)
            │       ├── Row (location icon + text)
            │       └── Row (rating stars + count)
            │
            └── SliverGrid
                └── ProductCard (Stateless) × N
                    ├── GestureDetector
                    ├── Card
                    │   ├── CachedNetworkImage
                    │   ├── Text (product name)
                    │   ├── Text (price)
                    │   └── Container (stock badge)
                    └── onTap: → ProductDetailScreen
```

### 2. Product Detail Screen
```
ProductDetailScreen (StatefulWidget)
└── Scaffold
    ├── AppBar
    │   ├── leading: BackButton
    │   └── actions: [ShareButton]
    │
    └── body: SingleChildScrollView
        ├── Hero
        │   └── CachedNetworkImage (product image)
        │
        ├── Padding
        │   ├── Text (product name)
        │   ├── Text (price)
        │   ├── Text (description)
        │   ├── Row (stock status)
        │   └── ArtistMiniCard
        │
        └── bottomNavigationBar: Container
            ├── CustomButton ("Buy Now")
            └── CustomButton ("Reserve")
```

### 3. Artist Login Screen
```
ArtistLoginScreen (StatefulWidget)
└── Scaffold
    ├── AppBar
    │   └── title: Text("Artist Login")
    │
    └── body: Padding
        └── Form
            ├── TextFormField (email)
            ├── TextFormField (password)
            ├── CustomButton ("Login")
            └── TextButton ("Forgot Password?")
```

### 4. Add/Edit Product Screen
```
AddEditProductScreen (StatefulWidget)
└── Scaffold
    ├── AppBar
    │   ├── leading: BackButton
    │   └── title: Text("Add Product")
    │
    └── body: SingleChildScrollView
        └── Form
            ├── GestureDetector (image picker)
            │   └── ImagePreview
            ├── TextFormField (product name)
            ├── TextFormField (price)
            ├── TextFormField (description)
            ├── DropdownButton (category)
            ├── SwitchListTile (in stock)
            └── CustomButton ("Save Product")
```

### 5. Order Confirmation Screen
```
OrderConfirmationScreen (StatelessWidget)
└── Scaffold
    ├── AppBar
    │   └── title: Text("Order Placed")
    │
    └── body: Center
        └── Column
            ├── Icon (success checkmark)
            ├── Text ("Order Confirmed!")
            ├── Text (order details)
            └── CustomButton ("Back to Catalog")
```

---

## Reusable Widget Components

### ProductCard (Stateless)
```dart
ProductCard
├── Card
│   └── Column
│       ├── AspectRatio (1:1)
│       │   └── CachedNetworkImage
│       ├── Padding
│       │   ├── Text (name, maxLines: 2)
│       │   ├── Text (price, bold)
│       │   └── Container (stock badge)
│       └── GestureDetector (onTap)
```

### ArtistHeader (Stateless)
```dart
ArtistHeader
└── Container
    └── Column
        ├── CircleAvatar (80x80)
        ├── Text (artist name, 20sp bold)
        ├── Text (craft type, 14sp gray)
        ├── Row
        │   ├── Icon (location)
        │   └── Text (location)
        └── Row
            ├── Icon (star) × 5
            └── Text (rating count)
```

### CustomButton (Stateless)
```dart
CustomButton
└── ElevatedButton
    ├── style: ButtonStyle
    ├── onPressed: VoidCallback
    └── child: Text
```

### LoadingIndicator (Stateless)
```dart
LoadingIndicator
└── Center
    └── CircularProgressIndicator
```

### EmptyState (Stateless)
```dart
EmptyState
└── Center
    └── Column
        ├── Icon (empty box)
        ├── Text (message)
        └── CustomButton (optional action)
```

### ErrorState (Stateless)
```dart
ErrorState
└── Center
    └── Column
        ├── Icon (error)
        ├── Text (error message)
        └── CustomButton ("Retry")
```

---

## State Management Strategy

### Screen-Level State (setState)
- **ArtistCatalogScreen**: Product list, loading state
- **ProductDetailScreen**: Product details, quantity
- **AddEditProductScreen**: Form fields, image selection
- **ArtistLoginScreen**: Form fields, auth state

### Global State (Future: Provider/Riverpod)
- User authentication state
- Current artist profile
- Cart items (if needed)

### Local Widget State
- Form validation
- UI interactions (expanded/collapsed)
- Temporary selections

---

## Navigation Architecture

### Route Definitions
```dart
routes: {
  '/': (context) => ArtistCatalogScreen(),
  '/product-detail': (context) => ProductDetailScreen(),
  '/login': (context) => ArtistLoginScreen(),
  '/add-product': (context) => AddEditProductScreen(),
  '/edit-product': (context) => AddEditProductScreen(),
  '/order-confirmation': (context) => OrderConfirmationScreen(),
}
```

### Navigation Flow
```
ArtistCatalogScreen (/)
    ↓
    ├→ ProductDetailScreen (/product-detail)
    │   ↓
    │   └→ OrderConfirmationScreen (/order-confirmation)
    │
    ├→ ArtistLoginScreen (/login)
    │   ↓
    │   └→ AddEditProductScreen (/add-product)
    │
    └→ Share via WhatsApp (external)
```

---

## Widget Type Decisions

### Stateless Widgets
- ProductCard (pure UI, no internal state)
- ArtistHeader (display only)
- CustomButton (callback-based)
- EmptyState, ErrorState, LoadingIndicator
- OrderConfirmationScreen (display only)

### Stateful Widgets
- ArtistCatalogScreen (manages product list)
- ProductDetailScreen (manages quantity, actions)
- ArtistLoginScreen (form state, validation)
- AddEditProductScreen (form state, image picker)

---

## Performance Optimization Patterns

### 1. List Rendering
```dart
GridView.builder(
  itemCount: products.length,
  itemBuilder: (context, index) {
    return ProductCard(product: products[index]);
  },
)
```
- Use `.builder` constructors for lazy loading
- Only build visible items

### 2. Image Caching
```dart
CachedNetworkImage(
  imageUrl: product.imageUrl,
  placeholder: (context, url) => ShimmerPlaceholder(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

### 3. Scoped setState
```dart
// BAD: Rebuilds entire screen
setState(() { products = newProducts; });

// GOOD: Only rebuild affected widget
ProductCard extends StatefulWidget {
  setState(() { isLiked = !isLiked; });
}
```

### 4. const Constructors
```dart
const Text('Static Label')  // Reuses widget instance
const Icon(Icons.star)      // No rebuild needed
```

---

## Data Flow Architecture

```
UI Layer (Widgets)
    ↓ (user action)
Service Layer (Firebase calls)
    ↓ (async operation)
Firestore/Storage
    ↓ (data response)
Service Layer (data transformation)
    ↓ (setState/Provider)
UI Layer (rebuild with new data)
```

---

## Folder Structure

```
lib/
├── main.dart
├── screens/
│   ├── artist_catalog_screen.dart
│   ├── product_detail_screen.dart
│   ├── artist_login_screen.dart
│   ├── add_edit_product_screen.dart
│   └── order_confirmation_screen.dart
├── widgets/
│   ├── product_card.dart
│   ├── artist_header.dart
│   ├── custom_button.dart
│   ├── loading_indicator.dart
│   ├── empty_state.dart
│   └── error_state.dart
├── services/
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   ├── storage_service.dart
│   └── share_service.dart
├── models/
│   ├── artist.dart
│   ├── product.dart
│   └── order.dart
└── utils/
    ├── constants.dart
    ├── theme.dart
    └── validators.dart
```

---

## Key Architectural Decisions

1. **Stateless over Stateful**: Use stateless widgets wherever possible for better performance
2. **Builder Patterns**: Use ListView.builder, GridView.builder for efficient list rendering
3. **Separation of Concerns**: Keep business logic in services, UI in widgets
4. **Reusability**: Create small, focused, reusable widgets
5. **Async Handling**: Use FutureBuilder and StreamBuilder for Firebase data
6. **Navigation**: Named routes for better maintainability
7. **Theme Consistency**: Global theme configuration in MaterialApp

---

## Dependencies Required

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^latest
  firebase_auth: ^latest
  cloud_firestore: ^latest
  firebase_storage: ^latest
  cached_network_image: ^latest
  image_picker: ^latest
  share_plus: ^latest
  url_launcher: ^latest
```

---

## Next Steps (Day 4 - LLD)
- Widget-level breakdown with exact properties
- State management implementation details
- Form validation logic
- Error handling patterns
- Firebase integration specifics
