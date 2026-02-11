import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'config/theme.dart';
import 'config/routes.dart';
import 'firebase_options.dart'; 

import 'providers/auth_provider.dart';
import 'providers/order_provider.dart';
import 'providers/product_provider.dart';
import 'providers/admin_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    debugPrint("✅ .env loaded successfully");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("✅ Firebase initialized successfully");

    // Konfigurasi Firestore untuk Web
    if (kIsWeb) {
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: false,  // Disable offline cache di web
      );
      debugPrint("✅ Firestore settings configured for Web");
    }

    // Test koneksi Firestore
    try {
      debugPrint("🔄 Testing Firestore connection...");
      final testDoc = await FirebaseFirestore.instance
          .collection('users')
          .limit(1)
          .get(const GetOptions(source: Source.server));
      debugPrint("✅ Firestore connected! Found ${testDoc.docs.length} docs");
    } catch (firestoreError) {
      debugPrint("⚠️ Firestore connection test failed: $firestoreError");
      debugPrint("⚠️ App will continue but Firestore may not work correctly");
    }
  } catch (e, stackTrace) {
    debugPrint("❌ Initialization Error: $e");
    debugPrint("❌ Stack Trace: $stackTrace");
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Firebase Init Error:\n$e',
              style: const TextStyle(color: Colors.red)),
        ),
      ),
    ));
    return;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: MaterialApp(
        title: 'LogiTrack',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}