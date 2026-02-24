# Navigation Guide - ApnaKaarikar

## Overview

The app uses a centralized navigation system with named routes, custom transitions, and a navigation helper utility for type-safe navigation.

---

## Architecture

### 1. Route Configuration (`lib/utils/app_routes.dart`)

Centralized route definitions and route generator:

```dart
class AppRoutes {
  static const String home = '/';
  static const String artistCatalog = '/artist-catalog';
  static const String productDetail = '/product-detail';
  static const String demo = '/demo';
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Route generation logic
  }
}
```

### 2. Page Transitions (`lib/utils/page_transitions.dart`)

Custom animated transitions:

- **SlideRightRoute** - Slides in from right (used for detail screens)
- **FadeRoute** - Fades in (used for main screens)
- **ScaleRoute** - Scales up with fade (available for future use)

### 3. Navigation Helper (`lib/utils/navigation_helper.dart`)

Type-safe navigation methods:

```dart
class NavigationHelper {
  static Future<void> toProductDetail(context, {product, artist})
  static Future<void> toArtistCatalog(context)
  static Future<void> toHome(context)
  static void goBack(context)
  // ... more methods
}
```

---

## Routes

### Home Route (`/`)
- **Screen:** ArtistCatalogScreen
- **Transition:** Material default
- **Description:** Main landing screen showing artist catalog

### Artist Catalog Route (`/artist-catalog`)
- **Screen:** ArtistCatalogScreen
- **Transition:** Fade
- **Description:** Browse artist products

### Product Detail Route (`/product-detail`)
- **Screen:** ProductDetailScreen
- **Transition:** Slide from right
- **Arguments:** ProductDetailArguments (product, artist)
- **Description:** View product details and purchase

### Demo Route (`/demo`)
- **Screen:** HomeScreen
- **Transition:** Fade
- **Description:** UI component demo

---

## Usage Examples

### Basic Navigation

```dart
// Navigate to product detail
NavigationHelper.toProductDetail(
  context,
  product: selectedProduct,
  artist: currentArtist,
);

// Navigate to artist catalog
NavigationHelper.toArtistCatalog(context);

// Go back
NavigationHelper.goBack(context);
```

### Advanced Navigation

```dart
// Replace current route
NavigationHelper.replaceWithHome(context);

// Clear stack and go home
NavigationHelper.clearAndGoHome(context);

// Using named routes directly
Navigator.pushNamed(
  context,
  AppRoutes.productDetail,
  arguments: ProductDetailArguments(
    product: product,
    artist: artist,
  ),
);
```

---

## Route Arguments

### ProductDetailArguments

Used when navigating to product detail screen:

```dart
class ProductDetailArguments {
  final Product product;
  final Artist artist;
  
  ProductDetailArguments({
    required this.product,
    required this.artist,
  });
}
```

**Usage:**
```dart
Navigator.pushNamed(
  context,
  AppRoutes.productDetail,
  arguments: ProductDetailArguments(
    product: myProduct,
    artist: myArtist,
  ),
);
```

---

## Error Handling

### Invalid Routes

If a route doesn't exist, the app shows an error screen:

```dart
Scaffold(
  appBar: AppBar(title: Text('Error')),
  body: Center(
    child: Column(
      children: [
        Icon(Icons.error_outline, size: 80, color: Colors.red),
        Text('Route not found: /invalid-route'),
      ],
    ),
  ),
)
```

### Missing Arguments

If required arguments are missing:

```dart
if (args == null) {
  return _errorRoute('Product details not provided');
}
```

---

## Transitions

### Slide Right Transition

Used for detail screens (e.g., Product Detail):

```dart
SlideRightRoute(
  page: ProductDetailScreen(...),
)
```

- Duration: 300ms
- Curve: easeInOut
- Direction: Right to left

### Fade Transition

Used for main screens (e.g., Catalog):

```dart
FadeRoute(
  page: ArtistCatalogScreen(),
)
```

- Duration: 300ms
- Effect: Opacity 0 → 1

### Scale Transition

Available for future use:

```dart
ScaleRoute(
  page: SomeScreen(),
)
```

- Duration: 300ms
- Effect: Scale 0.8 → 1.0 with fade

---

## Best Practices

### 1. Use Navigation Helper

✅ **Good:**
```dart
NavigationHelper.toProductDetail(context, product: p, artist: a);
```

❌ **Avoid:**
```dart
Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(...)));
```

### 2. Type-Safe Arguments

✅ **Good:**
```dart
arguments: ProductDetailArguments(product: p, artist: a)
```

❌ **Avoid:**
```dart
arguments: {'product': p, 'artist': a}  // Untyped map
```

### 3. Check Navigation Possibility

```dart
if (Navigator.canPop(context)) {
  Navigator.pop(context);
}
```

### 4. Handle Async Navigation

```dart
final result = await NavigationHelper.toProductDetail(...);
if (result != null) {
  // Handle returned data
}
```

---

## Navigation Flow

```
App Start
    ↓
Home (Artist Catalog)
    ↓ (Tap Product)
Product Detail
    ↓ (Tap Buy/Reserve)
Order Confirmation (Future)
    ↓ (Complete)
Back to Catalog
```

---

## Adding New Routes

### Step 1: Define Route Name

```dart
// In app_routes.dart
class AppRoutes {
  static const String newScreen = '/new-screen';
}
```

### Step 2: Add to Route Generator

```dart
case newScreen:
  return FadeRoute(
    page: const NewScreen(),
  );
```

### Step 3: Add Navigation Helper Method

```dart
// In navigation_helper.dart
static Future<void> toNewScreen(BuildContext context) {
  return Navigator.pushNamed(context, AppRoutes.newScreen);
}
```

### Step 4: Use in App

```dart
NavigationHelper.toNewScreen(context);
```

---

## Testing Navigation

### Manual Testing

1. Launch app → Should show Artist Catalog
2. Tap product → Should slide to Product Detail
3. Tap back → Should return to Catalog
4. Test all navigation paths

### Automated Testing (Future)

```dart
testWidgets('Navigation test', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // Tap product card
  await tester.tap(find.byType(ProductCard).first);
  await tester.pumpAndSettle();
  
  // Verify navigation
  expect(find.byType(ProductDetailScreen), findsOneWidget);
});
```

---

## Troubleshooting

### Issue: Route not found

**Solution:** Check route name spelling in AppRoutes

### Issue: Arguments null

**Solution:** Ensure arguments are passed correctly

### Issue: Can't go back

**Solution:** Use `Navigator.canPop()` before `pop()`

### Issue: Transition not working

**Solution:** Verify transition is applied in route generator

---

## Summary

✅ Centralized route management
✅ Type-safe navigation
✅ Custom smooth transitions
✅ Error handling
✅ Easy to extend
✅ Maintainable code

The navigation system is production-ready and follows Flutter best practices!
