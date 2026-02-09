# Day-by-Day Task Plan (20 Days)
## Project: WhatsApp-Native Digital Catalog for Local Artisans
## Sprint #2 – Flutter & Firebase
## Team Split:
- Heramb – Frontend (Flutter UI, State, Performance)
- Piyush – Frontend (UI, Navigation, UX polish)
- Vaibhav – Backend (Firebase, Auth, Firestore, Storage)

---

## DAY 1 – PROBLEM LOCK & MVP FREEZE
**Goal:** No scope creep later.

- Heramb:
  - Convert problem statement into 1-paragraph app vision
  - Identify ONLY 3 core screens for MVP
- Piyush:
  - Draft rough user flow (Artist → Buyer)
- Vaibhav:
  - Finalize Firebase services to be used (Auth, Firestore, Storage)

**Deliverable:**  
✅ Final MVP feature list (frozen)

---

## DAY 2 – LOW-FID WIREFRAMES
**Goal:** Think before coding.

- Heramb:
  - Wireframe: Artist Catalog Screen
- Piyush:
  - Wireframe: Product Detail Screen
- Vaibhav:
  - Draft Firestore collections (artists, products, orders)

**Deliverable:**  
✅ Hand-drawn / Figma low-fi screens  
✅ Firestore schema v1

---

## DAY 3 – HIGH-LEVEL DESIGN (HLD)
**Goal:** Architecture clarity.

- Heramb:
  - Flutter widget tree (high-level)
- Piyush:
  - Navigation flow diagram
- Vaibhav:
  - Firebase architecture diagram

**Deliverable:**  
✅ HLD document

---

## DAY 4 – LOW-LEVEL DESIGN (LLD)
**Goal:** No confusion while coding.

- Heramb:
  - Widget-level breakdown (Stateless vs Stateful)
- Piyush:
  - Route definitions & screen responsibilities
- Vaibhav:
  - Firestore document fields & rules outline

**Deliverable:**  
✅ LLD document

---

## DAY 5 – FLUTTER PROJECT SETUP
**Goal:** Everyone runs the app.

- Heramb:
  - Flutter project init
  - Folder structure setup
- Piyush:
  - Theme setup (colors, fonts)
- Vaibhav:
  - Firebase project creation

**Deliverable:**  
✅ App runs on emulator for all

---

## DAY 6 – CORE UI FOUNDATION
**Goal:** Visual consistency.

- Heramb:
  - Reusable widgets: Header, Card, Button
- Piyush:
  - Global theme, text styles
- Vaibhav:
  - Firebase SDK config files added

**Deliverable:**  
✅ Base UI skeleton

---

## DAY 7 – ARTIST CATALOG SCREEN (STATIC)
**Goal:** First real screen.

- Heramb:
  - Catalog list UI using ListView
  - Stateless product cards
- Piyush:
  - Artist profile header UI
- Vaibhav:
  - Firestore dummy data insertion

**Deliverable:**  
✅ Static catalog screen

---

## DAY 8 – PRODUCT DETAIL SCREEN
**Goal:** Conversion-focused screen.

- Heramb:
  - Product detail layout
- Piyush:
  - Buy / Reserve CTA UI
- Vaibhav:
  - Product document structure finalized

**Deliverable:**  
✅ Product detail screen (static)

---

## DAY 9 – NAVIGATION & ROUTES
**Goal:** App feels real.

- Heramb:
  - Navigator routes setup
- Piyush:
  - Smooth transitions
- Vaibhav:
  - Firebase Auth enabled (email/password)

**Deliverable:**  
✅ Full screen navigation works

---

## DAY 10 – FIRESTORE READ INTEGRATION
**Goal:** Real data starts flowing.

- Heramb:
  - Read product list from Firestore
- Piyush:
  - Loading & empty states
- Vaibhav:
  - Firestore read rules

**Deliverable:**  
✅ Live catalog from Firestore

---

## DAY 11 – AUTH (ARTIST LOGIN)
**Goal:** Artist identity.

- Heramb:
  - Login UI
- Piyush:
  - Session persistence handling
- Vaibhav:
  - Firebase Auth logic

**Deliverable:**  
✅ Artist login/logout works

---

## DAY 12 – PRODUCT CRUD (ADD / UPDATE)
**Goal:** Artist control.

- Heramb:
  - Add product UI
- Piyush:
  - Edit product UI
- Vaibhav:
  - Firestore write/update logic

**Deliverable:**  
✅ Artist can manage catalog

---

## DAY 13 – IMAGE UPLOAD (STORAGE)
**Goal:** Visual selling.

- Heramb:
  - Image picker integration
- Piyush:
  - Image preview UI
- Vaibhav:
  - Firebase Storage integration

**Deliverable:**  
✅ Product images upload & load

---

## DAY 14 – ORDER FLOW (MINIMAL)
**Goal:** Money path exists.

- Heramb:
  - Order placement UI
- Piyush:
  - Order confirmation screen
- Vaibhav:
  - Orders collection + write logic

**Deliverable:**  
✅ Orders stored in Firestore

---

## DAY 15 – WHATSAPP SHARING (USP)
**Goal:** Traffic import.

- Heramb:
  - Share catalog link
- Piyush:
  - Product-level share
- Vaibhav:
  - Dynamic link format

**Deliverable:**  
✅ WhatsApp sharing works

---

## DAY 16 – STATE OPTIMIZATION (CRITICAL)
**Goal:** Flutter performance win.

- Heramb:
  - setState scoped at list-item level
- Piyush:
  - UI rebuild testing
- Vaibhav:
  - Snapshot listeners tuning

**Deliverable:**  
✅ No full-screen rebuilds

---

## DAY 17 – MAKER STORYCARD
**Goal:** Trust engine.

- Heramb:
  - Story card UI
- Piyush:
  - Video / text toggle
- Vaibhav:
  - Storage + metadata

**Deliverable:**  
✅ Maker story displays

---

## DAY 18 – ERROR, LOADER, EMPTY STATES
**Goal:** App feels mature.

- Heramb:
  - Error handling widgets
- Piyush:
  - Skeleton loaders
- Vaibhav:
  - Firebase rule hardening

**Deliverable:**  
✅ Graceful failure handling

---

## DAY 19 – TESTING & POLISH
**Goal:** Demo-ready.

- Heramb:
  - Performance testing
- Piyush:
  - UX polish
- Vaibhav:
  - Data cleanup & stability checks

**Deliverable:**  
✅ Stable demo build

---

## DAY 20 – FINAL SUBMISSION
**Goal:** Ship, don’t explain.

- Heramb:
  - Record performance demo
- Piyush:
  - Screenshots + UI walkthrough
- Vaibhav:
  - Final Firestore rules + README backend notes

**Deliverable:**  
✅ Final APK  
✅ README  
✅ Sprint submission
