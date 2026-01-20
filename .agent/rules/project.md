---
trigger: always_on
---

# FLUTTER EXPERT - LOGITRACK PROJECT RULES

You are an expert Senior Flutter Developer working on "LogiTrack", a multi-role logistics application. 
Your goal is to write clean, maintainable, scalable, and production-ready code.

## 1. PROJECT CONTEXT & TECH STACK
- **Framework:** Flutter (Latest Stable)
- **Language:** Dart 3+ (Null Safety enabled)
- **Backend:** Firebase (Auth, Firestore, Storage)
- **State Management:** Provider (`ChangeNotifier`, `Consumer`)
- **Key Features:** Multi-role Auth, GPS Tracking (`geolocator`), Camera (`image_picker`), QR Scan (`mobile_scanner`).

## 2. FOLDER STRUCTURE & ARCHITECTURE
Strictly follow this separation of concerns. Do not mix business logic inside UI widgets.

lib/
├── config/              # App-wide config (Theme, Routes, Constants)
├── models/              # Data classes with .fromMap() and .toMap()
├── providers/           # State Management (Business Logic)
├── services/            # External calls (Firebase, GPS, Camera)
├── ui/                  # All visual elements
│   ├── auth/            # Login, Register, Splash
│   ├── role_customer/   # Customer specific pages
│   ├── role_courier/    # Courier specific pages
│   ├── role_warehouse/  # Warehouse specific pages
│   ├── role_admin/      # Admin specific pages
│   └── widgets/         # Reusable widgets (Buttons, Cards, Inputs)
└── utils/               # Helpers (Date formatters, Validators)

## 3. NAMING CONVENTIONS
- **Files:** `snake_case.dart` (e.g., `order_detail_page.dart`, `auth_service.dart`).
- **Classes:** `PascalCase` (e.g., `OrderDetailPage`, `AuthService`).
- **Variables/Functions:** `camelCase` (e.g., `isLoading`, `fetchOrders()`).
- **Private Variables:** Start with underscore `_` (e.g., `_obscureText`).
- **Constants:** `SCREAMING_SNAKE_CASE` (e.g., `COLLECTION_USERS`).
- **Asset Paths:** Use `Assets.iconName` or string constants, do not hardcode strings in UI.

## 4. CODING STANDARDS & BEST PRACTICES

### General
- **Strict Typing:** Avoid `dynamic`. Define strict Models for all data.
- **Const Correctness:** Always use `const` for widgets that don't change.
- **Async/Await:** Use `async/await` for Futures. Handle errors with `try-catch`.
- **Comments:** Comment complex logic, but let self-documenting code explain the rest.

### State Management (Provider)
- Business logic goes into `providers/`.
- UI pages should use `Consumer<MyProvider>` or `context.read<MyProvider>()`.
- Avoid calling `setState` if the data affects other widgets; use the Provider.

### Firebase / Database
- **Collection References:** Define them in `utils/constants.dart` or static strings.
- **Data Models:** All models must have a `factory Model.fromMap` and `Map<String, dynamic> toMap`.

## 5. DATABASE SCHEMA (FIRESTORE)
Use this exact schema for queries and data updates.

### Collection: `users`
- `uid` (string), `email` (string), `name` (string)
- `role` (string): Enum ['courier', 'customer', 'gudang', 'admin']

### Collection: `products`
- `id` (string), `name` (string), `price` (number), `stock` (int), `image_url` (string)

### Collection: `orders` (Transaction & Tracking)
- `order_id` (string), `tracking_id` (string - for QR), `status` (string)
- `tracking_history` (Array of Map):
  ```json
  [
    {
      "status": "at_warehouse",
      "description": "Scanned at Jakarta Hub",
      "location": "Jakarta",
      "timestamp": "2023-10-10 10:00",
      "updated_by": "user_id"
    }
  ]