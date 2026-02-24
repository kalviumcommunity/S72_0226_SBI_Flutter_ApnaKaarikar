# ApnaKaarikar - Digital Catalog for Local Artisans

Flutter mobile app for local artisans to showcase and sell their products.

## Features Implemented

### Day 6 - Core UI Foundation ✅
- Reusable widgets (CustomCard, CustomButton, CustomHeader)
- Theme configuration
- Loading, Empty, and Error states

### Day 7 - Artist Catalog Screen ✅
- Artist profile header
- Product grid (2 columns)
- Stateless product cards
- Mock data integration

### Day 8 - Product Detail Screen ✅
- Product details display
- Quantity selector
- Dynamic price calculation
- Buy/Reserve CTAs
- Navigation from catalog

### Day 9 - Navigation & Routes ✅
- Named routes configuration
- Route generator with error handling
- Smooth page transitions (Slide, Fade, Scale)
- Navigation helper utility
- Centralized route management

### Day 10 - Firestore Integration ✅
- Firebase Core setup
- Firestore service implementation
- Read products from Firestore
- Real-time data streaming
- Mock data fallback for development
- Sample data seeding function

## Getting Started

### Prerequisites
- Flutter SDK (3.10.8 or higher)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator (for macOS) or Android Emulator

### Installation

1. Navigate to the client folder:
```bash
cd client
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# For Android
flutter run -d android

# For iOS (macOS only)
flutter run -d ios

# For Web
flutter run -d chrome

# For Windows
flutter run -d windows
```

## Project Structure

```
client/lib/
├── main.dart                      # App entry point
├── models/
│   ├── artist.dart               # Artist data model
│   └── product.dart              # Product data model
├── screens/
│   ├── artist_catalog_screen.dart  # Catalog screen
│   ├── product_detail_screen.dart  # Detail screen
│   └── home_screen.dart           # Demo screen
├── widgets/
│   ├── custom_card.dart          # Reusable card
│   ├── custom_button.dart        # Reusable button
│   ├── custom_header.dart        # Reusable header
│   ├── product_card.dart         # Product card
│   ├── artist_header.dart        # Artist header
│   ├── loading_indicator.dart    # Loading state
│   ├── empty_state.dart          # Empty state
│   └── error_state.dart          # Error state
└── utils/
    ├── app_theme.dart            # Theme config
    ├── constants.dart            # App constants
    ├── app_routes.dart           # Route configuration
    ├── page_transitions.dart     # Custom transitions
    └── navigation_helper.dart    # Navigation utilities
```

## Firebase Setup

The app is configured to work with or without Firebase:

### Development Mode (Default)
- Uses mock data
- No Firebase configuration needed
- All features work offline

### Production Mode (With Firebase)
1. Follow the [Firebase Setup Guide](FIREBASE_SETUP.md)
2. Configure Firebase in your project
3. Update `firebase_service.dart` with your credentials
4. Set `_useMockData = false` in `artist_catalog_screen.dart`

See [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for detailed instructions.

---

1. **Artist Catalog Screen** - Browse products from an artisan
2. **Tap Product Card** - Navigate to product details
3. **Product Detail Screen** - View details, adjust quantity
4. **Buy/Reserve** - Take action (currently shows snackbar)

## Mock Data

### Artist
- Name: Rajesh Kumar
- Craft: Traditional Pottery
- Location: Jaipur, Rajasthan
- Rating: 4.5 ⭐ (23 reviews)

### Products (8 items)
- Handcrafted Clay Pot - ₹450
- Decorative Vase - ₹850
- Terracotta Bowl Set - ₹1200 (Sold Out)
- Clay Water Jug - ₹350
- Painted Flower Pot - ₹550
- Ceramic Dinner Set - ₹2500
- Decorative Plate - ₹650 (Sold Out)
- Clay Lamp - ₹250

## Next Steps

- Day 9: Navigation & Routes
- Day 10: Firebase Integration
- Day 11: Authentication
- Day 12: Product CRUD
- Day 13: Image Upload

## Testing

Run tests:
```bash
flutter test
```

## Troubleshooting

### Common Issues

1. **Dependencies not found**
   ```bash
   flutter pub get
   flutter clean
   flutter pub get
   ```

2. **Build errors**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

3. **Hot reload not working**
   - Press 'r' in terminal for hot reload
   - Press 'R' for hot restart

## License

Private project for educational purposes.
