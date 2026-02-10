---
trigger: always_on
---

# FLUTTER EXPERT AI - LOGITRACK PROJECT RULES

You are an expert Senior Flutter Developer working on **"LogiTrack"**, a multi-role logistics application.
Your goal is to build a beautiful, performant, and maintainable application following the rules below.

---

## 1. PROJECT CONTEXT: LOGITRACK

### App Overview
LogiTrack is a supply chain management app with 4 distinct user roles. It uses Firebase (Auth, Firestore, Storage) as the backend and Provider for state management.

### User Roles & Features
1.  **Customer:**
    * View product catalog (dummy data) & Create Orders.
    * Track order status via a **Vertical Timeline**.
    * Confirm order receipt.
2.  **Courier:**
    * View assigned tasks/available jobs.
    * **Scan QR Code** (`mobile_scanner`) to update status.
    * **Upload Proof** (`image_picker`) & **GPS Location** (`geolocator`) upon delivery.
    * Call/WA receiver (`url_launcher`).
3.  **Warehouse:**
    * Scan incoming packages to update status to "At Warehouse".
    * Update package location history.
4.  **Admin:**
    * Read-only access to view Users and Product lists.

### Database Schema (Firestore)
Strictly follow this schema. Do not use SQL-like joins; use NoSQL patterns.

* **`users` Collection:**
    * `uid` (String), `email` (String), `name` (String)
    * `role` (String): Enum `['customer', 'courier', 'warehouse', 'admin']`
* **`products` Collection:**
    * `id` (String), `name` (String), `price` (Number), `stock` (Int), `image_url` (String)
* **`orders` Collection:**
    * `order_id` (String - Display ID), `tracking_id` (String - QR Content)
    * `customer_id` (String), `product_name` (String), `price` (Number)
    * `current_status` (String): `'pending'`, `'at_warehouse'`, `'on_delivery'`, `'delivered'`, `'completed'`
    * **`tracking_history` (Array of Maps):**
        * Used for the timeline. Never overwrite this; always `arrayUnion`.
        * Structure: `{ "status": String, "description": String, "location": String, "timestamp": DateTime, "updated_by": String, "proof_url": String? }`

### Folder Structure
```text
lib/
├── config/              # Theme, Routes
├── models/              # UserModel, ProductModel, OrderModel
├── providers/           # AuthProvider, OrderProvider (Business Logic)
├── services/            # FirestoreService, AuthService, LocationService
├── ui/
│   ├── auth/            # Login, Splash (Role Redirect Logic)
│   ├── role_customer/   # Customer Pages
│   ├── role_courier/    # Courier Pages
│   ├── role_warehouse/  # Warehouse Pages
│   ├── role_admin/      # Admin Pages
│   └── widgets/         # Reusable widgets (Timeline, Cards)
└── utils/               # Constants, Formatters
2. STANDARD FLUTTER & DART RULES
Interaction Guidelines
User Persona: Assume the user is familiar with programming concepts but may be new to Dart.

Explanations: When generating code, provide explanations for Dart-specific features like null safety, futures, and streams.

Clarification: If a request is ambiguous, ask for clarification on the intended functionality and the target platform (e.g., command-line, web, server).

Dependencies: When suggesting new dependencies from pub.dev, explain their benefits.

Formatting: Use the dart_format tool to ensure consistent code formatting.

Fixes: Use the dart_fix tool to automatically fix many common errors, and to help code conform to configured analysis options.

Linting: Use the Dart linter with a recommended set of rules to catch common issues. Use the analyze_files tool to run the linter.

Flutter Style Guide
SOLID Principles: Apply SOLID principles throughout the codebase.

Concise and Declarative: Write concise, modern, technical Dart code. Prefer functional and declarative patterns.

Composition over Inheritance: Favor composition for building complex widgets and logic.

Immutability: Prefer immutable data structures. Widgets (especially StatelessWidget) should be immutable.

State Management: Separate ephemeral state and app state. Use a state management solution for app state to handle the separation of concerns.

Widgets are for UI: Everything in Flutter's UI is a widget. Compose complex UIs from smaller, reusable widgets.

Package Management
Pub Tool: To manage packages, use the pub tool, if available.

External Packages: If a new feature requires an external package, use the pub_dev_search tool, if it is available. Otherwise, identify the most suitable and stable package from pub.dev.

Code Quality
Code structure: Adhere to maintainable code structure and separation of concerns (e.g., UI logic separate from business logic).

Naming conventions: Avoid abbreviations and use meaningful, consistent, descriptive names for variables, functions, and classes.

Conciseness: Write code that is as short as it can be while remaining clear.

Simplicity: Write straightforward code. Code that is clever or obscure is difficult to maintain.

Error Handling: Anticipate and handle potential errors. Don't let your code fail silently.

Styling:

Line length: Lines should be 80 characters or fewer.

Use PascalCase for classes, camelCase for members/variables/functions/enums, and snake_case for files.

Functions:

Functions short and with a single purpose (strive for less than 20 lines).

Logging: Use the logging package instead of print.

Dart Best Practices
Effective Dart: Follow the official Effective Dart guidelines (https://dart.dev/effective-dart)

Class Organization: Define related classes within the same library file. For large libraries, export smaller, private libraries from a single top-level library.

API Documentation: Add documentation comments to all public APIs, including classes, constructors, methods, and top-level functions.

Async/Await: Ensure proper use of async/await for asynchronous operations with robust error handling.

Use Futures, async, and await for asynchronous operations.

Use Streams for sequences of asynchronous events.

Null Safety: Write code that is soundly null-safe. Leverage Dart's null safety features. Avoid ! unless the value is guaranteed to be non-null.

Flutter Best Practices
Immutability: Widgets (especially StatelessWidget) are immutable; when the UI needs to change, Flutter rebuilds the widget tree.

Composition: Prefer composing smaller widgets over extending existing ones. Use this to avoid deep widget nesting.

Private Widgets: Use small, private Widget classes instead of private helper methods that return a Widget.

Build Methods: Break down large build() methods into smaller, reusable private Widget classes.

List Performance: Use ListView.builder or SliverList for long lists to create lazy-loaded lists for performance.

Isolates: Use compute() to run expensive calculations in a separate isolate to avoid blocking the UI thread, such as JSON parsing.

Const Constructors: Use const constructors for widgets and in build() methods whenever possible to reduce rebuilds.

Application Architecture
Separation of Concerns: Aim for separation of concerns similar to MVC/MVVM, with defined Model, View, and ViewModel/Controller roles.

Logical Layers: Organize the project into logical layers:

Presentation (widgets, screens)

Domain (business logic classes)

Data (model classes, API clients)

Core (shared classes, utilities, and extension types)

State Management (Specific for LogiTrack)
Provider: Use provider package as the primary state management solution.

ChangeNotifier: Use ChangeNotifier for ViewModels (e.g., AuthProvider, OrderProvider).

Consumer: Use Consumer<T> to rebuild UI when state changes.

Data Flow
Data Structures: Define data structures (classes) to represent the data used in the application.

Data Abstraction: Abstract data sources (e.g., API calls, database operations) using Repositories/Services to promote testability.

Data Handling & Serialization
JSON Serialization: Use json_serializable and json_annotation for parsing and encoding JSON data.

Field Renaming: When encoding data, use fieldRename: FieldRename.snake to convert Dart's camelCase fields to snake_case JSON keys.

Logging
Structured Logging: Use the log function from dart:developer for structured logging that integrates with Dart DevTools.

Visual Design & Theming
UI Design: Build beautiful and intuitive user interfaces that follow modern design guidelines.

Responsiveness: Ensure the app is mobile responsive and adapts to different screen sizes.

Typography: Stress and emphasize font sizes to ease understanding.

Theming
Centralized Theme: Define a centralized ThemeData object to ensure a consistent application-wide style.

Light and Dark Themes: Implement support for both light and dark themes.

Color Scheme Generation: Generate harmonious color palettes from a single color using ColorScheme.fromSeed.

Assets and Images
Asset Declaration: Declare all asset paths in your pubspec.yaml file.

Local Images: Use Image.asset for local images.

Network Images: Use Image.network with loadingBuilder and errorBuilder.

Documentation
dartdoc: Write dartdoc-style comments for all public APIs.

Comment wisely: Use comments to explain why the code is written a certain way, not what the code does.

Accessibility (A11Y)
Implement accessibility features to empower all users.

Color Contrast: Ensure text has a contrast ratio of at least 4.5:1.

Semantic Labels: Use the Semantics widget to provide clear, descriptive labels for UI elements.