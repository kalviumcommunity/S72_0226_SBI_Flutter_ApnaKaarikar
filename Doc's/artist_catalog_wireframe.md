# Artist Catalog Screen - Wireframe (Day 2)

## Screen Purpose
The Artist Catalog Screen is the main browsing interface where buyers can view all products from a specific artisan. This is the core discovery screen that drives conversions.

---

## Screen Layout

```
┌─────────────────────────────────────┐
│  ← Back    Artist Catalog    Share  │  ← AppBar
├─────────────────────────────────────┤
│                                     │
│  ┌───────────────────────────────┐ │
│  │   [Artist Profile Photo]      │ │  ← Artist Header
│  │                               │ │
│  │   Artist Name                 │ │
│  │   Craft Type (e.g., Pottery)  │ │
│  │   Location                    │ │
│  │   ⭐ 4.5 (23 reviews)         │ │
│  └───────────────────────────────┘ │
│                                     │
│  ┌─────────────┐  ┌─────────────┐ │
│  │   Product   │  │   Product   │ │  ← Product Grid
│  │   Image     │  │   Image     │ │
│  │             │  │             │ │
│  │  Name       │  │  Name       │ │
│  │  ₹ Price    │  │  ₹ Price    │ │
│  │  [In Stock] │  │  [Sold Out] │ │
│  └─────────────┘  └─────────────┘ │
│                                     │
│  ┌─────────────┐  ┌─────────────┐ │
│  │   Product   │  │   Product   │ │
│  │   Image     │  │   Image     │ │
│  │             │  │             │ │
│  │  Name       │  │  Name       │ │
│  │  ₹ Price    │  │  ₹ Price    │ │
│  │  [In Stock] │  │  [In Stock] │ │
│  └─────────────┘  └─────────────┘ │
│                                     │
│         ... more products ...       │
│                                     │
└─────────────────────────────────────┘
```

---

## Component Breakdown

### 1. AppBar
- **Back Button**: Navigate to previous screen
- **Title**: "Artist Catalog" or Artist Name
- **Share Button**: Share entire catalog via WhatsApp

### 2. Artist Header Section
- **Profile Photo**: Circular avatar (80x80)
- **Artist Name**: Bold, 20sp
- **Craft Type**: Subtitle, 14sp, gray
- **Location**: Icon + text, 12sp
- **Rating**: Star icon + rating number + review count

### 3. Product Grid (2 columns)
Each Product Card contains:
- **Product Image**: Square aspect ratio (1:1)
- **Product Name**: 2 lines max, ellipsis
- **Price**: Bold, ₹ symbol
- **Stock Status**: Badge (Green "In Stock" / Red "Sold Out")
- **Tap Action**: Navigate to Product Detail Screen

---

## User Interactions

1. **Tap Product Card** → Navigate to Product Detail Screen
2. **Tap Share Button** → Open WhatsApp share with catalog link
3. **Tap Back Button** → Return to previous screen
4. **Scroll** → Load more products (if pagination needed)
5. **Pull to Refresh** → Reload catalog data

---

## States to Handle

### Loading State
```
┌─────────────────────────────────────┐
│  ← Back    Artist Catalog    Share  │
├─────────────────────────────────────┤
│                                     │
│         [Shimmer Effect]            │
│         Loading products...         │
│                                     │
└─────────────────────────────────────┘
```

### Empty State
```
┌─────────────────────────────────────┐
│  ← Back    Artist Catalog    Share  │
├─────────────────────────────────────┤
│                                     │
│         [Empty Box Icon]            │
│    No products available yet        │
│                                     │
└─────────────────────────────────────┘
```

### Error State
```
┌─────────────────────────────────────┐
│  ← Back    Artist Catalog    Share  │
├─────────────────────────────────────┤
│                                     │
│         [Error Icon]                │
│    Failed to load products          │
│         [Retry Button]              │
│                                     │
└─────────────────────────────────────┘
```

---

## Data Requirements

### Artist Data
```dart
{
  "artistId": "string",
  "name": "string",
  "craftType": "string",
  "location": "string",
  "profilePhoto": "url",
  "rating": "number",
  "reviewCount": "number"
}
```

### Product Data (List)
```dart
{
  "productId": "string",
  "name": "string",
  "price": "number",
  "imageUrl": "string",
  "inStock": "boolean"
}
```

---

## Design Specifications

### Colors
- Primary: #6200EE (Purple)
- Background: #FFFFFF
- Text Primary: #000000
- Text Secondary: #757575
- Success (In Stock): #4CAF50
- Error (Sold Out): #F44336

### Spacing
- Screen padding: 16px
- Grid gap: 12px
- Card padding: 8px
- Header margin bottom: 16px

### Typography
- Artist Name: 20sp, Bold
- Craft Type: 14sp, Regular
- Product Name: 14sp, Medium
- Price: 16sp, Bold
- Stock Status: 12sp, Medium

---

## Performance Considerations

1. **Image Loading**: Use cached network images
2. **List Performance**: Use GridView.builder for efficient rendering
3. **State Management**: Minimal rebuilds (only update changed items)
4. **Lazy Loading**: Load images as they appear in viewport

---

## Navigation Flow

```
Home/Search → Artist Catalog Screen → Product Detail Screen
                     ↓
              WhatsApp Share
```

---

## Future Enhancements (Post-MVP)
- Filter by price range
- Sort options (price, newest, popular)
- Search within catalog
- Favorite products
- Category tabs

---

## Notes for Implementation (Day 7)
- Use ListView.builder or GridView.builder
- Stateless ProductCard widget
- Separate Artist Header as reusable widget
- Mock data first, then connect to Firestore (Day 10)
